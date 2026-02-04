# Stargate: The Body's Nervous System
# This file handles the interposition of the Stargate Runtime over the DragonRuby engine.

module Stargate
  module Interposition
    # Law of Precedence: We live BEFORE Object in the lookup chain.
    # We catch every 'tick' and call super (which finds it in Object/Kernel).
    def tick(args)
      $stargate_wrapped_frame = true
      # Law of Vigilance: The Guardian speaks before the world moves.
      Stargate::Vigilante.tick(args)
      
      # Law of Grace: The game MUST survive Stargate.
      # NOTA: Ya no retornamos si hay interrupción; permitimos el overlay del Vigilante.
      begin
        Stargate::Clock.tick(args) do
          Stargate::Stability.tick(args)
          begin
            # Solo llamamos al juego si no hay una interrupción crítica del Vigilante
            unless Stargate::Vigilante.interrupted
              super(args) 
            end
          rescue StandardError => e
            # INTERCEPTION: We caught a runtime error in the game loop.
            Stargate::Vigilante.shout!(args, :runtime_error, "#{e.class}: #{e.message}")
            Stargate.intent(:alert, { message: "🛡️ STARGATE INTERCEPTED: #{e.class}: #{e.message}" }, source: :game)
          rescue NameError => e
            Stargate::Vigilante.shout!(args, :logic_error, "Undefined name/method: #{e.message}")
          end
        end
      rescue => e
        # If Stargate fails, we still need to breathe.
        Stargate.intent(:alert, { message: "STARGATE CRITICAL: #{e.message}" }, source: :system) rescue nil
      ensure
        # 3. VIGILANCIA POST-MORTEM: Validamos la salud visual y el overlay
        Stargate::Vigilante.check_visual_health(args)
        Stargate::Vigilante.enforce_stasis(args) if Stargate::Vigilante.interrupted
        $stargate_wrapped_frame = false
      end
    end
  end

  module Bootstrap
    # Laws of the Machine
    def self.install!
      return if $stargate_installed
      
      # 1. AUTHORITY: Prepend our interposition module to Object
      unless Object.ancestors.include?(Stargate::Interposition)
        Object.prepend(Stargate::Interposition)
      end

      # 2. PROOF: Verify absolute authority via ancestry
      if verify_interposition
        Object.const_set(:STARGATE_INTERPOSED, :verified) rescue nil
        Stargate.intent(:trace, { message: "🛡️ Stargate Sovereignty Established." }, source: :system)
        Stargate::Immunology.install!
      else
        Stargate.intent(:alert, { message: "⚠️ STARGATE: Interposition failed Ancestry Check." }, source: :system)
      end

      $stargate_installed = true
      $stdout.flush
    end

    def self.verify_interposition
      Object.ancestors.include?(Stargate::Interposition) && 
             Object.new.method(:tick).owner == Stargate::Interposition rescue false
    end

    def self.infect!
      install!
    end

    def self.engage!
      install!
      $stargate_operational = true
    end
  end
end
