module Stargate
  module Avatar
    # Law 7 & 10.1: Ensure a visual pulse even in stasis or crash.
    def self.render(args, fail_safe: nil)
      outputs = args.outputs

      # LEY 10.1 — Error Visual Fallback
      if fail_safe
        outputs.solids << [0, 0, 1280, 720, 80, 0, 0]
        outputs.labels << {
          x: 20, y: 700,
          text: "🛑 STARGATE FAIL-SAFE",
          size_enum: 6,
          r: 255, g: 255, b: 255
        }
        outputs.labels << {
          x: 20, y: 660,
          text: "#{fail_safe.class}: #{fail_safe.message}",
          r: 255, g: 200, b: 200
        }
        return
      end

      # LEY 7 — Pulso mínimo permanente (Sovereign)
      outputs.labels << {
        x: 10, y: 20,
        text: "🌌 Stargate Alive",
        size_enum: -2,
        r: 100, g: 100, b: 255,
        a: 180
      }

      # --- FASE 3: OBSERVER OVERLAY (Passive) ---
      # 1. Pulso Médico (Estático o Fallback)
      fps = 60 # Simplificado para evitar drift de API en pruebas de caos
      outputs.labels << {
        x: 1210, y: 710,
        text: "⏱️ #{fps} FPS",
        size_enum: -3,
        r: 150, g: 150, b: 150,
        a: 150
      }

      # 2. Estado de Conciencia (Clock)
      status = Stargate.status
      clock_state = if Stargate::Clock.paused?
                      status[:stasis_requested] ? "STASIS" : "PAUSED"
                    else
                      "RUNNING"
                    end
      
      outputs.labels << {
        x: 1100, y: 710,
        text: "🧠 #{clock_state}",
        size_enum: -3,
        r: 100, g: 200, b: 100,
        a: 150
      }
      
      # If Vigilante is interrupted (Sovereign Intervention), draw the stasis UI
      if Stargate::Vigilante.interrupted
        Stargate::View.draw_stasis(args)
      end
    end
  end
end
