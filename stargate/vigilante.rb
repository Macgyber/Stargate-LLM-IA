module Stargate
  # 🛡️ VIGILANTE: The Infrastructure Guardian
  # v2.1 - Unsanctioned Mutation Detection
  # Erradicar, no esconder.
  module Vigilante
    @interrupted = false
    @active      = false
    @violation   = nil
    @debt_file   = ".stargate/causal_debt.json"
    @source_fingerprints = {}
    
    def self.violation
      @violation
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
        @source_fingerprints = $stargate_source_anchor
        # DISPARADOR: Si estamos re-instalando (hot-reload), validamos inmediatamente
        validate_contract(args, reason: :structural_reload)
      else
        fingerprint_sources(args)
        $stargate_source_anchor = @source_fingerprints
        # Stargate.intent(:trace, { message: "🛡️ Vigilante: Session Anchor established." }, source: :system)
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

    # 🚨 SHOUT: The world stops here.
    def self.shout!(type, message)
      return if interrupted
      
      $stargate_vigilante_interrupted = true
      @violation = { 
        type: type, 
        message: message, 
        tick: ($gtk.args.state.tick_count rescue 0),
        recorded_at: Time.now.to_f
      }
      
      record_debt(@violation)
      puts "[VIGILANTE_INTERRUPT] TYPE: #{type} | MSG: #{message}"
      
      Stargate.intent(:alert, { 
        message: "🛑 VIGILANTE INTERRUPT: #{message}",
        debt: @violation,
        hint: "The organism has detected an unauthorized change in its own structure."
      }, source: :system)

      Stargate::Clock.pause! rescue nil
    end

    # 🔓 RECOVERY
    def self.resolve!(args)
      $stargate_vigilante_interrupted = false
      @violation = nil
      # Update fingerprints to accept the mutation as the new reality
      fingerprint_sources(args)
      $stargate_source_anchor = @source_fingerprints # Sello de nueva realidad
      $gtk.delete_file(@debt_file) rescue nil
      Stargate.intent(:trace, { message: "🛡️ Vigilante: Debt paid. New reality anchored." }, source: :system)
    end

    private

    def self.fingerprint_sources(args)
      # We only monitor files declared in our index (The Constitution)
      # For now, we anchor app/main.rb as the primary organ.
      files = ["app/main.rb"]
      files.each do |f|
        stat = $gtk.stat_file(f)
        if stat
          # Handle both Hash and Array return types from DragonRuby stat_file
          modtime = stat.is_a?(Hash) ? stat[:modtime] : stat[0]
          @source_fingerprints[f] = modtime
          # puts "[VIGILANTE_SIGHT] Anchored fingerprint for #{f} at #{modtime}"
        else
          # puts "[VIGILANTE_SIGHT] WARNING: Could not anchor #{f}"
        end
      end
    end

    def self.validate_contract(args, reason: :heartbeat)
      return unless $stargate_source_anchor.is_a?(Hash)
      
      # 10. Gemini Protocol: Audit the Ledger
      Stargate::LedgerKeeper.audit!

      $stargate_source_anchor.each do |file, last_time|
        next unless last_time
        info = $gtk.stat_file(file)
        next unless info
        
        # Handle both Hash and Array return types from DragonRuby stat_file
        current_time = info.is_a?(Hash) ? info[:modtime] : info[0]
        next unless current_time
        
        if current_time.to_i > last_time.to_i
          unless Stargate::State.dirty_types.include?(:reloading) || Stargate::State.dirty_types.include?(:logic)
             msg = reason == :structural_reload ? "Unsanctioned Structural Mutation" : "Design Leak"
             shout!(:unsanctioned_mutation, "#{msg}: Unauthorized modification detected in #{file}")
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
      if args.state.tick_count % 60 == 0
        puts "  [STASIS] Waiting for Causal Debt resolution: #{@violation[:message]}"
      end
      Stargate::Clock.pause! rescue nil
    end

    def self.check_system_health(args)
      # Immunology / Divergence Check
    end
  end
end
