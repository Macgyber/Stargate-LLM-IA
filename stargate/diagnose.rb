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

      # 2. Causal Debt Check (Passive)
      # LEY 3: Absolute authority in args
      if args.gtk.read_file(".stargate/causal_debt.json")
        cramps << "DEBT CRAMP: Unresolved technical debt detected in storage."
      end

      # 3. Synchronicity Check
      root_index = args.gtk.read_file("../../stargate/index.yaml") rescue nil
      local_index = args.gtk.read_file("stargate/index.yaml")
      if root_index && local_index && root_index != local_index
        cramps << "SYNC CRAMP: SDK index is out of sync with root index."
      end

      # 4. Identity Check
      unless Stargate.status[:active]
        cramps << "IDENTITY CRAMP: Stargate interposition is not active."
      end

      # 5. Mutation Check
      if Stargate::Vigilante.interrupted
        cramps << "MUTATION CRAMP: Unsanctioned code modification detected."
      end

      if cramps.empty?
        # Silence is health.
      else
        puts "❌ STARGATE CRAMPS DETECTED:"
        cramps.each { |c| puts "  - #{c}" }
      end

      cramps
    end
  end
end
