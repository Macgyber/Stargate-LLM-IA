module Stargate
  module Diagnostics
    def self.check_cramps(args)
      cramps = []

      # 1. RNG Check
      begin
        args.gtk.rand
      rescue => e
        cramps << "RNG CRAMP: #{e.message}"
      end

      # 2. Causal Debt Check
      if $gtk.read_file(".stargate/causal_debt.json")
        cramps << "DEBT CRAMP: Unresolved causal debt detected on disk."
      end

      # 3. Synchronicity Check
      root_index = $gtk.read_file("../../stargate/index.yaml") rescue nil
      local_index = $gtk.read_file("stargate/index.yaml")
      if root_index && root_index != local_index
        cramps << "SYNC CRAMP: SDK index is out of sync with root index."
      end

      # 4. Identity Check
      unless $stargate_operational
        cramps << "IDENTITY CRAMP: Stargate Interposition not operational."
      end

      # 5. Mutation Check
      main_stat = $gtk.stat_file("app/main.rb")
      if main_stat && args.state.tick_count > 0
         # This leverages the Vigilante's fingerprinting if available
         if Stargate::Vigilante.interrupted && 
            Stargate::Vigilante.violation&.dig(:type) == :unsanctioned_mutation
           cramps << "MUTATION CRAMP: Unsanctioned code modification detected."
         end
      end

      if cramps.empty?
        # puts "✅ STARGATE HEALTH: No cramps detected. The organism is fluid."
      else
        puts "❌ STARGATE CRAMPS DETECTED:"
        cramps.each { |c| puts "  - #{c}" }
        puts "👉 Fix these to restore causal sovereignty."
      end

      cramps
    end
  end
end
