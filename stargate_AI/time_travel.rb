# frozen_string_literal: true

module Stargate
  module TimeTravel
    @last_valid_capsule = nil
    @recall_history = []
    
    class << self
      attr_reader :last_valid_capsule, :recall_history
      # Law of the Capsule: Evidence must be packed with its context.
      def capture_moment(args)
        begin
          state_packet = Stargate::State.capture
          return nil unless state_packet

          capsule = {
            tick: $gtk.args.state.tick_count,
            seed: Stargate::Random.current_seed,
            hash: state_packet[:hash],
            timestamp: Time.now.to_i
          }

          # In a "Time First" strategy, we log the capsule creation as a sovereign event.
          $gtk.console.log "🌌 Stargate: Moment Captured @ T=#{capsule[:tick]} [Hash: #{capsule[:hash]}]"
          @last_valid_capsule = capsule
          capsule
        rescue => e
          $gtk.console.log "❌ ERROR: Capture failed: #{e.message}"
          nil
        end
      end

      # Law of Reversibility: Restoration is a rewrite of reality.
      def recall_moment(capsule)
        begin
          $gtk.console.log "⏪ Stargate: Initiating Recall to T=#{capsule[:tick]}..."
          
          # 1. Stop the world
          Stargate::Clock.pause!

          # 2. Re-hydrate the state
          # Clock.restore_moment already handles the heavy lifting of loading and applying.
          result = Stargate::Clock.restore_moment(
            Stargate::Clock.current_branch, 
            capsule[:tick], 
            capsule[:hash], 
            capsule[:seed]
          )

          if result == :ok
            $gtk.console.log "✅ Stargate: Recall Successful. Reality has been synchronized."
            @recall_history << { tick: capsule[:tick], success: true, at: Time.now.to_i }
            Stargate::Clock.resume!
            true
          else
            $gtk.console.log "❌ ERROR: Recall Diverged. Universe is in stasis."
            @recall_history << { tick: capsule[:tick], success: false, at: Time.now.to_i }
            false
          end
        rescue => e
          $gtk.console.log "❌ CRITICAL: Recall Failure: #{e.message}"
          false
        end
      end
    end
  end
end
