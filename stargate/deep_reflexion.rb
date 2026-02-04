# 🌌 STARGATE: DEEP REFLEXION (Level 2 Interception)
# Status: EXECUTION
# Objective: Total systemic awareness via __log__ hook.
# -----------------------------------------------------------------------------

module Stargate
  module DeepReflexion
    @intercepting = false
    @busy         = false
    @debt_map     = {}
    $stargate_disable_interception = false

    def self.patch!
      return if @intercepting
      
      # Level 1: GTK::Log (Convenience)
      if Object.const_defined?(:GTK) && GTK.const_defined?(:Log) && GTK::Log.respond_to?(:write_to_log_and_puts)
        patch_class_method(GTK::Log, :write_to_log_and_puts, :intercept_log_high)
      end

      # Level 2: GTK::Runtime (Deep)
      if Object.const_defined?(:GTK) && GTK.const_defined?(:Runtime)
        patch_instance_method(GTK::Runtime, :__log__, :intercept_log_deep)
      end

      @intercepting = true
      $gtk.window_title = "STARGATE: DEEP REFLEXION (LEVEL 2)" if $gtk.respond_to?(:window_title=)
    end

    def self.patch_class_method(target, method_name, interceptor_name)
      metaclass = class << target; self; end
      orig_name = "__stargate_orig_#{method_name}"
      unless metaclass.method_defined?(orig_name)
        metaclass.send(:alias_method, orig_name, method_name)
        target.define_singleton_method(method_name) do |*args|
          Stargate::DeepReflexion.send(interceptor_name, args)
        end
      end
    end

    def self.patch_instance_method(target, method_name, interceptor_name)
      orig_name = "__stargate_orig_#{method_name}"
      unless target.method_defined?(orig_name)
        target.send(:alias_method, orig_name, method_name)
        target.send(:define_method, method_name) do |*args|
          Stargate::DeepReflexion.send(interceptor_name, self, args)
        end
      end
    end

    # INTERCEPTORS
    # -------------------------------------------------------------------------

    def self.intercept_log_high(args)
      # Fallthrough to deep interceptor if active
      GTK::Log.__stargate_orig_write_to_log_and_puts(*args)
    end

    def self.intercept_log_deep(instance, args)
      # args for __log__ are [subsystem, log_enum, str]
      subsystem, log_enum, str = args
      
      # Kill-switch & Reentrancy
      if $stargate_disable_interception || @busy
        return instance.__stargate_orig___log__(subsystem, log_enum, str)
      end

      @busy = true
      begin
        analyze_causality(str, log_enum, subsystem)
      rescue
        # Fail silently
      ensure
        @busy = false
      end

      instance.__stargate_orig___log__(subsystem, log_enum, str)
    end

    def self.analyze_causality(message, severity_enum = 2, subsystem = nil)
      # severity_enum: 0=spam, 1=debug, 2=info, 3=warn, 4=error
      if severity_enum >= 3 || message.include?("ERROR:") || message.include?("EXCEPTION:")
        node_id = identify_node(message, subsystem)
        accumulate_debt(node_id, severity: (severity_enum == 4 ? :hard : :soft), message: message)
      end
    end

    def self.identify_node(message, subsystem)
      return :engine if subsystem == "Engine"
      return :rendering if message.include?("primitives")
      return :logic if message.include?("main.rb")
      :unknown_causality
    end

    def self.accumulate_debt(node_id, severity:, message:)
      @debt_map[node_id] ||= { debt: 0.0, count: 0, last_tick: 0, digest: "" }
      @debt_map[node_id][:debt] += (severity == :hard ? 1.0 : 0.1)
      @debt_map[node_id][:count] += 1
      @debt_map[node_id][:last_tick] = ($gtk.args.state.tick_count rescue 0)
      @debt_map[node_id][:digest] = message[0..80].gsub("\n", " ").strip + "..."
    end
    
    def self.debt_report
      @debt_map
    end
  end
end

def stargate
  Stargate::DeepReflexion
end
