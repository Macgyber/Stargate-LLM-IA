# frozen_string_literal: true

# Stargate Core: The Sovereign API
# This is the single entry point for the Catalyst Runtime.
# Law of Silence: Internal organs are hidden; only the interface speaks.
module Stargate
  class << self
    def initialize_context(args, mode: :standard)
      return if @active || @bootstrapping

      @bootstrapping = true
      @event_buffer  = []
      @args          = args
      @mode          = mode

      # Internals are loaded in order of dependency
      require "stargate/random.rb"
      require "stargate/state.rb"
      require "stargate/view.rb"
      require "stargate/protocol.rb"
      require "stargate/injection.rb"
      require "stargate/clock.rb"
      require "stargate/stability.rb"
      require "stargate/time_travel.rb"
      require "stargate/immunology.rb"
      require "stargate/kernel.rb"

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
    def intent(type, payload = {}, **options)
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
      return unless @active

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
      Stargate::Chaos.induce_failure if const_defined?(:Chaos)
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
