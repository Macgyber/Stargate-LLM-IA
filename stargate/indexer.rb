# frozen_string_literal: true

module Stargate
  # 📖 INDEXER: The Umbilical Cord (Cordón Umbilical)
  # "No existe código sin su índice y no existe índice sin su código."
  # v2.3 - Primitive & Bulletproof Gemini Sync
  module Indexer
    @index_file = "stargate/index.yaml"
    @main_file  = "app/main.rb"

    class << self
      def sync!(args)
        return unless args
        
        # 1. Read Current State
        main_code = $gtk.read_file(@main_file)
        index_data = $gtk.read_file(@index_file)
        return unless main_code && index_data

        # 2. Extract Nodes from Source Code (@node: id)
        # Using ONLY string methods for mruby compatibility
        code_nodes = []
        main_code.split("\n").each do |line|
          if line.include?("@node:")
            # Extract word after @node:
            after_node = line.split("@node:").last.strip
            # Take the first word (delimited by space, comma, or end of line)
            node_id = after_node.split(" ").first.split(",").first.split("\r").first
            code_nodes << node_id.strip if node_id && !node_id.empty?
          end
        end

        # 3. Extract Nodes from YAML Index (Block-based String Scanning)
        # We manually parse the YAML structure without Regex
        yaml_nodes = []
        
        # Split by "- id:" at the start of lines
        raw_blocks = index_data.split("\n- id:")
        # The first block might contain headers, so we handle the first one specially
        # or we ensure every block we process starts with an ID.
        
        # Actually, let's use a simpler marker
        index_data.split("\n").each do |line|
          trimmed = line.strip
          if trimmed.start_with?("- id:")
            node_id = trimmed.split("- id:").last.strip.split(" ").first
            # We want to know if this node belongs to main.rb
            # This requires knowing which block we are in.
            # Let's use a more stateful approach.
          end
        end

        # REFINED STATEFUL PARSER (NO REGEX)
        yaml_ids_in_main = []
        current_id = nil
        is_main_impl = false
        
        index_data.split("\n").each do |line|
          trimmed = line.strip
          if trimmed.start_with?("- id:")
            # Save previous node if it was in main.rb
            yaml_ids_in_main << current_id if current_id && is_main_impl
            
            current_id = trimmed.split("id:").last.strip
            is_main_impl = false
          elsif trimmed.start_with?("- app/main.rb") || trimmed == "app/main.rb"
            is_main_impl = true
          elsif trimmed.include?("app/main.rb") && trimmed.start_with?("-")
             is_main_impl = true
          end
        end
        # Capture last
        yaml_ids_in_main << current_id if current_id && is_main_impl

        # 4. Bi-Directional Verification (The Umbilical Cord)
        
        # A. Leak: Node in code but not in index
        # (We compare against ALL ids found in index to be safe)
        all_yaml_ids = []
        index_data.split("\n").each do |line|
          if line.include?("id:") && line.include?("-")
             id = line.split("id:").last.strip.split(" ").first
             all_yaml_ids << id if id
          end
        end

        leaks = []
        code_nodes.each do |cn|
           leaks << cn unless all_yaml_ids.include?(cn)
        end

        if leaks.any?
          Stargate::Vigilante.shout!(:twin_leak, "Umbilical Leak: Nodes [#{leaks.join(', ')}] found in code but missing from Index.")
          return
        end

        # B. Ghost: Node in index but not in code
        ghosts = []
        yaml_ids_in_main.each do |yn|
          ghosts << yn unless code_nodes.include?(yn)
        end

        if ghosts.any?
          Stargate::Vigilante.shout!(:ghost_node, "Umbilical Ghost: Index expects nodes [#{ghosts.join(', ')}] in app/main.rb but they are missing.")
          return
        end

        # Gemini Success: The cord is pulsing with life.
      end
    end
  end
end
