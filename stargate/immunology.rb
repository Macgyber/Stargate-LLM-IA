# frozen_string_literal: true

module Stargate
  module Immunology
    @threat_history = []
    @error_cache    = {} # Signature based cache
    @max_auto_recalls = 3
    @error_ttl      = 5  # Seconds to "forget" an error signature
    
    class << self
      def install!
        return if @installed
        unless GTK::Runtime.ancestors.include?(Interception)
          GTK::Runtime.prepend(Interception)
        end
        @installed = true
        Stargate.intent(:trace, { message: "🛡️ Stargate Immunology Layer: Active & Selective." }, source: :system)
      end
      THREAT_LEVELS = {
        warning:     { severity: 3, action: :observe },
        recoverable: { severity: 4, action: :recall },
        critical:    { severity: 5, action: :freeze_and_recall },
        paradox:     { severity: 6, action: :absolute_stasis }
      }

      def handle_telemetry(subsystem, severity, message)
        # Selective Silence: Level 3 (warning) is our baseline for analysis.
        return unless severity >= 3

        # Avoid Recursive Loop: Ignore messages emitted by Stargate itself.
        return if message.include?("[STARGATE_VIEW]") || 
                  message.include?("[STARGATE_MACHINE]") ||
                  message.include?("[VIGILANTE]")

        # SIGNATURE MEMORY (Anti-Spam)
        signature = "#{message}_#{subsystem}_#{severity}"
        now = Time.now.to_f
        if @error_cache[signature] && (now - @error_cache[signature]) < @error_ttl
          return
        end
        @error_cache[signature] = now
        threat = classify(message)
        return unless threat

        process_threat(threat, message)
      end

      private

      def classify(message)
        # MRUBY COMPATIBILITY: Use include? instead of regex literals where possible.
        if message.include?("undefined method") && message.include?("for nil:NilClass")
          :recoverable
        elsif message.include?("Serialization data may be corrupt")
          :paradox
        elsif message.include?("divergence") || message.include?("not deterministic")
          :critical
        elsif message.include?("exception") || message.include?("error")
          :warning
        else
          nil
        end
      end

      def process_threat(level, evidence)
        action = THREAT_LEVELS[level][:action]
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
          Stargate.intent(:trace, { message: "👁️ Stargate-Immunology (WARN): #{evidence[0..100]}..." }, source: :system)
        when :recall
          Stargate.intent(:alert, { message: "💊 Stargate-Immunology (RECALL): Auto-Correction triggered." }, source: :system)
          trigger_recall!
        when :freeze_and_recall
          Stargate.intent(:alert, { message: "🛑 Stargate-Immunology (CRITICAL): Freezing universe for analysis." }, source: :system)
          Stargate::Clock.pause! rescue nil
          trigger_recall!
        when :absolute_stasis
          Stargate.intent(:alert, { message: "⚠️ STARGATE PARADOX: Absolute stasis forced. Agent intervention required." }, source: :system)
          Stargate::Clock.pause! rescue nil
        end
      end

      def trigger_recall!
        lvc = Stargate::TimeTravel.last_valid_capsule rescue nil
        if lvc
          Stargate.intent(:trace, { message: "✨ Stargate-Immunology: Reverting to last known valid capsule (T=#{lvc[:tick]})." }, source: :system)
          Stargate::TimeTravel.recall_moment(lvc)
        else
          Stargate.intent(:alert, { message: "❌ FAILED: No valid capsule found. Universal stasis engaged." }, source: :system)
          Stargate::Clock.pause! rescue nil
        end
      end

      def detect_failure_loop?(level)
        recent_threats = @threat_history.last(5).count { |t| t[:level] == level }
        recent_threats >= @max_auto_recalls
      end

      def log_threat(level, evidence)
        @threat_history << {
          level: level,
          at: Time.now.to_i,
          tick: ($gtk.args.state.tick_count rescue 0),
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
