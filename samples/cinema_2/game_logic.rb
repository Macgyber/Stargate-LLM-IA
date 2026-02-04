# app/game_logic.rb - El Corazón Dinámico (Pieza Ortogonal)
# =========================================================
# Este módulo orquesta la vida dentro del mundo. 
# No carga mapas ni renderiza sprites; solo muta el estado en el Bus Semántico.

module GameLogic
  def self.tick(args)
    ldtk = args.state.ldtk
    return unless ldtk && ldtk.status == :active
    
    # 1. FLUJO DE VICTORIA / CINEMÁTICA "ELECTRIFICADA"
    if args.state.victory
      render_victory_ui(args)
      # El reset ahora viene del Bus de Intenciones (Tecla R)
      $gtk.reset if ldtk.intents && ldtk.intents.reset_pressed
      return
    end

    # 2. LÓGICA DE INTERACCIÓN Y DESCUBRIMIENTO
    run_interaction_logic(args, ldtk)
    run_discovery_logic(args, ldtk)

    # 3. LÓGICA DE MOVIMIENTO Y DIÁLOGOS
    run_player_logic(args, ldtk)

    # 4. SECUENCIA "LEAP OF FAITH" (Mecánica Progresiva)
    run_leap_of_faith_logic(args, ldtk)
  end

  def self.run_leap_of_faith_logic(args, ldtk)
    player = ldtk.entities.find { |e| e.type == "PlayerSpawn" }
    return unless player

    # 1. TRIGGER: Zona superior derecha (coordenadas estimadas del salto)
    # Si el jugador llega a x > 300 y y < 50 (zona alta del atlas cavernas)
    if player.x > 320 && player.y < 60 && !args.state.leap_started
      args.state.leap_started = true
      args.state.leap_t = 0
      player.fields["dialogue"] = "Leap of Faith..."
      player.fields["dialogue_timer"] = 120
    end

    return unless args.state.leap_started && !args.state.leap_finished

    args.state.leap_t += 1
    lt = args.state.leap_t

    # 2. EL SALTO (Cámara lenta y control limitado)
    if lt < 600 # 10 segundos a 60fps
      # Mensaje de fe
      if lt == 150
         player.fields["dialogue"] = "No hay vuelta atrás."
         player.fields["dialogue_timer"] = 90
      end

      # 3. CONSTRUCCIÓN MÁGICA (Invisible para el espectador)
      # Se construye un puente a la altura y=220 (abajo) mientras el jugador cae
      if lt > 100 && lt < 500
        # Construimos de izquierda a derecha progresivamente
        gx = ((lt - 100) / 10).to_i + 30
        (220..240).step(8) do |py| # Un suelo grueso
           gy = (py / 8).to_i
           StargateLDtk::Bridge.reconstruct_wall(gx, gy, 1)
        end
      end
    else
      # Fin de la secuencia si toca el suelo nuevo
      if player.on_ground
         args.state.leap_finished = true
         player.fields["dialogue"] = "Lo logré... el camino se abrió."
         player.fields["dialogue_timer"] = 180
      end
    end
  end

  def self.run_discovery_logic(args, ldtk)
    player = ldtk.entities.find { |e| e.type == "PlayerSpawn" }
    return unless player

    # Memoria de Descubrimiento (Torches)
    ldtk.discovered_ids ||= []
    
    ldtk.entities.each do |ent|
      if ent.type == "Torch"
        dist = Math.sqrt((player.x - ent.x)**2 + (player.y - ent.y)**2)
        if dist < 60 && !ldtk.discovered_ids.include?(ent.iid)
          ldtk.discovered_ids << ent.iid
          puts "🕯️  Discovery: Torch #{ent.iid} found by Player."
          # Marcamos la entidad en el bus para feedback visual si se desea
          ent.fields["discovered"] = true
        end
      end
    end
  end

  def self.run_interaction_logic(args, ldtk)
    intents = ldtk.intents
    return unless intents
    
    player = ldtk.entities.find { |e| e.type == "PlayerSpawn" }
    return unless player

    # Buscar Levers (Palancas) cercanas
    ldtk.entities.each do |ent|
      if ent.type == "Lever"
        dist_x = (player.x - ent.x).abs
        dist_y = (player.y - ent.y).abs
        
        if dist_x < 24 && dist_y < 24 && intents.interact_pressed
          # Alternar estado de la palanca
          ent.fields["active"] = !ent.fields["active"]
          puts "🕹️  Causality: Lever #{ent.iid} toggled to #{ent.fields["active"]}."
          
          # Efecto Dominó: Puertas asociadas
          ldtk.entities.each do |other|
            if other.type == "Gate" && other.fields["id_link"] == ent.fields["id_target"]
               other.fields["closed"] = !ent.fields["active"]
               puts "🚪 Stargate: Gate #{other.iid} sync'd with Lever."
            end
          end
        end
      end
    end
  end

  def self.run_player_logic(args, ldtk)
    player = ldtk.entities.find { |e| e.type == "PlayerSpawn" }
    return unless player
    
    intents = ldtk.intents || {}

    # 0. LÓGICA DE DIÁLOGOS (Pensamientos Contextuales)
    player.fields["dialogue_timer"] ||= 300 # 5 segundos de bienvenida
    player.fields["dialogue"] = "Encontré este mundo..." if player.fields["dialogue_timer"] == 300
    
    if player.fields["dialogue_timer"] > 0
      player.fields["dialogue_timer"] -= 1
      player.fields["dialogue"] = nil if player.fields["dialogue_timer"] == 0
    end

    # ESTADO EXTENDIDO (Memoria de Corto Plazo para Feel)
    player.coyote_timer ||= 0
    player.jump_buffer  ||= 0
    
    # Constantes Físicas
    # Constantes Físicas (Calibradas para Zoom 4.0 y Cubo 16x16)
    max_spd_x = 4.0
    accel_x   = 0.7
    friction  = 0.82
    gravity   = 0.50
    jump_inv  = 10.5
    
    # 1. Movimiento Horizontal
    input_x = intents.move_x || 0
    if input_x != 0
      player.vx += input_x * accel_x
      player.vx = player.vx.clamp(-max_spd_x, max_spd_x)
    else
      player.vx *= friction
      player.vx = 0 if player.vx.abs < 0.1
    end
    
    # Colisión X (Cubo 16x16)
    p_w = player.w || 16
    p_h = player.h || 16
    next_x = player.x + player.vx
    
    if player.vx > 0 # Derecha
      player.flip_h = false
      if StargateLDtk::Bridge.wall?(next_x + p_w - 1, player.y + 1) || 
         StargateLDtk::Bridge.wall?(next_x + p_w - 1, player.y + p_h - 1)
        player.vx = 0
        # Ajustar a la izquierda del muro
        player.x = ((next_x + p_w - 1) / 16).to_i * 16 - p_w
      else
        player.x = next_x
      end
    elsif player.vx < 0 # Izquierda
      player.flip_h = true
      if StargateLDtk::Bridge.wall?(next_x + 1, player.y + 1) ||      
         StargateLDtk::Bridge.wall?(next_x + 1, player.y + p_h - 1)      
        player.vx = 0
        # Ajustar a la derecha del muro
        player.x = ((next_x + 1) / 16).to_i * 16 + 16
      else
        player.x = next_x
      end
    end

    # 2. Gravedad y Salto (Coyote Time & Buffering)
    # Reducir timers
    player.coyote_timer -= 1 if player.coyote_timer > 0
    player.jump_buffer  -= 1 if player.jump_buffer > 0
    
    # Alimentar buffer si se presiona salto
    player.jump_buffer = 10 if intents.jump_pressed
    
    # Aplicar gravedad
    player.vy += gravity
    player.vy = player.vy.clamp(-15, 15)
    
    # Ejecutar salto si hay intención y permiso (Coyote/Ground)
    if player.jump_buffer > 0 && (player.on_ground || player.coyote_timer > 0)
      player.vy = -jump_inv
      player.on_ground = false
      player.coyote_timer = 0
      player.jump_buffer = 0
      puts "🚀 Jump: Despegue del Cubo Hermoso."
    end
    
    # Salto variable (cortar si se suelta)
    if player.vy < 0 && !intents.jump_held
      player.vy *= 0.6
    end

    # Colisión Y (Cubo 16x16)
    grid = ldtk.world.tile_size || 16
    next_y = player.y + player.vy
    
    if player.vy > 0 # Bajando
      if StargateLDtk::Bridge.wall?(player.x + 2, next_y + p_h) ||
         StargateLDtk::Bridge.wall?(player.x + p_w - 2, next_y + p_h)
        player.vy = 0
        player.on_ground = true
        player.coyote_timer = 10 # 10 frames de Coyote
        tile_y = ((next_y + p_h) / grid).to_i * grid
        player.y = tile_y - p_h + 0.1 
      else
        player.y = next_y
        player.on_ground = false
      end
    elsif player.vy < 0 # Subiendo
      if StargateLDtk::Bridge.wall?(player.x + 2, next_y) ||
         StargateLDtk::Bridge.wall?(player.x + p_w - 2, next_y)
        player.vy = 0
        tile_y = (next_y / grid).to_i * grid
        player.y = tile_y + grid
      else
        player.y = next_y
        player.on_ground = false
      end
    else
      player.y = next_y
    end

    # 3. Meta / Victoria
    achievement = ldtk.entities.find { |e| e.type == "Achievement" }
    if achievement && args.geometry.intersect_rect?(player, achievement)
      args.state.victory = true
      args.state.victory_timer = 0
      puts "🏆 STARGATE: ¡Victoria Causal Detectada!"
    end

    # 4. Memoria Sagrada (Opcional)
    SacredPositionService.save(args, player) if Object.const_defined?(:SacredPositionService)
  end

  def self.render_victory_ui(args)
    args.state.victory_timer += 1
    vt = args.state.victory_timer
    
    # Fondo Negro (Alpha progresivo)
    bg_alpha = (vt * 10).clamp(0, 240)
    args.outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0, a: bg_alpha, primitive_marker: :solid }
    
    # Flash inicial fuerte
    if vt < 4
      args.outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, r: 255, g: 255, b: 255, a: 255, primitive_marker: :solid }
    elsif vt < 30 && (vt % 5 == 0 || vt % 7 == 0)
      # Parpadeos relampagueantes
      args.outputs.primitives << { x: 0, y: 0, w: 1280, h: 720, r: 255, g: 255, b: 255, a: 150, primitive_marker: :solid }
    end

    cw = 640
    ch = 360
    
    # Texto Ceremonial (Pulso y Shake)
    p_alpha = (vt > 40) ? (150 + Math.sin(vt * 0.1) * 105) : 0
    shake_x = (rand(3) - 1) if vt % 2 == 0
    
    args.outputs.primitives << { 
      x: cw + (shake_x || 0), y: ch + 50, 
      text: "RECONSTRUCCIÓN COMPLETADA", 
      size_enum: 10, alignment_enum: 1, r: 255, g: 255, b: 255, 
      primitive_marker: :label 
    }

    args.outputs.primitives << { 
      x: cw, y: ch - 50, 
      text: "Presiona R para reiniciar el ciclo", 
      size_enum: 2, alignment_enum: 1, r: 200, g: 200, b: 200, a: p_alpha,
      primitive_marker: :label 
    }
  end
end

# Auxiliar: Servicio de Coordenadas Sagradas
module SacredPositionService
  PATH = "player_pos.yaml"

  def self.save(args, player)
    return unless player
    return if args.state.tick_count % 300 != 0 # Cada 5 segundos

    data = { x: player.x, y: player.y }
    $gtk.write_file(PATH, $gtk.serialize_state(data))
  end

  def self.load
    raw = $gtk.read_file(PATH)
    return nil unless raw
    $gtk.deserialize_state(raw) rescue nil
  end
end

# Auxiliar: Servicio de Coordenadas Sagradas
module SacredPositionService
  PATH = "player_pos.yaml"

  def self.save(args, player)
    return unless player
    return if args.state.tick_count % 300 != 0 # Cada 5 segundos

    data = { x: player.x, y: player.y }
    $gtk.write_file(PATH, $gtk.serialize_state(data))
  end

  def self.load
    raw = $gtk.read_file(PATH)
    return nil unless raw
    $gtk.deserialize_state(raw) rescue nil
  end
end
