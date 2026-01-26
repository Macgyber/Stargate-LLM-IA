# --- STARGATE-LLM-IA START ---
# CAUTION: EVERY CHANGE IN THIS FILE MUST BE REFLECTED IN .causal/index.yaml
# Run /causal-sync workflow to ensure project integrity.
require "stargate_AI/core.rb"

def tick(args)
  Stargate.activate!(args)
  # --- STARGATE-LLM-IA END ---

  # 1. State Initialization (Global & Scenes)
  args.state.scene        ||= :intro
  args.state.scene_timer  ||= 0
  args.state.scene_started_at ||= 0
  args.state.shake ||= 0
  args.state.flash ||= 0
  
  # --- SCENE: INTRO (Waiting for Click) ---
  if args.state.scene == :intro
    args.outputs.background_color = [5, 5, 10]
    args.outputs.sprites << { x: 640 - 75, y: 360 - 75, w: 150, h: 150, path: 'metadata/icon.png', a: 100 }
    
    # Trailer-style Analog Static (Procedural Noise)
    if args.state.tick_count > 0
      if !args.state.static
         args.state.static = 20.map { { x: 0, y: 0, w: 2, h: 2, r: 255, g: 255, b: 255, a: 50 } }
      end
      args.state.static.each { |s| s.x = rand(1280); s.y = rand(720) }
      args.outputs.solids << args.state.static
    end

    # Pulsing Prompt
    scale = 1 + Math.sin(args.state.tick_count / 15) * 0.05
    args.outputs.labels << {
      x: 640, y: 180, text: "ENTER THE CAUSE",
      size_px: 25 * scale, alignment_enum: 1,
      r: 200, g: 200, b: 200, font: "fonts/manaspc.ttf"
    }
    
    if args.inputs.mouse.click || args.inputs.keyboard.key_down.enter
       args.audio[:bgm] = { input: "sounds/dragon.wav", looping: false }
       force_scene_switch(args, :epic_quotes)
    end

  # --- SCENE: EPIC QUOTES (Cinematic Subtitles) ---
  elsif args.state.scene == :epic_quotes
    # Pairs: [English (Main), Spanish (Subtitle)]
    messages = [
      ["IN A WORLD OF CHAOS...", "En un mundo de caos..."],
      ["WHERE IDEAS COLLAPSE BEFORE THEY ARE BUILT", "Donde las ideas colapsan antes de nacer..."],
      ["ONE RUNTIME BRINGS ORDER.", "Un solo runtime trae orden."],
      
      ["THEY SAID IT WAS IMPOSSIBLE.", "Dijeron que era imposible."],
      ["BECAUSE THEY WERE THINKING IN LINES.", "Porque pensaban en líneas."],
      ["WE THOUGHT IN CAUSES.", "Nosotros pensamos en causas."]
    ]
    elapsed = args.state.tick_count - args.state.scene_started_at
    msg_idx = (elapsed / 150).to_i # Faster transitions for trailer feel
    
    args.outputs.background_color = [0, 0, 0]
    if msg_idx < messages.length
      scene_tick = elapsed % 150
      alpha = 255
      if scene_tick < 20; alpha = (scene_tick / 20.0) * 255; end
      if scene_tick > 130; alpha = 255 - ((scene_tick - 130) / 20.0 * 255); end
      
      # Impact Glitch Effect (Random small offset)
      gx = (rand(4) - 2) * (alpha/255.0)
      
      # English (White, Large, Serif-like)
      args.outputs.labels << {
        x: 640 + gx, y: 400, text: messages[msg_idx][0],
        size_px: 45, alignment_enum: 1,
        r: 255, g: 255, b: 255, a: alpha,
        font: "fonts/manaspc.ttf" 
      }
      
      # Spanish Subtitle (Yellow, Smaller, Sans-serif style)
      args.outputs.labels << {
        x: 640, y: 340, text: messages[msg_idx][1],
        size_px: 28, alignment_enum: 1,
        r: 255, g: 255, b: 0, a: alpha # Cinematic Yellow
      }
    else
      force_scene_switch(args, :countdown)
    end

  # --- SCENE: COUNTDOWN ---
  elsif args.state.scene == :countdown
    elapsed = args.state.tick_count - args.state.scene_started_at
    count = 3 - (elapsed / 60).to_i
    args.outputs.background_color = [20, 0, 0]
    
    if count > 0
      scale = 1 + (elapsed % 60) / 10.0 # Faster scale
      args.outputs.labels << { x: 640, y: 360, text: count.to_s, size_px: 120 * scale, alignment_enum: 1, r: 255, g: 0, b: 0 }
      # Flash on every second
      if elapsed % 60 < 5; args.state.flash = 200; end
    else
      args.outputs.labels << { x: 640, y: 400, text: "IGNITE THE FLOW.", size_px: 120, alignment_enum: 1, r: 255, g: 255, b: 0 }
      args.outputs.labels << { x: 640, y: 250, text: "¡ENCIENDE EL FLUJO!", size_px: 60, alignment_enum: 1, r: 255, g: 0, b: 0 }
      args.state.shake = 20 if elapsed == 180
      if elapsed > 200; force_scene_switch(args, :cars); end
    end

  # --- SCENE: CARS (Mini-Game) ---
  elsif args.state.scene == :cars
    args.state.car_x ||= 640
    args.state.obstacles ||= []
    args.state.road_offset ||= 0
    args.state.speed = 12
    
    # Input
    if args.inputs.left; args.state.car_x -= 10; end
    if args.inputs.right; args.state.car_x += 10; end
    # Narrower road: 300 to 980. Clamp accounts for car width (~70px)
    args.state.car_x = args.state.car_x.clamp(310, 910)
    
    # Logic: Constant Speed
    args.state.road_offset -= args.state.speed
    
    # Spawn Enemies (More frequent)
    if args.state.tick_count % 30 == 0 # Slightly less frequent than before to match slower speed
      # Enemy Cars
      args.state.obstacles << { x: 300 + rand(600), y: 720, w: 50, h: 80, r: 0, g: 0, b: 200 } 
    end
    args.state.obstacles.each { |o| o.y -= (args.state.speed - 4) } # Relative speed
    args.state.obstacles.reject! { |o| o.y < -100 }
    
    # Render
    args.outputs.background_color = [10, 10, 15] # Night city feel
    
    # Apply shake offset
    sx = (rand(args.state.shake * 2 + 1) - args.state.shake) if args.state.shake > 0; sx ||= 0

    # Road
    args.outputs.solids << { x: 300 + sx, y: 0, w: 680, h: 720, r: 40, g: 40, b: 50 } # Blueish asphalt
    # Road Lines
    args.outputs.solids << { x: 290 + sx, y: 0, w: 10, h: 720, r: 255, g: 255, b: 255 }
    args.outputs.solids << { x: 980 + sx, y: 0, w: 10, h: 720, r: 255, g: 255, b: 255 }
    
    (0..10).each { |i| args.outputs.solids << { x: 635 + sx, y: (i * 100 + args.state.road_offset) % 800 - 50, w: 10, h: 60, r: 200, g: 200, b: 0 } }
    
    # Render Custom F1 Car (Procedural Sprite)
    cx, cy = args.state.car_x + sx, 100
    # Wheels
    args.outputs.solids << { x: cx - 5, y: cy + 50, w: 10, h: 20, r: 0, g: 0, b: 0 } # Front L
    args.outputs.solids << { x: cx + 55, y: cy + 50, w: 10, h: 20, r: 0, g: 0, b: 0 } # Front R
    args.outputs.solids << { x: cx - 5, y: cy + 10, w: 10, h: 25, r: 0, g: 0, b: 0 } # Back L
    args.outputs.solids << { x: cx + 55, y: cy + 10, w: 10, h: 25, r: 0, g: 0, b: 0 } # Back R
    # Body
    args.outputs.solids << { x: cx + 15, y: cy + 10, w: 30, h: 70, r: 255, g: 0, b: 0 } # Main Chassis
    args.outputs.solids << { x: cx + 15, y: cy + 40, w: 30, h: 10, r: 200, g: 200, b: 200 } # Cockpit
    # Spoiler
    args.outputs.solids << { x: cx + 5, y: cy + 5, w: 50, h: 10, r: 200, g: 0, b: 0 } # Rear Wing
    args.outputs.solids << { x: cx + 10, y: cy + 75, w: 40, h: 5, r: 200, g: 0, b: 0 } # Front Wing
    
    # Enemy Cars
    args.outputs.solids << args.state.obstacles.map { |o| o.merge(x: o.x + sx) }
    
    # UI
    elapsed = args.state.tick_count - args.state.scene_started_at
    remaining = [10 - (elapsed/60).to_i, 0].max
    
    # HUD
    args.outputs.labels << { x: 50, y: 700, text: "STABILITY: HIGH", r: 0, g: 255, b: 255, font: "fonts/manaspc.ttf" }
    args.outputs.labels << { x: 1240, y: 700, text: "TIME: #{remaining}s", alignment_enum: 2, r: 255, g: 255, b: 255 }
    
    if elapsed > 600; force_scene_switch(args, :interlude); end

  # --- SCENE: INTERLUDE (Text) ---
  elsif args.state.scene == :interlude
    args.outputs.background_color = [0, 0, 20]
    elapsed = args.state.tick_count - args.state.scene_started_at
    texts = [
      ["YOU ESCAPED THE CITY.", "Escapaste de la ciudad."],
      ["BUT CREATION NEVER STOPS.", "Pero la creación no se detiene."],
      ["THE SKY DARKENS.", "El cielo se oscurece."],
      ["THE DRAGON AWAKENS.", "El dragón despierta."]
    ]
    idx = (elapsed / 120).to_i
    if idx < texts.length
       # English
       args.outputs.labels << { x: 640, y: 400, text: texts[idx][0], size_px: 40, alignment_enum: 1, r: 100, g: 200, b: 255, font: "fonts/manaspc.ttf" }
       # Spanish
       args.outputs.labels << { x: 640, y: 340, text: texts[idx][1], size_px: 28, alignment_enum: 1, r: 255, g: 255, b: 0 }
    else
       force_scene_switch(args, :boss_battle)
    end

  # --- SCENE: BOSS BATTLE (Asteroids -> Dragon) ---
  elsif args.state.scene == :boss_battle
    # Init
    args.state.player ||= { x: 100, y: 360, w: 80, h: 50, path: 'images/ship.png' }
    args.state.asteroids ||= [] 
    args.state.bullets ||= []
    args.state.explosions ||= []
    args.state.asteroids_destroyed ||= 0
    args.state.boss ||= nil
    
    # Background (Planets)
    args.state.planets ||= [
      { x: 200, y: 500, w: 100, h: 100, path: 'images/background/jupiter.png', speed: 0.2 },
      { x: 800, y: 100, w: 80,  h: 80,  path: 'images/background/mars.png',    speed: 0.5 },
      { x: 1200, y: 600, w: 50, h: 50,  path: 'images/background/earth.png',   speed: 0.1 }
    ]
    
    # Input
    if args.inputs.up; args.state.player.y += 10; end
    if args.inputs.down; args.state.player.y -= 10; end
    # Clamp Player to Screen
    args.state.player.y = args.state.player.y.clamp(40, 680)
    
    if args.inputs.keyboard.key_down.z || args.inputs.keyboard.key_down.space || args.inputs.mouse.click
      args.state.bullets << { x: args.state.player.x + 80, y: args.state.player.y + 20, w: 20, h: 6, r: 0, g: 255, b: 255 }
      args.state.shake = 5
    end

    # --- PHASE 1: ASTEROID FIELD (Chaos) ---
    if !args.state.boss
      if args.state.tick_count % 20 == 0
        size = 80 + rand(70); speed = 8 + rand(12); spin = (rand(10) - 5) * 2; dy = (rand(6) - 3)
        args.state.asteroids << { x: 1300, y: rand(720), w: size, h: size, path: 'images/rock.png', speed: speed, dy: dy, angle: rand(360), rot_speed: spin }
      end
      if args.state.asteroids_destroyed >= 10
        # Inicialización Boss
        args.state.boss = { x: 1300, y: 300, w: 450, h: 450, path: 'images/dragon.png', hp: 200, dir: 1, flip_horizontally: false, r: 255, g: 255, b: 255, fire_timer: 100, move_timer: 0, target_y: 360 }
        args.state.asteroids.clear; args.state.flash = 255; args.state.shake = 30
      end
    end
    
    # --- PHASE 2: BOSS BATTLE (Unpredictable) ---
    if args.state.boss
      args.state.boss.move_timer -= 1
      if args.state.boss.move_timer <= 0; args.state.boss.target_y = 100 + rand(500); args.state.boss.move_timer = 60 + rand(60); end
      args.state.boss.y += (args.state.boss.target_y - args.state.boss.y) * 0.05
      args.state.boss.y += Math.sin(args.state.tick_count / 5) * 5 # Sine wave for added movement
      
      # Boss Entry
      if args.state.boss.x > 800
        args.state.boss.x -= 3
      end
      
      # Boss Attack (Fireballs)
      args.state.boss.fire_timer -= 1
      if args.state.boss.fire_timer <= 0
         angle = args.geometry.angle_to(args.state.boss, args.state.player).to_radians
         args.state.asteroids << { x: args.state.boss.x, y: args.state.boss.y + 200, w: 80, h: 40, path: 'images/fire.png',  dx: Math.cos(angle)*15, dy: Math.sin(angle)*15, is_fire: true, angle: angle.to_degrees }
         args.state.boss.fire_timer = 40 + rand(40); args.state.shake = 10
      end
      
      # Boss Hit Feedback
      args.state.boss.g = [args.state.boss.g + 10, 255].min
      args.state.boss.b = [args.state.boss.b + 10, 255].min

      # Boss Death Logic Fix
      if args.state.boss.hp <= 0
        args.state.flash = 255; args.state.shake = 50
        force_scene_switch(args, :outro)
      end
    end

    # Physics
    sx = (rand(args.state.shake * 2 + 1) - args.state.shake) if args.state.shake > 0; sx ||= 0

    args.state.planets.each { |p| p.x -= p.speed; if p.x < -100; p.x = 1280 + rand(200); p.y = rand(600); end }
    args.state.asteroids.each do |a| 
      if a.is_fire
        a.x += a.dx
        a.y += a.dy
      else
        a.x -= a.speed
        a.y += a.dy || 0
        a.angle += a.rot_speed
      end
    end
    args.state.asteroids.reject! { |a| a.x < -100 || a.y < -100 || a.y > 820 || a.x > 1380 }
    
    args.state.explosions.each do |e|
      e.frame ||= 0
      e.frame += 1
      img_idx = (e.frame / 4).to_i
      if img_idx > 6
        e.dead = true
      else
        e.path = "images/effects/explosion-#{img_idx}.png"
      end
    end
    args.state.explosions.reject! { |e| e.dead }
    
    args.state.bullets.each { |b| b.x += 20 }
    args.state.bullets.reject! { |b| 
      hit = false
      args.state.asteroids.each do |a|
        if args.geometry.intersect_rect?(b, a)
           if !a.is_fire; args.state.explosions << { x: a.x, y: a.y, w: a.w, h: a.h, path: 'images/effects/explosion-0.png' }; args.state.asteroids_destroyed += 1; end
           a.x = -200 # Remove asteroid
           hit = true
           break
        end
      end
      if !hit && args.state.boss && args.geometry.intersect_rect?(b, args.state.boss)
         args.state.boss.hp -= 2
         args.state.boss.g = 0 # Flash red on hit
         args.state.boss.b = 0 # Flash red on hit
         if rand < 0.3; args.state.explosions << { x: b.x - 20, y: b.y - 20, w: 40, h: 40, path: 'images/effects/explosion-0.png' }; end
         args.state.shake = 5
         hit = true 
      end
      hit || b.x > 1280 # Remove bullet if hit or offscreen
    }

    # Render
    args.outputs.background_color = [5, 0, 10]
    args.outputs.sprites << args.state.planets.map { |p| p.merge(x: p.x + sx) }
    args.outputs.sprites << args.state.player.merge(x: args.state.player.x + sx)
    args.outputs.sprites << args.state.asteroids.map { |a| a.merge(x: a.x + sx) }
    args.outputs.sprites << args.state.boss.merge(x: args.state.boss.x + sx) if args.state.boss
    args.outputs.sprites << args.state.explosions.map { |e| e.merge(x: e.x + sx) }
    args.outputs.solids << args.state.bullets
    
    # UI (Boss HP Bar) - Floating above Boss
    if args.state.boss && args.state.scene == :boss_battle
        # Ensure HP is initialized for safety
        args.state.boss.hp ||= 200
        
        # Position relative to Boss
        bx = args.state.boss.x + sx # Include shake logic if needed
        by = args.state.boss.y + args.state.boss.h + 20 # Above head
        
        # Health Calculation
        pct = (args.state.boss.hp / 200.0).clamp(0, 1)
        bar_w = 200 * pct # Smaller width to fit boss size
        
        # Bar Color (Green -> Yellow -> Red)
        r, g, b = 255, 50, 50
        if pct > 0.5; r = 50; g = 255; b = 50; end
        
        # Background
        args.outputs.solids << { x: bx + 125, y: by, w: 200, h: 10, r: 0, g: 0, b: 0 }
        # Render Bar
        args.outputs.solids << { x: bx + 125, y: by, w: bar_w, h: 10, r: r, g: g, b: b }
        # Border
        args.outputs.borders << { x: bx + 125, y: by, w: 200, h: 10, r: 255, g: 255, b: 255 }
        
        # Trigger Outro on Death
        if args.state.boss.hp <= 0; force_scene_switch(args, :outro); end
    elsif args.state.scene == :boss_battle
        args.outputs.labels << { x: 640, y: 680, text: "ASTEROIDS: #{args.state.asteroids_destroyed}/10", alignment_enum: 1, r: 100, g: 255, b: 255 }
    end

  # --- SCENE: OUTRO (Credits/Replay) ---
  elsif args.state.scene == :outro
    args.outputs.background_color = [0, 0, 0]
    # Logo: Larger and positioned in the upper half
    args.outputs.sprites << { x: 640-150, y: 380, w: 300, h: 300, path: 'images/logo.png', a: 255 }
    
    # Text: Positioned in the lower half with better contrast
    args.outputs.labels << { 
      x: 640, y: 320, text: "LEGEND RESTORED.", 
      size_px: 55, alignment_enum: 1, 
      r: 255, g: 255, b: 255, font: "fonts/manaspc.ttf" 
    }
    args.outputs.labels << { 
      x: 640, y: 260, text: "LEYENDA RESTAURADA.", 
      size_px: 35, alignment_enum: 1, 
      r: 255, g: 215, b: 0 # Gold
    } 
    
    args.outputs.labels << { 
      x: 640, y: 200, text: "IMAGINATION IS THE LIMIT.", 
      size_px: 22, alignment_enum: 1, 
      r: 180, g: 180, b: 200 # Soft Blue/Grey
    }
    
    args.outputs.labels << { 
      x: 640, y: 150, text: "Press 'R' to Create Again / Presiona 'R' para Crear de Nuevo", 
      size_px: 18, alignment_enum: 1, 
      r: 255, g: 255, b: 255, a: 150 
    }
    
    if args.inputs.keyboard.key_down.r
      force_scene_switch(args, :intro)
    end
  end

  # --- TRAILER FX LAYER (Top of everything) ---
  args.state.shake = [args.state.shake - 1, 0].max
  args.state.flash = [args.state.flash - 20, 0].max
  
  # Cinematic Bars
  args.outputs.solids << { x: 0, y: 0, w: 1280, h: 80, r: 0, g: 0, b: 0 }   # Bottom Bar
  args.outputs.solids << { x: 0, y: 640, w: 1280, h: 80, r: 0, g: 0, b: 0 } # Top Bar
  
  # --- RIVE-STYLE TRANSITION CURTAIN ---
  if args.state.transition_active
    args.state.transition_progress += 0.03 # Duration ~30 frames
    prog = args.state.transition_progress
    
    # Easing: Faster in the middle
    # Curtain logic: Two bars moving from sides to center
    curtain_w = 640 * (prog <= 0.5 ? prog * 2 : (1.0 - prog) * 2)
    # Clamp to ensure full coverage at midpoint
    curtain_w = 640 if (prog > 0.45 && prog < 0.55)
    
    args.outputs.solids << { x: 0, y: 0, w: curtain_w, h: 720, r: 0, g: 0, b: 0 } # Left Curtain
    args.outputs.solids << { x: 1280 - curtain_w, y: 0, w: curtain_w, h: 720, r: 0, g: 0, b: 0 } # Right Curtain

    # Middle Glitch Line (Vector feel)
    if prog > 0.4 && prog < 0.6
      args.outputs.solids << { x: 638, y: 0, w: 4, h: 720, r: 255, g: 255, b: 255, a: 200 }
    end

    # Swap Scene at midpoint (Curtains closed)
    if prog >= 0.5 && !args.state.transition_swapped
      perform_scene_swap(args, args.state.pending_scene)
      args.state.transition_swapped = true
    end

    # End Transition
    if prog >= 1.0
      args.state.transition_active = false
      args.state.pending_scene = nil
    end
  end

  # Flash overlay
  args.outputs.solids << { x: 0, y: 0, w: 1280, h: 720, r: 255, g: 255, b: 255, a: args.state.flash } if args.state.flash > 0
end

def force_scene_switch(args, next_scene)
  # Guard: Don't trigger if we are already transitioning to that exact scene
  return if args.state.transition_active && args.state.pending_scene == next_scene
  
  # Trigger the "Rive Meetup" Transition
  args.state.transition_active = true
  args.state.transition_progress = 0
  args.state.transition_swapped = false
  args.state.pending_scene = next_scene
end

# Internal Logic: What actually changes the state
def perform_scene_swap(args, next_scene)
  # Stop music if going back/ending
  if next_scene == :intro || next_scene == :outro
    args.audio[:bgm] = nil
  end

  args.state.scene = next_scene
  args.state.scene_started_at = args.state.tick_count
  # Clean specific states
  args.state.car_x = nil; args.state.obstacles = nil; args.state.boss = nil
  args.state.asteroids_destroyed = 0; args.state.asteroids = []; args.state.bullets = []; args.state.explosions = []
  args.state.flash = 255
end