# Stargate: The Body's Nervous System
# This file handles the interposition of the Stargate Runtime over the DragonRuby engine.

module Stargate
  module Interposition
    # Law of Precedence: We live BEFORE Object in the lookup chain.
    # We catch every 'tick' and call super (which finds it in Object/Kernel).
    def tick(args)
      # Law of Grace: The game MUST survive Stargate.
      begin
        Stargate::Clock.tick(args) do
          Stargate::Stability.tick(args)
          begin; super(args); rescue NameError; end
        end
      rescue => e
        # If Stargate fails, we still need to breathe.
        Stargate.intent(:alert, { message: "STARGATE CRITICAL: #{e.message}" }, source: :system) rescue nil
      end
    end
  end

  module Bootstrap
    class << self
      # Laws of the Machine
      def install!

        return if $stargate_installed
        
        # 1. AUTHORITY: Prepend our interposition module to Object
        # This puts us at the head of the chain (Object.ancestors[0]).
        unless Object.ancestors.include?(Stargate::Interposition)

          Object.prepend(Stargate::Interposition)
        end

        # 2. PROOF: Verify absolute authority via ancestry
        if verify_interposition
          # Final Sentinel (Symbol based, not string)
          Object.const_set(:STARGATE_INTERPOSED, :verified) rescue nil
          Stargate.intent(:trace, { message: "🛡️ Stargate Sovereignty Established." }, source: :system)
          
          # Initialize new systems
          Stargate::Immunology.install!
        else
          Stargate.intent(:alert, { message: "⚠️ STARGATE: Interposition failed Ancestry Check." }, source: :system)
        end

        $stargate_installed = true
        $stdout.flush
      end

      # The Canonical Proof: Structural, not procedure-based.
      def verify_interposition
        # In Ruby, prepend places the module BEFORE the class in ancestors.
        # But for 'Object', ancestors[0] should be our module.
        ours = Object.ancestors.include?(Stargate::Interposition) && 
               Object.new.method(:tick).owner == Stargate::Interposition rescue false
        

        ours
      end

      # High-Level API
      def infect!
        install!
      end

      def engage!
        install!
        $stargate_operational = true
      end
    end
  end
end
