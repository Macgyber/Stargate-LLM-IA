module Stargate
  # 🛡️ VIGILANTE: The Infrastructure Guardian
  # v2.1 - Unsanctioned Mutation Detection
  # Erradicar, no esconder.
  module Vigilante
    @debt_file   = ".stargate/causal_debt.json"
    
    def self.violation
      $stargate_violation
    end

    def self.interrupted
      $stargate_vigilante_interrupted || false
    end

    def self.active?
      $stargate_vigilante_active || false
    end

    def self.install!(args)
      return unless args
      $stargate_vigilante_active = true
      
      # 1. Sesión Soberana: Anclar la realidad una sola vez.
      if $stargate_source_anchor
        # DISPARADOR: Si estamos re-instalando (hot-reload), validamos inmediatamente
        validate_contract(args, reason: :structural_reload)
      else
        fingerprint_sources(args)
        # $stargate_source_anchor is already set in fingerprint_sources
      end
      
      # 4. Memoria de fallos: Check for unresolved debts on boot
      check_for_debts(args)
    end

    # ⚡ THE BEAT
    def self.tick(args)
      return unless active?
      
      if interrupted
        enforce_stasis(args)
        return
      end

      validate_contract(args)
      check_system_health(args)
    end

    # 🚨 SHOUT: Sensor event emission (Passive)
    def self.shout!(args, type, message)
      # LEY 5.1: Vigilante never controls flow. It requests intention.
      $stargate_vigilante_interrupted = true
      $stargate_violation = { 
        type: type, 
        message: message, 
        tick: (args.state.tick_count rescue 0),
        recorded_at: Time.now.to_f
      }
      
      # We no longer write to disk here. We emit a technical intent.
      # The Bridge or a dedicated Archivist will handle persistence.
      puts "🛡️ [VIGILANTE_SIGHT] #{type.to_s.upcase}: #{message}"
      
      Stargate.intent(:alert, { 
        type: type,
        message: "🛑 VIGILANTE: #{message}",
        debt: @violation
      }, source: :system)

      # Request stasis but don't enforce it.
      $stargate_stasis_requested = true
    end

    # 🔓 RECOVERY
    def self.resolve!(args)
      $stargate_vigilante_interrupted = false
      $stargate_stasis_requested = false
      @violation = nil
      # Update fingerprints to accept the mutation as the new reality
      fingerprint_sources(args)
      $stargate_source_anchor = @source_fingerprints
      Stargate.intent(:trace, { message: "🛡️ Vigilante: Reality recalibrated." }, source: :system)
    end

    private

    def self.fingerprint_sources(args)
      # LEY 3: Absolute authority in args
      $stargate_source_anchor = {}
      files = ["app/main.rb"]
      files.each do |f|
        stat = args.gtk.stat_file(f)
        if stat
          modtime = stat.is_a?(Hash) ? stat[:modtime] : stat[0]
          $stargate_source_anchor[f] = modtime
        end
      end
    end

    def self.validate_contract(args, reason: :heartbeat)
      return unless $stargate_source_anchor.is_a?(Hash)
      
      $stargate_source_anchor.each do |file, last_time|
        next unless last_time
        info = args.gtk.stat_file(file)
        next unless info
        
        current_time = info.is_a?(Hash) ? info[:modtime] : info[0]
        next unless current_time
        
        if current_time.to_i > last_time.to_i
          unless Stargate::State.dirty_types.include?(:reloading) || Stargate::State.dirty_types.include?(:logic)
             msg = reason == :structural_reload ? "Unsanctioned Structural Mutation" : "Design Leak"
             shout!(args, :unsanctioned_mutation, "#{msg} in #{file}")
          end
        end
      end
    end

    def self.check_for_debts(args)
      debt_data = $gtk.read_file(@debt_file)
      if debt_data
        begin
          @violation = $gtk.deserialize_state(debt_data)
          @interrupted = true
          Stargate.intent(:alert, { 
            message: "⚠️ UNRESOLVED CAUSAL DEBT: #{@violation[:message]}",
            hint: "Failure from a previous timeline detected. The system refuses to forget."
          }, source: :system)
          Stargate::Clock.pause!
        rescue
          shout!(:integrity_error, "Debt Memory Corrupted. Total Stasis invoked.")
        end
      end
    end

    def self.record_debt(data)
      $gtk.write_file(@debt_file, $gtk.serialize_state(data))
    end

    def self.enforce_stasis(args)
      # Silenciamos el log spam durante las pruebas de caos
      Stargate::Clock.pause! rescue nil
    end

    def self.check_system_health(args)
      # Immunology / Divergence Check
    end
  end
end
