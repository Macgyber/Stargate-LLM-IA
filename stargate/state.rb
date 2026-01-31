module Stargate
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

    def self.last_causal_node
      @last_causal_node
    end

    # --- CAUSAL API ---

    # Mark the universe as changed.
    # Sovereign Law: No mutation shall occur without a cause.
    def self.mark_dirty(type, source:, intention:, trace: nil)
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

    def self.dirty?
      @dirty.values.any?
    end

    def self.dirty_types
      @dirty.select { |_, v| v }.keys
    end

    def self.clear_dirty!
      @dirty.each_key { |k| @dirty[k] = false }
      @last_causal_node = nil
    end

    # --- LEGACY/UTILITY API (Hardened for Cross-Platform) ---

    def self.capture
      begin
        raw_data = $gtk.serialize_state
        return nil unless raw_data
        
        hash = "#{raw_data.length}_#{raw_data.hash}"
        save_to_disk(hash, raw_data)
        
        { data: raw_data, hash: hash }
      rescue => e
        # Silently fail if capture is impossible (Anti-Pattern Avoidance)
        nil
      end
    end

    def self.save_to_disk(hash, data)
      return if hash == "000000"
      # DragonRuby's write_file handles directory creation natively (Cross-Platform).
      $gtk.write_file(".stargate/blobs/#{hash}", data)
    end

    def self.load_from_disk(hash)
      data = $gtk.read_file(".stargate/blobs/#{hash}")
      return nil unless data

      # Law of Historical Integrity
      computed = "#{data.length}_#{data.hash}"
      raise "CRITICAL: State Integrity Violation!" if computed != hash
      data
    end

    # Law of Rebirth: Restore reality from raw data.
    # CONTRACT: This is a sovereign operation; it is not automatically reversible.
    def self.apply(raw_data)
      begin
        restored = $gtk.deserialize_state(raw_data)
        if restored
          $gtk.args.state = restored
          :ok
        else
          :divergent
        end
      rescue => e
        :divergent
      end
    end
  end
end
