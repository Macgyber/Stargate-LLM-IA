# Internals are loaded immediately to support Sovereign Bridge availability
require "stargate/random.rb"
require "stargate/state.rb"
require "stargate/view.rb"
require "stargate/protocol.rb"
require "stargate/injection.rb"
require "stargate/clock.rb"
require "stargate/stability.rb"
require "stargate/time_travel.rb"
require "stargate/immunology.rb"
require "stargate/vigilante.rb"
require "stargate/diagnose.rb" 
require "stargate/avatar.rb"
require "stargate/ledger_keeper.rb"
require "stargate/kernel.rb"

# Stargate Core: The Sovereign API
# This is the single entry point for the Catalyst Runtime.
# Law of Silence: Internal organs are hidden; only the interface speaks.
module Stargate
  def self.initialize_context(args, heartbeat: false, mode: :standard)
      # 11. Sistema vivo: Sincronización continua de identidad.
      @args = args if args
      
      # DISPARADOR SOBERANO: 
      # Si el script se re-ejecuta (toplevel call) mientras ya estamos activos, detectamos mutación.
      if $stargate_active && args && !heartbeat
         unless Vigilante.interrupted || $stargate_sanctioned_reset
            Vigilante.shout!(args, :unsanctioned_mutation, "Structural Mutation Detected: Script re-executed without Causal Intent.")
         end
         
         # Limpiamos el flag de reset sancionado una vez usado
         $stargate_sanctioned_reset = false
         Vigilante.install!(args)
         Stability.install!(args)
         return
      end

      return if $stargate_active || @bootstrapping

      @bootstrapping = true
      @event_buffer  = []
      @mode          = mode

      # Initialize subsystems
      bootstrap(args)
      Stargate::Random.bootstrap_seed!(args) if args 
      Stargate::Stability.install!(args) if args
      Stargate::Vigilante.install!(args) if args

      @bootstrapping = false
      $stargate_active = true if args
      
      flush_buffered_events if $stargate_active
      emit(:boot, mode: mode)      # Friendly Welcome Message
      # intent(:trace, { message: "🌌 Stargate Systems Online. What do you want to build today?" }, source: :system) if $stargate_active
    end

    # 🌌 PUBLIC API: Intent Emission (the only way gameplay speaks)
    def self.intent(type, payload = {}, **options)
      source = options[:source] || :gameplay
      event = {
        type: type,
        payload: payload,
        tick: (@args&.state&.tick_count rescue nil), # tick may be nil during early bootstrap or foreign invocation
        timestamp: Time.now.to_f,
        source: source
      }

      # Law of Bootstrap: Events during initialization are buffered
      if @bootstrapping
        @event_buffer << event
        return
      end

      # Law of Runtime: Only active systems dispatch
      return unless active?

      # CAUSAL LINK: Every gameplay intent marks the state as dirty.
      if source == :gameplay
        State.mark_dirty(:state, 
                         source: :intent, 
                         intention: "Gameplay Intent: #{type}",
                         trace: "Stargate.intent(:#{type})")
      end

      dispatch(event)
    end

    # 🔍 PUBLIC API: Status (read-only, for editors/AI)
    # LEY 3: Unified Status Authority
    def self.status
      {
        active: $stargate_active || false,
        interrupted: Vigilante.interrupted,
        booted: $stargate_booted || false,
        stasis_requested: $stargate_stasis_requested || false,
        fail_safe: $stargate_fail_safe != nil
      }
    end

    # 🎮 PUBLIC API: Manual Controls (legacy compatibility)
    def self.capture!
      Stargate::TimeTravel.capture_moment(@args) if active?
    end

    def self.recall!
      capsule = Stargate::TimeTravel.last_valid_capsule
      Stargate::TimeTravel.recall_moment(capsule) if capsule
    end

    def self.reset_world!
      return unless active?
      
      # Ritual de purificación: Resolvemos el interrupt persistente
      # Marcamos la próxima recarga como 'sancionada'
      $stargate_sanctioned_reset = true
      Vigilante.resolve!(@args)
      Clock.resume!
      
      intent(:trace, { message: "🛡️ Stargate: Ritual of Purification complete. Causal integrity restored." }, source: :system)
    end

    def self.active?
      $stargate_active || false
    end

    private

    # Internal: Dispatch events to all interested parties
    def self.dispatch(event)
      View.handle_event(event)
      # Future:
      # Timeline.record(event)
      # LLM.observe(event)
    end

    # Internal: Flush buffered events from bootstrap
    def self.flush_buffered_events
      @event_buffer.each { |event| dispatch(event) }
      @event_buffer.clear
    end

    # Internal: System emits events with :system source
    def self.emit(type, payload = {})
      intent(type, payload, source: :system)
    end

    def self.bootstrap(args)
      # Establish Sovereignty
      Stargate::Bootstrap.engage!
      
      # Configure based on mode
      case @mode
      when :chaos_lab
        $stargate_debug = true
      when :silent
        $stargate_debug = false
      end
  end
end
