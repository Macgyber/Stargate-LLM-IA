# frozen_string_literal: true

module Stargate
  module Clock
    @current_branch = "prime" # UUID for the main timeline
    @current_frame  = 0
    @branch_forest   = {}      # Memory of all branch relationships

    class << self
      attr_reader :current_branch, :current_frame

      def tick(args)
        # Law XVII: Continuous Determinism via Seed Locking
        # We use a deterministic seed derived from tick_count.
        frame_seed = (args.state.tick_count + 1) * 1000
        
        with_frame(frame_seed, args.inputs) do
          yield if block_given?
        end
      end

      def with_frame(seed, inputs)
        if @paused
          is_heartbeat = ($gtk.args.state.tick_count % 60 == 0)
          Protocol.emit_moment(current_address, { hash: "PAUSED" }, seed, "stasis") if is_heartbeat
          return :paused
        end

        if @last_authoritative_hash
          current_raw = $gtk.serialize_state
          current_hash = "#{current_raw.length}_#{current_raw.hash}"
          if current_hash != @last_authoritative_hash
            Protocol.emit_divergence(current_address, @last_authoritative_hash, current_hash)
            pause!
            return :divergence
          end
        end

        Random.begin_frame(seed)

        # Law of the Frontier: Speculative state must be isolated.
        Injection.checkpoint

        begin
          Injection.perform_injections

          yield if block_given?

          # Law of Authority: The frame represents the state AFTER execution.
          @current_frame += 1
          
          # HEARTBEAT & CAUSAL CAPTURE
          # We only capture if the state is "dirty" or during the 60-tick Heartbeat.
          is_heartbeat = ($gtk.args.state.tick_count % 60 == 0)
          
          if State.dirty? || is_heartbeat
            # If it's a heartbeat, we just confirm "respiration" (Integrity check)
            # if it's dirty, we capture the transition outcome.
            if State.dirty?
              state_packet = State.capture
              if state_packet && State.last_causal_node
                State.last_causal_node.instance_variable_set(:@outcome, state_packet[:hash])
                @last_authoritative_hash = state_packet[:hash]
                Protocol.emit_moment(current_address, state_packet, seed)
              end
            elsif is_heartbeat
              # Minimal respiration pulse (no state capture)
              Protocol.emit_moment(current_address, nil, seed, "heartbeat")
            end
            
            # Clean orphans/flags for the next cycle
            State.clear_dirty!
          end

          :ok
        rescue => e
          Stargate.intent(:alert, { message: "CLOCK ERROR: #{e.message}", trace: e.backtrace.first }, source: :system)
          Injection.rollback!
          :error
        end
      end

      def current_address
        "#{@current_branch}@#{@current_frame}"
      end

      # Fork the timeline (branching)
      # Sovereign Law: Branching requires a hash to anchor authority.
      def branch!(divergence_frame, parent_id = @current_branch, hash:)
        # Law of Isolation: Branches start with a clean slate of intentions.
        Injection.reset!
        
        new_id = "branch_#{(Time.now.to_f * 1000).to_i}_#{rand(1000)}"
        @branch_forest[new_id] = {
          parent: parent_id,
          divergence: divergence_frame,
          head: divergence_frame
        }
        Protocol.emit_branch(new_id, parent_id, divergence_frame)
        
        @current_branch = new_id
        @current_frame = divergence_frame
        @last_authoritative_hash = hash
        new_id
      end

      def restore_moment(branch_id, frame, hash, seed)
        # Law of Restoration: Speculative state must die.
        Injection.rollback!
        Injection.reset!
        @last_authoritative_hash = nil
        
        @current_branch = branch_id
        @current_frame = frame
        
        Stargate.intent(:trace, { message: "⏪ Stargate: Restoring state for #{branch_id}@#{frame} (Hash: #{hash})" }, source: :system)
        
        data = State.load_from_disk(hash)
        if data
          State.apply(data)
          @last_authoritative_hash = hash
          # Ensure RNG is also restored to this point
          Random.begin_frame(seed)
          :ok
        else
          Stargate.intent(:alert, { message: "❌ ERROR: State blob #{hash} not found on disk!" }, source: :system)
          :error
        end
      end

      def pause!
        @paused = true
        Random.reset!
        Stargate.intent(:trace, { message: "🛑 STARGATE: Simulation PAUSED (Stasis Mode)." }, source: :system)
      end

      def resume!
        @paused = false
        Stargate.intent(:trace, { message: "▶️ STARGATE: Simulation RESUMED." }, source: :system)
      end

      def paused?
        @paused || false
      end

      # Jump to specific coordinates (Internal use or raw jumps)
      def jump_to(branch_id, frame)
        @current_branch = branch_id
        @current_frame = frame
      end

      def tag_frame(tag)
        Stargate.intent(:metadata, { frame: current_address, tag: tag }, source: :system)
      end
    end
  end
end
