
module Stargate
  module Protocol
    # --- CHANNELS ---
    # [STARGATE_MOMENT] -> Machine/IA (Technical state)
    # [STARGATE_VIEW]   -> Human (Semantic narrative)
    # [STARGATE_TRACE]  -> Reserved (Post-mortem/Replay)

    def self.emit_moment(address, state_packet, seed, moment_type = 'tick')
        payload = {
          type: "moment",
          address: address,
          hash: state_packet ? state_packet[:hash] : nil,
          seed: seed,
          metadata: {
            observed_at: {
              tick: ($gtk.args.state.tick_count rescue 0),
              monotonic_ms: Time.now.to_f * 1000
            },
            rng_calls: Stargate::Random.calls_this_frame,
            moment_type: moment_type
          }
        }

        write_machine(:MOMENT, payload)
        
        # We trace this moment visually for the human as a narrative event
        # but only if it's not a standard tick to avoid noise.
        # REFINEMENT: Heartbeats are life, but logging them creates noise. Silence them.
        if moment_type != 'tick' && moment_type != 'heartbeat'
          icon = case moment_type
                 when 'stasis'    then "💤"
                 else "🌀"
                 end
          Stargate.intent(:trace, { message: "#{icon} Stargate: #{moment_type.capitalize} at #{address}" }, source: :system)
        end
      end

      def self.emit_divergence(address, expected_hash, actual_hash)
        payload = {
          type: "divergence",
          address: address,
          expected: expected_hash,
          actual: actual_hash,
          observed_at: {
            tick: ($gtk.args.state.tick_count rescue 0),
            monotonic_ms: Time.now.to_f * 1000
          }
        }
        
        write_machine(:DIVERGENCE, payload)
        Stargate.intent(:divergence, payload, source: :system)
      end

      def self.emit_branch(new_id, parent_id, divergence_frame)
        payload = {
          type: "branch",
          id: new_id,
          parent: parent_id,
          divergence: divergence_frame,
          observed_at: {
            tick: ($gtk.args.state.tick_count rescue 0),
            monotonic_ms: Time.now.to_f * 1000
          }
        }
        
        write_machine(:BRANCH, payload)
        Stargate.intent(:trace, { message: "Timeline Branch Created: #{new_id}" }, source: :system)
      end

      # --- LOW LEVEL IO ---

      def self.write_machine(type, payload)
        # REFINEMENT: Silence the heartbeat for the machine too, unless debugging.
        # This prevents the console from scrolling endlessly with JSON.
        return if type == :MOMENT && !$stargate_debug

        serialized = payload.respond_to?(:to_json) ? payload.to_json : payload.inspect
        # Technical telemetry is written to stdout but hidden in common console views if possible.
        # For now, we use the agreed [STARGATE_MOMENT] prefix for machines.
        puts "[STARGATE_#{type}] #{serialized}"
      end

      def self.write_view(payload)
        # 1. Technical Telemetry (JSON) - Only if in debug mode to avoid noise
        if $stargate_debug
          serialized = payload.respond_to?(:to_json) ? payload.to_json : payload.inspect
          puts "[STARGATE_VIEW] #{serialized}"
        end

        # 2. Human narrative: Only report alerts, divergences or meaningful system changes.
        event_data = payload[:event]
        is_alert = payload[:entity_id] == :stargate_alert || (event_data && event_data[:type] == :alert)
        if event_data && (event_data[:level] == :error || event_data[:level] == :warning || is_alert)
          message = event_data.dig(:data, :message) || event_data[:message]
          puts "🛑 STARGATE ALERT: #{message}" if message
        end
      end

      def self.write_trace(payload)
        serialized = payload.respond_to?(:to_json) ? payload.to_json : payload.inspect
        # Reserved channel. No-op for now in console, but ready for file logging.
        # puts "[STARGATE_TRACE] #{serialized}"
      end
  end
end
