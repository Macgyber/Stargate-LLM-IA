# frozen_string_literal: true

module Stargate
  module View
    @registry = {}

    # The Golden Rule: A Visual Entity can only be born through the Governor
    # and changed by update. Never by reaction direct.

    class VisualEntity
      attr_reader :id, :last_update

      def initialize(id)
        @id = id
        @last_update = nil
        @born_at = Time.now.to_f
      end

      def update(event)
        @last_update = Time.now.to_f
        # Law of Presence: We emit a persisted-key intent.
        # External observers (Emacs/OS) should use the 'id' to find/update the view.
        payload = {
          type: "visual_update",
          entity_id: @id,
          event: event,
          context_hint: "Search local 'docs/samples/' dir for relevant ingredients.",
          timestamp: @last_update
        }
        
        # Standardized output for the Sovereign Observer
<<<<<<< HEAD
        Protocol.write_view(payload)
=======
        serialized = payload.respond_to?(:to_json) ? payload.to_json : payload.inspect
        puts "[STARGATE_VIEW] #{serialized}"
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
      end
    end

    class << self
      def ensure_entity(id)
        @registry[id] ||= VisualEntity.new(id)
      end

      def render(id, event)
        entity = ensure_entity(id)
        entity.update(event)
      end

      # Higher-level semantic handlers (Event-Driven)
      # Events arrive structured from Stargate.intent → dispatch → here
      def handle_event(event)
        type = event[:type]
        payload = event[:payload]
        
        case type
        when :alert, :state_integrity_violation
          render(:stargate_alert, { 
            level: :error, 
            data: payload, 
            tick: event[:tick],
            source: event[:source]
          })
        when :trace
          render(:stargate_console, { 
            level: :info, 
            data: payload,
            tick: event[:tick],
            source: event[:source]
          })
        when :divergence
          render(:stargate_divergence, { 
            level: :warning, 
            data: payload,
            tick: event[:tick],
            source: event[:source]
          })
        when :boot
          render(:stargate_system, {
            level: :success,
            message: "Stargate activated in #{payload[:mode]} mode",
            tick: event[:tick],
            source: event[:source]
          })
        when :boss_spawn, :victory, :game_over
          # Gameplay events (semantic forwarding to external observers)
          render(:stargate_gameplay, {
            event_type: type,
            data: payload,
            tick: event[:tick],
            source: event[:source]
          })
        else
          render(:stargate_default, { 
            intent: type, 
            data: payload,
            tick: event[:tick],
            source: event[:source]
          })
        end
      end
    end
  end
end
