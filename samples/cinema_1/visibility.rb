# app/visibility.rb - El Domo de la Percepción (Propiedad del Juego)
# =========================================================
# Este módulo contiene la lógica "mágica" de visibilidad y atmósfera.
# Está separado de la infraestructura de carga de mapas.

module GameVisibility
  def self.render(args)
    level_data = args.state.level_data
    return unless level_data

    # 1. Oscuridad Base (Configurable por el juego)
    args.outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0, a: 80, primitive_marker: :solid }
    
    player = level_data[:entities].find { |e| e[:type] == "PlayerSpawn" }
    return unless player
    
    zoom = level_data[:zoom] || 1.0
    cam_x = args.state.camera_x || 0
    cam_y = args.state.camera_y || 0
    
    # Fuentes de luz
    lights = []
    
    # El juego decide DONDE está la luz (Céntrado en el personaje)
    # Obtenemos las dimensiones reales para un centrado perfecto
    p_config = Interprete.sprite_config(player[:type])
    
    # EFECTO LINTERNA: Desplazamos la luz sutilmente hacia el borde (6px)
    # Esto hace que parezca una linterna en mano, pero dentro del cuerpo.
    light_dir_offset = player[:flip_h] ? -6 : 6
    
    # Sincronizar altura de luz con la animación de flotar (bobbing)
    y_bob = (Math.sin(args.state.tick_count * 0.1) * 4)
    
    lights << { 
      x: (player[:x] || 0) + ((p_config[:w] || p_config[:wid] || 16) / 2) + light_dir_offset, 
      y: (player[:y] || 0) + ((p_config[:h] || p_config[:hei] || 16) / 2) + y_bob, 
      radius: 35, 
      color: [180, 210, 255] # Azulado de linterna mágica
    }
    
    # Antorchas (Dinámicas)
    level_data[:entities].each do |ent|
      if ent[:type] == "Torch"
        t_config = Interprete.sprite_config("Torch")
        lights << { 
          x: ent[:x] + ((t_config[:w] || t_config[:wid] || 8) / 2), 
          y: ent[:y] + ((t_config[:h] || t_config[:hei] || 16) / 2), 
          radius: 60, 
          color: [255, 180, 80] 
        }
      end
    end

    # Logro Dorado (Atmósfera épica)
    level_data[:entities].each do |ent|
      if ent[:type] == "Achievement"
        lights << { 
          x: ent[:x] + 8, 
          y: ent[:y] + 8, 
          radius: 80, 
          color: [255, 230, 0],
          path: 'sprites/circle/yellow.png'
        }
      end
    end
    
    # Renderizado de Gradientes Circulares (Optimizados)
    lights.each do |l|
      sx, sy = Interprete.screen_pos(l[:x], l[:y], zoom, cam_x, cam_y)
      sx = sx.to_i
      sy = sy.to_i
      
      base_r = l[:radius] * zoom
      lc = l[:color] || [255, 255, 255]
      
      # Optimización: No renderizar luces fuera de pantalla
      next if sx < -base_r || sx > 1280 + base_r || sy < -base_r || sy > 720 + base_r
      
      # Optimización: 40 capas para ganar rendimiento
      40.times do |i|
        r = base_r * (1.0 - (i / 40.0))
        alpha = (1 + (i * 0.4)).to_i 
        
        size = (r * 2).round
        next if size <= 0
        
        args.outputs.primitives << {
          x: (sx - r).round,
          y: (sy - r).round,
          w: size,
          h: size,
          path: l[:path] || 'sprites/circle/blue.png',
          r: lc[0], g: lc[1], b: lc[2], a: alpha,
          primitive_marker: :sprite
        }
      end
    end
  end
end
