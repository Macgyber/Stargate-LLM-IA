# frozen_string_literal: true

module Stargate
  module Immunology
    @threat_history = []
    @max_auto_recalls = 3
    
    class << self
      # Law of Senses: The system must feel everything to protect itself.
      def install!
        return if @installed
        unless GTK::Runtime.ancestors.include?(Interception)
          GTK::Runtime.prepend(Interception)
        end
        @installed = true
        Stargate.intent(:trace, { message: "🛡️ Stargate-LLM-IA: Causal Sovereignty Active." }, source: :system)
      end

      # Hierarchy of Threats: Classification of causal ripples.
      THREAT_LEVELS = {
        warning:     { severity: 3, action: :observe },
        recoverable: { severity: 4, action: :recall },
        critical:    { severity: 5, action: :freeze_and_recall },
        paradox:     { severity: 6, action: :absolute_stasis }
      }

      def handle_telemetry(subsystem, severity, message)
        # Filter noise
        return unless severity >= 3

        threat = classify(message)
        return unless threat

        process_threat(threat, message)
      end

      private

      def classify(message)
        case message
        when /undefined method `.*' for nil:NilClass/
          :recoverable
        when /Serialization data may be corrupt/
          :paradox
        when /divergence|not deterministic/i
          :critical
        when /exception|error/i
          :warning
        else
          nil
        end
      end

      def process_threat(level, evidence)
        action = THREAT_LEVELS[level][:action]
        
        # Immune Memory: Protect against recursive failure
        if detect_failure_loop?(level)
          Stargate.intent(:alert, { message: "⚠️ IMMUNE COLLAPSE: Failure loop detected. Escalating to PARADOX." }, source: :system)
          action = :absolute_stasis
        end

        log_threat(level, evidence)
        execute_action(action, level, evidence)
      end

      def execute_action(action, level, evidence)
        case action
        when :observe
          Stargate.intent(:trace, { message: "👁️ Stargate-LLM-IA (WARN): Observing breach: #{evidence[0..60]}" }, source: :system)
        
        when :recall
          Stargate.intent(:alert, { message: "💊 Stargate-LLM-IA (RECALL): Auto-Correction triggered." }, source: :system)
          trigger_recall!

        when :freeze_and_recall
          Stargate.intent(:alert, { message: "🛑 Stargate-LLM-IA (CRITICAL): Freezing universe for analysis." }, source: :system)
          Stargate::Clock.pause!
          trigger_recall!

        when :absolute_stasis
          Stargate.intent(:alert, { message: "⚠️ STARGATE-LLM-IA PARADOX: Absolute stasis forced. Agent intervention required." }, source: :system)
          Stargate::Clock.pause!
          # We don't use $gtk.notify!, the Governor decides how to alert.
        end
      end

      def trigger_recall!
        lvc = Stargate::TimeTravel.last_valid_capsule
        if lvc
          Stargate.intent(:trace, { message: "✨ Stargate-LLM-IA: Reverting to last known valid capsule (T=#{lvc[:tick]})." }, source: :system)
          Stargate::TimeTravel.recall_moment(lvc)
        else
          Stargate.intent(:alert, { message: "❌ FAILED: No valid capsule found. Universal stasis engaged." }, source: :system)
          Stargate::Clock.pause!
        end
      end

      def detect_failure_loop?(level)
        recent_threate = @threat_history.last(5).count { |t| t[:level] == level }
        recent_threate >= @max_auto_recalls
      end

      def log_threat(level, evidence)
        @threat_history << {
          level: level,
          at: Time.now.to_i,
          tick: $gtk.args.state.tick_count,
          evidence: evidence[0..100]
        }
      end
    end

    module Interception
      def __log__(subsystem, log_enum, str)
        Stargate::Immunology.handle_telemetry(subsystem, log_enum, str)
        super(subsystem, log_enum, str)
      end
    end
  end
end
