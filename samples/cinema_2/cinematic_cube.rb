# app/cinematic_cube.rb - El Despertar del Cubo (Secuencia Narrativa)
# =========================================================

module CinematicCube
  def self.render(args)
    # ESTADO DE LA CINEMÁTICA
    args.state.cinematic ||= {
      stage: :intro_door, # :intro_door, :dialogue, :active_game
      t: 0,
      dialogue_index: 0,
      finished: false
    }
    
    c = args.state.cinematic
    return if c[:finished]

    c[:t] += 1
    t = c[:t]

    case c[:stage]
    when :intro_door
      render_intro_door(args, t, c)
    when :dialogue
      render_dialogue_sequence(args, t, c)
    end
  end

  def self.render_intro_door(args, t, c)
    # Fondo negro absoluto
    args.outputs.solids << [0, 0, 1280, 720, 0, 0, 0]

    # La Puerta (Blanca, en el centro o izquierda)
    door_w = 40
    door_h = 80
    dx = 200
    dy = 200

    # Animación: La puerta se "abre" de arriba a abajo inundando de luz
    # Stage 1: Luz brotando (0-100)
    light_intensity = (t * 3).clamp(0, 255)
    
    # Inundación de luz (Overlay blanco)
    if t > 60 && t < 150
      flood_a = ((t - 60) * 4).clamp(0, 255)
      args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255, flood_a]
    end

    # Dibujar puerta
    args.outputs.solids << [dx, dy, door_w, door_h, 255, 255, 255, light_intensity]

    # Pasado el flash, el personaje aparece
    if t > 180
      c[:stage] = :dialogue
      c[:t] = 0
    end
  end

  def self.render_dialogue_sequence(args, t, c)
    # El mundo empieza a sugerirse (oscuro)
    args.outputs.solids << [0, 0, 1280, 720, 10, 10, 20]

    # Dibujar al Cubo (Quieto, en el centro de la escena inicial)
    cx, cy = 640, 360
    args.outputs.sprites << {
      x: cx - 32, y: cy - 32, w: 64, h: 64,
      path: 'sprites/square/blue.png'
    }

    # Diálogos
    lines = [
      "¿Dónde estoy...?",
      "¿Eso fue todo? Otra vez un callejón sin salida.",
      "Siento que este mundo se construye mientras lo miro..."
    ]

    current_line = lines[c[:dialogue_index]]

    # Caja de diálogo
    args.outputs.solids << [340, 50, 600, 100, 0, 0, 0, 180]
    args.outputs.labels << [640, 115, current_line, 2, 1, 255, 255, 255]
    args.outputs.labels << [640, 75, "[Presiona ESPACIO para continuar]", -2, 1, 150, 150, 150]

    # Avanzar diálogo
    if args.inputs.keyboard.key_down.space
      c[:dialogue_index] += 1
      if c[:dialogue_index] >= lines.size
        c[:finished] = true
        # Notificar al mundo que puede empezar
        args.state.stargate_game_active = true
      end
    end
  end

  def self.render_ending(args)
    # Secuencia final solicitada
    args.state.ending_t ||= 0
    args.state.ending_t += 1
    et = args.state.ending_t

    # Fundido a blanco total
    white_a = (et * 2).clamp(0, 255)
    args.outputs.solids << [0, 0, 1280, 720, 255, 255, 255, white_a]

    if et > 150
      # Créditos y Repo
      args.outputs.labels << [640, 500, "RECONSTRUCCIÓN COMPLETADA", 10, 1, 0, 0, 0]
      args.outputs.labels << [640, 400, "Repositorio: github.com/ANTIGRAVITY/stargate-HUB", 2, 1, 50, 50, 50]
      
      # Imagen del repo (mockup)
      args.outputs.sprites << { x: 540, y: 200, w: 200, h: 150, path: 'sprites/square/white.png', r: 240, g: 240, b: 240 }
      
      args.outputs.labels << [640, 100, "Thank you for watching", 1, 1, 100, 100, 100]
      
      if et > 300
        pulse = (Math.sin(et * 0.1) * 50 + 200).to_i
        args.outputs.labels << [640, 50, "Press Start", 5, 1, 0, 0, 0, pulse]
      end
    end
  end
end
