module Stargate
  # The Sovereignty of Randomness.
  # This module governs the Randomness Contract (XVII).
  # All non-deterministic RNG calls are intercepted or replaced.
  module Random
    @prng = nil
    @calls_this_frame = 0
    @current_seed = 0

    def self.calls_this_frame
      @calls_this_frame
    end

    def self.current_seed
      @current_seed
    end

    # Sovereign entry point for each frame.
    def self.begin_frame(seed)
      @current_seed = seed
      @prng = ::Random.new(seed)
      @calls_this_frame = 0
    end

    # 8. Reparar antes de existir: Seed de emergencia para el bootstrap
    def self.bootstrap_seed!(args)
      # Usamos el tick_count real o el tiempo como ancla definitiva de primer frame
      seed = (($gtk.args.state.tick_count rescue 0) + 1) * 1000
      begin_frame(seed)
    end

    # Deterministic random value.
    def self.rand(max = 1.0)
      ensure_seeded!
      @calls_this_frame += 1
      @prng.rand(max)
    end

    def self.reset!
      @prng = nil
      @calls_this_frame = 0
    end

    private

    def self.ensure_seeded!
      return if @prng
      
      # 11. Sistema vivo: Si el calambre ocurre, intentamos estirar el músculo antes de que duela.
      # Si estamos en bootstrap o primer tick, forzamos un seed basado en el tiempo real del motor.
      if $gtk && ($gtk.args.state.tick_count rescue -1) >= 0
        bootstrap_seed!($gtk.args)
        return
      end

      raise "CRITICAL: Randomness Law violated. RNG called before seeding for frame."
    end
  end
end

# INTERCEPTION: Hot-patching DragonRuby and Ruby Kernel.
# Warning: This is a surgical operation required by Law XVII.
module Kernel
  def rand(max = 1.0)
    Stargate::Random.rand(max)
  end
end

if $gtk
  # Intercepting DragonRuby's GTK random interface
  def $gtk.rand(max = 1.0)
    Stargate::Random.rand(max)
  end
end
