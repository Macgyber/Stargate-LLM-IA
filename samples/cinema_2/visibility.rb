# app/visibility.rb - El Domo de la Percepción (Propiedad del Juego)
# =========================================================
# Este módulo contiene la lógica "mágica" de visibilidad y atmósfera.
# Está separado de la infraestructura de carga de mapas.

module GameVisibility
  def self.render(args)
    # Bus Semántico: Leemos de la pieza LDtk (PROTOCOL 0.1.0)
    ldtk = args.state.ldtk
    return unless ldtk && ldtk.status == :active
    
    # 1. Oscuridad Base (Configurable por el juego)
    args.outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0, a: 80, primitive_marker: :solid }
    
    player = ldtk.entities.find { |e| e.type == "PlayerSpawn" }
    return unless player
    
    zoom  = ldtk.zoom || 4.0
    cam_x = ldtk.camera.x || 0
    cam_y = ldtk.camera.y || 0
    
    # 2. ÚNICA VERDAD: El Brillo del Protagonista (Subtil y Orientado)
    # Sincronizado con la animación de flotar (bobbing)
    y_bob_screen = (Math.sin(args.state.tick_count * 0.1) * 4)
    
    # La luz se centra exactamente en el anclaje del cubo
    l = { 
      x: player.x, 
      y: player.y, 
      radius: 50, 
      color: [220, 240, 255] # Blanco hielo premium
    }
    
    # Renderizado del Gradiente (Unificado con la cámara)
    sx, sy = Interprete.screen_pos(l[:x], l[:y], zoom, cam_x, cam_y)
    sy += y_bob_screen
    
    base_r = l[:radius] * zoom
    lc = l[:color]
    
    # Orientación: La luz se inclina sutilmente según la dirección
    angle_offset = player.flip_h ? 180 : 0
    
    # 35 capas para un halo legible que no tape al jugador
    35.times do |i|
      r = base_r * (1.1 - (i / 35.0))
      # Alpha mucho más bajo para que sea un halo, no una mancha sólida
      alpha = (1 + (i * 0.6)).to_i 
      size = (r * 2).round
      next if size <= 0
      
      args.outputs.primitives << {
        x: (sx - r).round,
        y: (sy - r).round,
        w: size, h: size,
        path: 'sprites/circle/white.png', 
        r: lc[0], g: lc[1], b: lc[2], a: alpha,
        angle: angle_offset, # Rote sutilmente si lo deseamos orientar
        primitive_marker: :sprite
      }
    end

    # 3. LUZ AMBIENTAL SUTIL (Aura del Jugador - El "Anillo")
    # Este anillo asegura que el jugador sea legible incluso en oscuridad total
    aura_r = 12 * zoom
    args.outputs.primitives << {
      x: sx - aura_r, y: sy - aura_r, w: aura_r * 2, h: aura_r * 2,
      path: 'sprites/circle/white.png',
      r: 255, g: 255, b: 255, a: 40,
      primitive_marker: :sprite
    }
  end
end
