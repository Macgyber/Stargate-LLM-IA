# DR-LDTK - DragonRuby Entry Point (Game)
# ---------------------------------------------------------
# Este archivo es el "Juego". Se mantiene ligero.
# La carcateristica Stargate-LDTK esta separada.

# 1. Carga de la Característica (Stargate-LDTK Modular)
require "lib/stargate/bootstrap.rb"
require "app/stargate-ldtk/loader.rb"
require "app/visibility.rb"

# 2. Ciclo de Vida del Juego
def tick args
  # @node:system-boot-alignment
  # Inicializar contexto de Stargate (Protocolo LLM-IA: Sovereignty First)
  Stargate.initialize_context(args)

  # @node:ldtk-pulse-connection
  # Conectar el pulso de LDtk (Mapas y Realidad Virtual)
  # Esto reconstruye el level_data para compatibilidad con el juego.
  args.state.level_data = StargateLDTK.pulse(args)

  # @node:sprite-registration
  # Configurar visuales de la librería (Una vez)
  if args.state.tick_count == 0
    args.state.discovered_torches ||= []
    # @node:window-configuration
    # Compatibilidad: Algunas versiones de DR requieren métodos distintos o no permiten cambio dinámico
    title = "stargate-ldtk-experimentando"
    if $gtk.respond_to?(:window_title=)
      $gtk.window_title = title
    elsif $gtk.respond_to?(:set_window_title)
      $gtk.set_window_title(title)
    end
    Interprete.register_sprites({
      "PlayerSpawn" => { path: "sprites/circle/orange.png", w: 16, h: 16 },
      "Torch"       => { color: [230, 195, 92], w: 8, h: 16 },
      "Achievement" => { path: "sprites/circle/yellow.png", w: 16, h: 16 },
      "Chest"       => { color: [100, 100, 255], w: 16, h: 16 }
    })
  end

  # === FLUJO DE VICTORIA / DEMO ===
  if args.state.victory
    render_victory_ui(args)
    $gtk.reset if args.inputs.keyboard.key_down.r
    return # Bloqueamos el resto del juego
  end
  
  # Lógica del Juego (Depende de level_data reconstruido)
  run_game_logic(args)

  stargate = args.state.stargate
  StargateLDTK.render_world(args)
  
  # --- INDICADOR DE DIRECCIÓN (La Raya) ---
  player = args.state.level_data[:entities].find { |e| e[:type] == "PlayerSpawn" }
  if player
    zoom = args.state.level_data[:zoom] || 1.0
    cam_x = args.state.camera_x || 0
    cam_y = args.state.camera_y || 0
    sx, sy = Interprete.screen_pos(player[:x] + 8, player[:y] + 8, zoom, cam_x, cam_y)
    
    # Dirección basada en velocidad o última dirección
    dir_x = player[:vx] || 0
    dir_y = player[:vy] || 0
    length = 25
    
    # Actualizar ángulo si hay movimiento real
    if dir_x.abs > 0.1 || dir_y.abs > 0.1
      player[:last_angle] = Math.atan2(-dir_y, dir_x)
    end
    
    # Dibujar la raya (siempre que se haya movido alguna vez)
    if player[:last_angle]
      ex = sx + Math.cos(player[:last_angle]) * length
      ey = sy + Math.sin(player[:last_angle]) * length
      # La raya es naranja intenso (como el player) pero más fina
      args.outputs.primitives << { x: sx, y: sy, x2: ex, y2: ey, r: 255, g: 100, b: 0, a: 255, primitive_marker: :line }
    end
  end

  GameVisibility.render(args)
  StargateLDTK.render_ui(args)
end

# 3. Servicio de Coordenadas Sagradas (Persistencia en Disco)
module SacredPositionService
  PATH = "player_pos.yaml"

  def self.save(args, player)
    return unless player
    
    lx = args.state.sacred_last_x || 0
    ly = args.state.sacred_last_y || 0

    # Optimización: No escribimos a disco cada frame (Lag alert!)
    # Guardamos cada 5 segundos (300 ticks) o si nos alejamos mucho (50px)
    dist_sq = (player[:x] - lx)**2 + (player[:y] - ly)**2
    if dist_sq > 2500 || args.state.tick_count % 300 == 0
      data = {
        level_id: args.state.level_data[:id],
        x: player[:x] || 0,
        y: player[:y] || 0
      }
      args.gtk.write_file(PATH, args.gtk.serialize_state(data))
      args.state.sacred_last_x = player[:x]
      args.state.sacred_last_y = player[:y]
      # puts "STARGATE: Posición sincronizada."
    end
  end

  def self.load(args)
    raw = args.gtk.read_file(PATH)
    return nil unless raw
    args.gtk.deserialize_state(raw) rescue nil
  end
end

# 3. Lógica específica del Juego
def run_game_logic(args)
  return unless args.state.level_data
  return if args.state.victory # Bloqueo total en victoria
  
  # Buscar Jugador
  player = args.state.level_data[:entities].find { |e| e[:type] == "PlayerSpawn" }
  return unless player

  # Asegurar compatibilidad con Geometry de DragonRuby
  player[:w] ||= player[:wid] || 16
  player[:h] ||= player[:hei] || 16
  
  # Inicialización de estados de diálogo (Uno vez por nivel/carga)
  player[:dialogue_timer] ||= 400 # ~6 seg al inicio
  player[:looked_up]     ||= false
  
  # Sistema de Diálogo Dinámico
  if player[:dialogue_timer] > 0
    player[:dialogue] = "How do I get up there?"
    player[:dialogue_timer] -= 1
  else
    player[:dialogue] = nil
  end
  
  # Disparar diálogo al mirar arriba por primera vez
  if args.inputs.keyboard.up && !player[:looked_up]
    player[:dialogue_timer] = 300 # 5 segundos
    player[:looked_up] = true
  end

  # === FÍSICAS Y CONTROLES ===
  # Constantes de Jugabilidad
  max_spd_x = 3
  accel_x   = 0.5
  friction  = 0.8
  gravity   = 0.4
  jump_inv  = 9.0
  
  # Inicialización de estado físico
  player[:vx] ||= 0
  player[:vy] ||= 0
  player[:on_ground] ||= false
  
  # 1. Movimiento Horizontal
  input_x = args.inputs.keyboard.left_right
  if input_x != 0
    player[:vx] += input_x * accel_x
    player[:vx] = player[:vx].clamp(-max_spd_x, max_spd_x)
  else
    player[:vx] *= friction
    player[:vx] = 0 if player[:vx].abs < 0.1
  end
  
  # Colisión X
  next_x = player[:x] + player[:vx]
  if player[:vx] > 0 
    player[:flip_h] = false # Apunta a la Derecha
    if Interprete.wall?(args.state.level_data, next_x + 12, player[:y]) || 
       Interprete.wall?(args.state.level_data, next_x + 12, player[:y] + 20)
      player[:vx] = 0
      player[:x]  = ((next_x + 12) / 16).to_i * 16 - 12 - 0.1
    else
      player[:x] = next_x
    end
  elsif player[:vx] < 0
    player[:flip_h] = true # Apunta a la Izquierda (Flip)
    if Interprete.wall?(args.state.level_data, next_x, player[:y]) ||      
       Interprete.wall?(args.state.level_data, next_x, player[:y] + 20)      
      player[:vx] = 0
      player[:x]  = ((next_x) / 16).to_i * 16 + 16 + 0.1
    else
      player[:x] = next_x
    end
  end

  # 2. Gravedad y Salto
  player[:vy] += gravity
  player[:vy] = player[:vy].clamp(-12, 12)
  
  if args.inputs.keyboard.key_down.space && player[:on_ground]
    player[:vy] = -jump_inv
    player[:on_ground] = false
  end

  # Colisión Y (Relativo a Y+ abajo)
  grid = args.state.level_data[:grid_size] || 16
  next_y = player[:y] + player[:vy]
  player[:on_ground] = false 
  
  if player[:vy] > 0 # Bajando (Gravedad)
    # Altura visual es 24, pie en y+24
    if Interprete.wall?(args.state.level_data, player[:x] + 2, next_y + 24) ||
       Interprete.wall?(args.state.level_data, player[:x] + 10, next_y + 24)
      player[:vy] = 0
      player[:on_ground] = true
      # Snap exactly to the top of the tile (bottom of player = tile_y)
      # Then add a tiny bit (0.1) to stay "inside" for the check next frame
      tile_y = ((next_y + 24) / grid).to_i * grid
      player[:y] = tile_y - 24 + 0.1 
    else
      player[:y] = next_y
    end
  elsif player[:vy] < 0 # Subiendo (Salto)
    if Interprete.wall?(args.state.level_data, player[:x] + 2, next_y) ||
       Interprete.wall?(args.state.level_data, player[:x] + 10, next_y)
      player[:vy] = 0
      # Snap exactly to the bottom of the tile (top of player = tile_y + grid)
      tile_y = (next_y / grid).to_i * grid
      player[:y] = tile_y + grid
    else
      player[:y] = next_y
    end
  else
    player[:y] = next_y
  end

  # Lógica de Antorchas (Ejemplo de interacción)
  Game.check_torches(args, player)

  # 4. Colisiones con el Logro (Meta del Video)
  achievement = args.state.level_data[:entities].find { |e| e[:type] == "Achievement" }
  if achievement && args.geometry.intersect_rect?(player, achievement)
    args.state.victory = true
    args.state.victory_timer = 0
  end

  # Al final de la lógica, persistir si es necesario (Coordenadas Sagradas)
  SacredPositionService.save(args, player)
end

# Espacio de nombres para lógica auxiliar del juego
module Game
  def self.check_torches(args, player)
    args.state.level_data[:entities].each do |ent|
      if ent[:type] == "Torch" || ent[:type] == "Lantern"
        dist = Math.sqrt((player[:x] - ent[:x])**2 + (player[:y] - ent[:y])**2)
        if dist < 60 && !args.state.discovered_torches.include?(ent[:id])
          args.state.discovered_torches << ent[:id]
        end
      end
    end
  end
end

# Interfaz de Victoria Cinemática "Electrificada" para el Video
def render_victory_ui args
  # Incrementar contador de efectos
  args.state.victory_timer += 1
  vt = args.state.victory_timer
  
  # 1. Fondo Base (Funde a negro muy oscuro)
  bg_alpha = (vt * 10).clamp(0, 240)
  args.outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0, a: bg_alpha, primitive_marker: :solid }
  
  cw = 640
  ch = 720 / 2
  
  # 2. Transición Relampagueante (Flash & Lightning)
  # Flash inicial fuerte (frames 1-3)
  if vt < 4
    args.outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, r: 255, g: 255, b: 255, a: 255, primitive_marker: :solid }
  # Parpadeos irregulares (frames 4-25)
  elsif vt < 30 && (vt % 4 == 0 || vt % 7 == 0)
    args.outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, r: 255, g: 255, b: 255, a: 150, primitive_marker: :solid }
  end
  
  # 3. Logos con Vida (Bobbing suave)
  # Los logos flotan independientemente
  bob = Math.sin(vt * 0.05) * 15
  args.outputs.primitives << { x: cw - 450, y: ch - 120 + bob, w: 300, h: 300, path: "sprites/logo_ldtk.png", primitive_marker: :sprite }
  args.outputs.primitives << { x: cw + 150, y: ch - 120 - bob, w: 300, h: 300, path: "sprites/logo_dragonruby.png", primitive_marker: :sprite }
  
  # 4. Texto RUNTIME (Calma en el centro)
  args.outputs.primitives << { 
    x: cw, y: ch, 
    text: "RUNTIME", 
    size_enum: 25, # Mucho más grande
    font: 'fonts/Comic.ttf', # Asumiendo estilo comic
    alignment_enum: 1, 
    r: 255, g: 255, b: 255, 
    primitive_marker: :label 
  }
  
  # 5. Reinicio Electrizante (Pulse + Shake)
  # Palpitación de Alpha
  p_alpha = 150 + Math.sin(vt * 0.1) * 105
  # Vibración eléctrica (±2 px)
  shake_x = (rand(5) - 2) if vt % 3 == 0
  shake_y = (rand(5) - 2) if vt % 3 == 0
  
  args.outputs.primitives << { 
    x: cw + (shake_x || 0), 
    y: 100 + (shake_y || 0), 
    text: "[Press start]", 
    size_enum: 2, alignment_enum: 1, 
    r: 255, g: 255, b: 255, a: p_alpha, 
    primitive_marker: :label 
  }
end
