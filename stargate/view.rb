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

        Protocol.write_view(payload)
      end
    end

    def self.ensure_entity(id)
      @registry[id] ||= VisualEntity.new(id)
    end

    def self.render(id, event)
      entity = ensure_entity(id)
      entity.update(event)
    end

    # Higher-level semantic handlers (Event-Driven)
    # Events arrive structured from Stargate.intent → dispatch → here
    def self.handle_event(event)
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

    def self.draw_stasis(args)
      violation = Stargate::Vigilante.violation
      return unless violation

      # 1. Dark Void
      args.outputs.solids << [0, 0, 1280, 720, 10, 5, 5]
      
      # 2. Sovereign Borders (Gold/Blood Gradient)
      args.outputs.solids << [0, 680, 1280, 40, 150, 0, 0]
      args.outputs.solids << [0, 0, 1280, 40, 150, 0, 0]
      
      # 3. Judgement Header
      args.outputs.labels << [640, 660, "🛑 VIGILANTE INTERRUPT: SOVEREIGN STASIS", 10, 1, 255, 255, 255]
      
      # 4. Violation Details
      args.outputs.labels << [640, 450, "ID: #{(violation[:type] || 'UNKNOWN').to_s.upcase}", 5, 1, 255, 100, 100]
      args.outputs.labels << [640, 400, (violation[:message] || 'No detail available'), 2, 1, 230, 230, 230]
      
      # 5. Causal Context
      args.outputs.labels << [640, 320, "DEBT RECORDED AT TICK: #{violation[:tick] || 0}", 0, 1, 150, 150, 150]
      
      # 6. Ritual of Purification Instructions
      pulse = (Math.sin(Time.now.to_f * 5) * 50 + 205).to_i
      args.outputs.labels << [640, 150, "PAY CAUSAL DEBT: REPAIR CODE AND PRESS [R]", 3, 1, 255, 215, 0, pulse]
      
      # 7. Error Icon
      args.outputs.sprites << { x: 590, y: 500, w: 100, h: 100, path: 'sprites/dragonruby.png', r: 255, g: 50, b: 50 }
      
      if args.inputs.keyboard.key_down.r
        Stargate.reset_world!
      end
    end
  end
end
