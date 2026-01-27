# frozen_string_literal: true

module Stargate
  # module Recording
  # This module monitors DragonRuby's native recording/replay states.
  module Recording
    @last_recording_state = false
    @last_replay_state = false

    class << self
      def tick(args)
        return unless $gtk

        check_recording_state(args)
        check_replay_state(args)
      end

      private

      def check_recording_state(args)
        is_recording = $gtk.respond_to?(:recording?) && $gtk.recording?
        
        if is_recording && !@last_recording_state
          Stargate.intent(:recording_start, { message: "🔴 DragonRuby: Session Recording Started." }, source: :system)
          # Inform the causality layer that we are in a 'Golden' timeline segment
          Stargate::Clock.tag_frame("recorded") if Stargate.const_defined?(:Clock)
        elsif !is_recording && @last_recording_state
          Stargate.intent(:recording_stop, { message: "⚪ DragonRuby: Session Recording Stopped." }, source: :system)
        end
        
        @last_recording_state = is_recording
      end

      def check_replay_state(args)
        is_replaying = $gtk.respond_to?(:replaying?) && $gtk.replaying?

        if is_replaying && !@last_replay_state
          Stargate.intent(:replay_start, { message: "🔵 DragonRuby: Replay mode ACTIVE." }, source: :system)
          # In replay mode, we might want to suppress certain injections or focus on observation
        elsif !is_replaying && @last_replay_state
          Stargate.intent(:replay_stop, { message: "⚪ DragonRuby: Replay mode DEACTIVATED." }, source: :system)
        end

        @last_replay_state = is_replaying
      end
    end
  end
end
