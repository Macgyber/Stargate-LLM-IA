# frozen_string_literal: true

module Stargate
<<<<<<< HEAD
  # The DNA of a Decision.
  # Represents a single causal transition in the universe.
  class CausalNode
    VALID_SOURCES = [:intent, :injection, :emergent].freeze
    attr_reader :uuid, :source, :intention, :trace, :outcome, :timestamp

    @@seq = 0

    def initialize(source:, intention:, trace: nil, outcome: nil)
      raise ArgumentError, "Invalid source: #{source}" unless VALID_SOURCES.include?(source)

      @@seq += 1
      @source    = source
      @intention = intention
      @trace     = trace
      @outcome   = outcome
      @timestamp = {
        tick: ($gtk.args.state.tick_count rescue 0),
        monotonic: Time.now.to_f
      }
      @uuid = "#{@timestamp[:tick]}_#{@@seq}"
    end

    def to_h
      {
        uuid: @uuid,
        source: @source,
        intention: @intention,
        trace: @trace,
        outcome: @outcome,
        timestamp: @timestamp
      }
    end
  end

  module State
    @dirty = {
      state: false,
      assets: false,
      logic: false,
      timeline: false
    }
    @last_causal_node = nil

    class << self
      attr_reader :last_causal_node

      # --- CAUSAL API ---

      # Mark the universe as changed.
      # Sovereign Law: No mutation shall occur without a cause.
      def mark_dirty(type, source:, intention:, trace: nil)
        return unless @dirty.key?(type)

        @dirty[type] = true
        @last_causal_node = CausalNode.new(
          source: source,
          intention: intention,
          trace: trace
        )
        
        # We don't log or capture here. 
        # We only acknowledge the deviation from stasis.
      end

      def dirty?
        @dirty.values.any?
      end

      def dirty_types
        @dirty.select { |_, v| v }.keys
      end

      def clear_dirty!
        @dirty.each_key { |k| @dirty[k] = false }
        @last_causal_node = nil
      end

      # --- LEGACY/UTILITY API (Hardened for Cross-Platform) ---

      def capture
        begin
          raw_data = $gtk.serialize_state
          return nil unless raw_data
          
=======
  module State
    class << self
      def capture
        begin
          raw_data = $gtk.serialize_state
          unless raw_data
            puts "[STARGATE_WARNING] Serialization returned EMPTY data."
            return nil
          end
          
          # Law of Compatibility: Use Ruby's internal hash and length if sha256 is unavailable.
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
          hash = "#{raw_data.length}_#{raw_data.hash}"
          save_to_disk(hash, raw_data)
          
          { data: raw_data, hash: hash }
        rescue => e
<<<<<<< HEAD
          # Silently fail if capture is impossible (Anti-Pattern Avoidance)
=======
          puts "[STARGATE_ERROR] State Capture Failed: #{e.message}"
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
          nil
        end
      end

      def save_to_disk(hash, data)
        return if hash == "000000"
<<<<<<< HEAD
        # DragonRuby's write_file handles directory creation natively (Cross-Platform).
=======
        # Law of Persistence: Ensure the vault exists.
        $gtk.system("mkdir -p .stargate_AI/blobs") if $gtk
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
        $gtk.write_file(".stargate_AI/blobs/#{hash}", data)
      end

      def load_from_disk(hash)
        data = $gtk.read_file(".stargate_AI/blobs/#{hash}")
        return nil unless data

<<<<<<< HEAD
        # Law of Historical Integrity
        computed = "#{data.length}_#{data.hash}"
        raise "CRITICAL: State Integrity Violation!" if computed != hash
        data
      end

      # Law of Rebirth: Restore reality from raw data.
      # CONTRACT: This is a sovereign operation; it is not automatically reversible.
      def apply(raw_data)
        begin
=======
        # Law of Historical Integrity: Never apply a corrupted blob.
        computed = "#{data.length}_#{data.hash}"
        if computed != hash
          raise "CRITICAL: State Integrity Violation! Hash mismatch for #{hash} (Computed: #{computed})"
        end
        data
      end

      def apply(raw_data)
        begin
          # Restore the state into DragonRuby's args.state
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
          restored = $gtk.deserialize_state(raw_data)
          if restored
            $gtk.args.state = restored
            :ok
          else
            :divergent
          end
        rescue => e
<<<<<<< HEAD
=======
          $gtk.console.log "ERROR: Stargate State Apply Divergence: #{e.message}"
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
          :divergent
        end
      end
    end
  end
end
