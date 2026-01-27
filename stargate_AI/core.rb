# frozen_string_literal: true

# Stargate Core: The Sovereign API
# This is the single entry point for the Catalyst Runtime.
# Law of Silence: Internal organs are hidden; only the interface speaks.
<<<<<<< HEAD
module Stargate

=======

module Stargate
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
  class << self
    def activate!(args, mode: :standard)
      return if @active || @bootstrapping

      @bootstrapping = true
      @event_buffer  = []
      @args          = args
      @mode          = mode

      # Internals are loaded in order of dependency
      require "stargate_AI/random.rb"
      require "stargate_AI/state.rb"
      require "stargate_AI/view.rb"
      require "stargate_AI/protocol.rb"
      require "stargate_AI/injection.rb"
      require "stargate_AI/clock.rb"
      require "stargate_AI/stability.rb"
      require "stargate_AI/time_travel.rb"
      require "stargate_AI/immunology.rb"
      require "stargate_AI/kernel.rb"

      # Initialize subsystems
      bootstrap(args)
      Stargate::Stability.install!(args)

      # Two-phase activation: now ready to dispatch
      @active = true
      @bootstrapping = false
      
      # Flush buffered events from initialization
      flush_buffered_events
      
      # Emit boot event (will be dispatched immediately now)
      emit(:boot, mode: mode)
    end

    # 🌌 PUBLIC API: Intent Emission (the only way gameplay speaks)
<<<<<<< HEAD
    def intent(type, payload = {}, **options)
      source = options[:source] || :gameplay
=======
    def intent(type, payload = {}, source: :gameplay)
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
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
      return unless @active

<<<<<<< HEAD
      # CAUSAL LINK: Every gameplay intent marks the state as dirty.
      if source == :gameplay
        State.mark_dirty(:state, 
                         source: :intent, 
                         intention: "Gameplay Intent: #{type}",
                         trace: "Stargate.intent(:#{type})")
      end

=======
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
      dispatch(event)
    end

    # 🔍 PUBLIC API: Status (read-only, for editors/AI)
    def status
      {
        active: @active,
        mode: @mode,
        tick: (@args.state.tick_count rescue 0),
        paused: (Stargate::Clock.paused? rescue false)
      }
    end

    # 🎮 PUBLIC API: Manual Controls (legacy compatibility)
    def capture!
      Stargate::TimeTravel.capture_moment(@args) if @active
    end

    def recall!
      capsule = Stargate::TimeTravel.last_valid_capsule
      Stargate::TimeTravel.recall_moment(capsule) if capsule
    end

    def test_chaos!
<<<<<<< HEAD
      Stargate::Chaos.induce_failure if const_defined?(:Chaos)
=======
      Stargate::Chaos.induce_failure if defined?(Stargate::Chaos)
>>>>>>> bb138ce4c7e11f49833d4fc583e2c6e94318f434
    end

    def active?
      @active || false
    end

    private

    # Internal: Dispatch events to all interested parties
    def dispatch(event)
      View.handle_event(event)
      # Future:
      # Timeline.record(event)
      # LLM.observe(event)
    end

    # Internal: Flush buffered events from bootstrap
    def flush_buffered_events
      @event_buffer.each { |event| dispatch(event) }
      @event_buffer.clear
    end

    # Internal: System emits events with :system source
    def emit(type, payload = {})
      intent(type, payload, source: :system)
    end

    def bootstrap(args)
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
end
