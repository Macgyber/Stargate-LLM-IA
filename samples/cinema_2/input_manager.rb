# app/input_manager.rb - La Intención Semántica (Pieza Ortogonal)
# =========================================================
# Este módulo traduce el hardware físico en "Deseos" Semánticos.
# No sabe qué hace el Player, solo sabe qué quiere hacer el Humano.

module InputManager
  def self.tick(args)
    ldtk = args.state.ldtk
    return unless ldtk && ldtk.status == :active
    
    # Proveer el Bus de Intenciones si no existe
    ldtk.intents ||= {
      move_x: 0,
      jump_pressed: false,
      jump_held: false,
      interact_pressed: false,
      reset_pressed: false
    }
    
    intents = ldtk.intents
    kb = args.inputs.keyboard
    controller = args.inputs.controller_one # Soporte básico para mando
    
    # 1. Movimiento Horizontal
    intents.move_x = kb.left_right
    intents.move_x = controller.left_right if intents.move_x == 0 && controller
    
    # 2. Salto y Acción
    intents.jump_pressed = kb.key_down.space || (controller && controller.key_down.a)
    intents.jump_held    = kb.key_held.space || (controller && controller.key_held.a)
    
    # 3. Interacción (E)
    intents.interact_pressed = kb.key_down.e || (controller && controller.key_down.x)
    
    # 4. Comandos de Sistema (R para reset de victoria o debug)
    intents.reset_pressed = kb.key_down.r
    intents.world_view_held = kb.key_held.r
    
    # 5. Vocalización Técnica (Opcional, para debug en bus)
    # puts "🎮 Intents: #{intents}" if args.state.tick_count % 60 == 0
  end
end
