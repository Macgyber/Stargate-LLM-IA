module Stargate
  module LedgerKeeper
    LEDGER_FILE = "stargate/ledger.yaml"
    APP_ROOT    = "app"

    # =========================
    # ENTRY POINT
    # =========================
    def self.audit!
      now = Time.now.to_i

      observed = scan_app_for_nodes
      ledger   = load_ledger(now)

      grace = (ledger["metadata"]["grace_period"] || 2).to_i

      # -------------------------
      # BIRTHS & MIGRATIONS
      # -------------------------
      observed.each do |id, file|
        if ledger["nodes_by_id"][id]
          node = ledger["nodes_by_id"][id]

          node["last_seen"] = now
          node["missing_count"] = 0

          if node["current_file"] != file
            node["current_file"] = file
          end
        else
          # New birth -> pending
          new_node = {
            "id" => id,
            "current_file" => file,
            "first_seen" => now,
            "last_seen" => now,
            "missing_count" => 0,
            "status" => "pending"
          }

          ledger["nodes"] << new_node
          ledger["nodes_by_id"][id] = new_node
        end
      end

      # -------------------------
      # ABSENCES & AMPUTATIONS
      # -------------------------
      ledger["nodes"].each do |node|
        unless observed[node["id"]]
          node["missing_count"] ||= 0
          node["missing_count"] += 1

          if node["missing_count"] >= grace
            node["status"] = "ghost"
          end
        end
      end

      # -------------------------
      # PERSIST MEMORY
      # -------------------------
      ledger["metadata"]["last_audit"] = now
      save_ledger(ledger)

      # -------------------------
      # ENFORCEMENT
      # -------------------------
      enforce_stasis!(ledger)
    end

    # =========================
    # SCAN FILESYSTEM
    # =========================
    def self.scan_app_for_nodes
      nodes = {}

      files = list_rb_files(APP_ROOT)
      files.each do |file|
        content = $gtk.read_file(file)
        next unless content

        content.split("\n").each do |line|
          next unless line.include?("@node:")

          # Extraction logic (mruby-safe)
          parts = line.split("@node:")
          id_part = parts.last
          if id_part
            id = id_part.strip.split(" ").first
            nodes[id] = file if id && id != ""
          end
        end
      end

      nodes
    end

    def self.list_rb_files(dir)
      result = []
      $gtk.list_files(dir).each do |path|
        # DragonRuby list_files returns relative paths to the directory passed
        full_path = "#{dir}/#{path}"
        if path.end_with?(".rb")
          result << full_path
        elsif !path.include?(".") # Simple directory check (DragonRuby specific)
          # We check if it's a directory by listing it
          children = $gtk.list_files(full_path)
          if children && children.any?
             result += list_rb_files(full_path)
          end
        end
      end
      result
    end

    # =========================
    # LEDGER IO (PRIMITIVE)
    # =========================
    def self.load_ledger(now)
      content = $gtk.read_file(LEDGER_FILE)
      if content
        parse_ledger(content)
      else
        create_empty_ledger(now)
      end
    end

    def self.create_empty_ledger(now)
      ledger = {
        "metadata" => {
          "version" => "1.0.0",
          "last_audit" => now,
          "grace_period" => 2
        },
        "nodes" => []
      }
      ledger["nodes_by_id"] = {}
      ledger
    end

    # YAML PARSER PRIMITIVO (mruby-safe)
    def self.parse_ledger(text)
      ledger = {
        "metadata" => {},
        "nodes" => [],
        "nodes_by_id" => {}
      }

      current_node = nil
      section = nil

      text.split("\n").each do |line|
        t = line.strip
        next if t == "" || t.start_with?("#")

        if t == "metadata:"
          section = "metadata"
        elsif t == "nodes:"
          section = "nodes"
        elsif t.start_with?("- id:")
          current_node = { "id" => t.split("id:").last.strip }
          ledger["nodes"] << current_node
          ledger["nodes_by_id"][current_node["id"]] = current_node
        elsif section == "metadata"
          if t.include?(":")
            k, v = t.split(":").map(&:strip)
            ledger["metadata"][k] = (v.to_i.to_s == v ? v.to_i : v)
          end
        elsif current_node
          if t.include?(":")
            k, v = t.split(":").map(&:strip)
            current_node[k] = (v.to_i.to_s == v ? v.to_i : v)
          end
        end
      end

      ledger
    end

    def self.save_ledger(ledger)
      lines = []
      lines << "metadata:"
      ledger["metadata"].each do |k, v|
        lines << "  #{k}: #{v}"
      end

      lines << "nodes:"
      ledger["nodes"].each do |n|
        lines << "  - id: #{n['id']}"
        n.each do |k, v|
          next if k == "id"
          lines << "    #{k}: #{v}"
        end
      end

      $gtk.write_file(LEDGER_FILE, lines.join("\n"))
    end

    # =========================
    # STASIS
    # =========================
    def self.enforce_stasis!(ledger)
      pending = []
      ghosts  = []

      ledger["nodes"].each do |n|
        pending << n if n["status"] == "pending"
        ghosts  << n if n["status"] == "ghost"
      end

      if pending.any? || ghosts.any?
        msg = "Ledger Stasis Invoked.\n"
        msg += "Pending Sanction: #{pending.map { |n| n['id'] }.join(', ')}\n" if pending.any?
        msg += "Ghost Nodes (Amputed): #{ghosts.map { |n| n['id'] }.join(', ')}" if ghosts.any?
        
        Stargate::Vigilante.shout!(:ledger_violation, msg)
      end
    end
  end
end
