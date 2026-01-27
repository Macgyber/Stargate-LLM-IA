# frozen_string_literal: true

module Stargate
  module Protocol
    class << self
<<<<<<< HEAD
      # --- CHANNELS ---
      # [STARGATE_MOMENT] -> Machine/IA (Technical state)
      # [STARGATE_VIEW]   -> Human (Semantic narrative)
      # [STARGATE_TRACE]  -> Reserved (Post-mortem/Replay)

      def emit_moment(address, state_packet, seed, moment_type = 'tick')
        payload = {
          type: "moment",
          address: address,
          hash: state_packet ? state_packet[:hash] : nil,
          seed: seed,
          metadata: {
            observed_at: {
              tick: ($gtk.args.state.tick_count rescue 0),
=======
      def emit_moment(address, state_packet, seed, moment_type = 'tick')
        return unless $gtk
        return unless state_packet

        # Law of Fidelity: The Protocol DOES NOT filter moments.
        # Every moment is a historical truth.

        payload = {
          type: "moment",
          address: address,
          hash: state_packet[:hash],
          seed: seed,
          metadata: {
            observed_at: {
              tick: $gtk.args.state.tick_count,
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
              monotonic_ms: Time.now.to_f * 1000
            },
            rng_calls: Stargate::Random.calls_this_frame,
            moment_type: moment_type
          }
        }

<<<<<<< HEAD
        write_machine(:MOMENT, payload)
        
        # We trace this moment visually for the human as a narrative event
        # but only if it's not a standard tick to avoid noise.
        if moment_type != 'tick'
          icon = case moment_type
                 when 'heartbeat' then "💓"
                 when 'stasis'    then "💤"
                 else "🌀"
                 end
          Stargate.intent(:trace, { message: "#{icon} Stargate: #{moment_type.capitalize} at #{address}" }, source: :system)
        end
      end

      def emit_divergence(address, expected_hash, actual_hash)
=======
        puts "[STARGATE_MOMENT] #{payload.to_json}"
        
        # We trace this moment visually
        Stargate.intent(:trace, payload, source: :system)
      end

      def emit_divergence(address, expected_hash, actual_hash)
        return unless $gtk
        
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
        payload = {
          type: "divergence",
          address: address,
          expected: expected_hash,
          actual: actual_hash,
          observed_at: {
<<<<<<< HEAD
            tick: ($gtk.args.state.tick_count rescue 0),
=======
            tick: $gtk.args.state.tick_count,
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
            monotonic_ms: Time.now.to_f * 1000
          }
        }
        
<<<<<<< HEAD
        write_machine(:DIVERGENCE, payload)
=======
        puts "[STARGATE_DIVERGENCE] #{payload.to_json}"
        
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
        Stargate.intent(:divergence, payload, source: :system)
      end

      def emit_branch(new_id, parent_id, divergence_frame)
<<<<<<< HEAD
=======
        return unless $gtk

>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
        payload = {
          type: "branch",
          id: new_id,
          parent: parent_id,
          divergence: divergence_frame,
          observed_at: {
<<<<<<< HEAD
            tick: ($gtk.args.state.tick_count rescue 0),
=======
            tick: $gtk.args.state.tick_count,
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
            monotonic_ms: Time.now.to_f * 1000
          }
        }
        
<<<<<<< HEAD
        write_machine(:BRANCH, payload)
        Stargate.intent(:trace, { message: "Timeline Branch Created: #{new_id}" }, source: :system)
      end

      # --- LOW LEVEL IO ---

      def write_machine(type, payload)
        serialized = payload.respond_to?(:to_json) ? payload.to_json : payload.inspect
        # Technical telemetry is written to stdout but hidden in common console views if possible.
        # For now, we use the agreed [STARGATE_MOMENT] prefix for machines.
        puts "[STARGATE_#{type}] #{serialized}"
      end

      def write_view(payload)
        # Technical telemetry for the IA (JSON)
        serialized = payload.respond_to?(:to_json) ? payload.to_json : payload.inspect
        puts "[STARGATE_VIEW] #{serialized}"

        # Human-friendly output for the DragonRuby Console
        if payload[:entity_id] == :stargate_console
          message = payload.dig(:event, :data, :message)
          puts "  #{message}" if message
        end
      end

      def write_trace(payload)
        serialized = payload.respond_to?(:to_json) ? payload.to_json : payload.inspect
        # Reserved channel. No-op for now in console, but ready for file logging.
        # puts "[STARGATE_TRACE] #{serialized}"
=======
        puts "[STARGATE_BRANCH] #{payload.to_json}"

        Stargate.intent(:trace, payload, source: :system)
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
      end
    end
  end
end
