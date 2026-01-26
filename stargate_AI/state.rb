# frozen_string_literal: true

module Stargate
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
          hash = "#{raw_data.length}_#{raw_data.hash}"
          save_to_disk(hash, raw_data)
          
          { data: raw_data, hash: hash }
        rescue => e
          puts "[STARGATE_ERROR] State Capture Failed: #{e.message}"
          nil
        end
      end

      def save_to_disk(hash, data)
        return if hash == "000000"
        # Law of Persistence: Ensure the vault exists.
        $gtk.system("mkdir -p .stargate_AI/blobs") if $gtk
        $gtk.write_file(".stargate_AI/blobs/#{hash}", data)
      end

      def load_from_disk(hash)
        data = $gtk.read_file(".stargate_AI/blobs/#{hash}")
        return nil unless data

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
          restored = $gtk.deserialize_state(raw_data)
          if restored
            $gtk.args.state = restored
            :ok
          else
            :divergent
          end
        rescue => e
          $gtk.console.log "ERROR: Stargate State Apply Divergence: #{e.message}"
          :divergent
        end
      end
    end
  end
end
