# frozen_string_literal: true

module Stargate
  module Stability
    @asset_timestamps = {}
    @lock_file = ".stargate_lock"

    class << self

      def install!(args)
        enforce_single_instance(args)
        scan_assets(args)
        Stargate.intent(:trace, { message: "🏛️ Stargate-LLM-IA: Stability & Watcher Layer Active." }, source: :system)
      end

      def tick(args)
        enforce_single_instance(args) if args.state.tick_count % 30 == 0
        watch_assets(args) if args.state.tick_count % 60 == 0
      end

      private

      # Sovereign Law: Only one instance of the world shall exist.
      # Sovereign Law: Only one instance of the world shall exist.
      def enforce_single_instance(args)
        @birth_time ||= Time.now.to_f
        last_lock = args.gtk.read_file(@lock_file)
        
        # Periodic Authority Verification
        if last_lock
          last_time = last_lock.strip.to_f rescue 0.0

          # Tolerance of 0.01s to prevent floating point rounding errors (self-termination)
          if last_time > (@birth_time + 0.01)
            # Law of Succession: A newer instance has been born, we must yield
            Stargate.intent(:alert, { message: "☢️ STARGATE: Newer instance detected. Yielding authority..." }, source: :system)
            $gtk.request_quit
            return
          end
        end

        # Claim authority on birth (and refresh lock to keep it alive if needed in future)
        if args.state.tick_count == 0
          args.gtk.write_file(@lock_file, @birth_time.to_s)
          Stargate.intent(:trace, { message: "Claimed Authority (Birth: #{@birth_time})." }, source: :system)
        end
      end

      # Asset Sentinel: Vigilance over visual resources.
      def scan_assets(args)
        # Initialize timestamps for all PNGs in images/
        pngs = args.gtk.list_files("images").select { |f| f.end_with?(".png") }
        pngs.each do |f|
          path = "images/#{f}"
          stat = args.gtk.stat_file(path)
          @asset_timestamps[path] = stat[:modtime] if stat
        end
      end

      def watch_assets(args)
        pngs = args.gtk.list_files("images").select { |f| f.end_with?(".png") }
        pngs.each do |f|
          path = "images/#{f}"
          stat = args.gtk.stat_file(path)
          next unless stat


          if @asset_timestamps[path] && stat[:modtime] > @asset_timestamps[path]
            # Narrative call handled by the intent below.
            args.gtk.reset_sprite(path)
            @asset_timestamps[path] = stat[:modtime]

            # CAUSAL LINK: Asset changes are emergent deviations from stasis.
            State.mark_dirty(:assets, 
                             source: :emergent, 
                             intention: "Asset Hot-Reload: #{f}",
                             trace: path)

            # SIGNAL: We detected a mutation. We acknowledge it once.
            Stargate.intent(:trace, { message: "🔄 STARGATE: Asset Mutation Detected: #{f}" }, source: :system)
          end
        end
      end
    end
  end
end
