# 🌌 STARGATE: THE CONSTELLATION (PUZZLE ARCHITECTURE)
# -----------------------------------------------------------------------------
# En este diseño, cada pieza es una librería ortogonal e independiente.
# Juntas forman un sistema armónico donde el Humano es el Orquestador.

require "lib/stargate/bootstrap.rb"
require "lib/stargate-LDtk/bootstrap.rb"
require "app/visibility.rb"
require "app/game_logic.rb"
require "app/input_manager.rb"
require "app/cinematic_cube.rb"

def tick args
  # 1. EL DESPERTAR (Frame 0)
  if args.state.tick_count == 0
    # Iniciar el contexto de Stargate (Kernel/Soberano)
    Stargate.initialize_context(args)

    # Iniciar el Puente de LDtk (La Realidad)
    StargateLDtk::Bridge.run(map: "app/worlds/world.ldtk")

    # Registrar configuración para la atmósfera
    Interprete.register_sprites({
      "PlayerSpawn" => { w: 16, h: 16 },
      "Torch"       => { w: 8, h: 16 }
    })
    
    # Memoria Sagrada: Cargar posición previa si existe
    pos = SacredPositionService.load
    args.state.pending_sacred_pos = pos if pos
  end

  # 2. ORQUESTACIÓN: Las piezas se saludan, pero no se pisan.
  
  # A. LOS INPUTS: Traducimos hardware a intenciones semánticas.
  InputManager.tick(args)
  
  # DISPARADOR MÍTICO (DEBUG: Tecla K para despertar el Cubo)
  args.state.trigger_cube = true if args.inputs.keyboard.key_down.k
  
  # B. MOMENTO DE STASIS / NARRATIVA
  # Si la cinemática está activa, ella tiene el control total de la pantalla.
  unless args.state.stargate_game_active
    CinematicCube.render(args)
    return
  end

  # C. EL MUNDO: Pulsamos el Bridge para cargar y renderizar.
  StargateLDtk::Bridge.tick(args)
  
  # D. FINALIZACIÓN: Si el jugador llega a la zona de victoria
  if args.state.victory
    CinematicCube.render_ending(args)
    return
  end

  # B. LA LÓGICA: Procesamos el alma del mundo (Físicas, Meta, Victoria)
  # Esta pieza muta args.state.ldtk.entities.
  GameLogic.tick(args)
  
  # C. LA ATMÓSFERA: Renderizamos la visibilidad sobre el mundo.
  # Esta pieza es ortogonal: solo lee de la verdad en el Bus Semántico.
  GameVisibility.render(args)
end
