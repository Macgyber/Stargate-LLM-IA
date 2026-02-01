# Stargate Chaos Lab: Sovereign Stress Test
# ---------------------------------------------------------
# INSTRUCTIONS:
# 1. Copy this content into your app/main.rb
# 2. Run the game.
# 3. Use controls:
#    - [C]: Trigger a CRITICAL CRASH (Verify NO Gray Screen)
#    - [S]: Request STASIS (Verify Clock Pause)
#    - [R]: Recover from Crash
# ---------------------------------------------------------

require "stargate/bootstrap.rb"

# The Sovereign Bridge
def tick args
  # LAW 1.1: Render First
  Stargate::Avatar.render(args, fail_safe: $stargate_fail_safe)
  
  begin
    unless Stargate.status[:booted]
      Stargate.initialize_context(args)
      Stargate.reset_world!
    end

    # Handle Verification Inputs
    handle_chaos_inputs(args)

    # Bridge Flow Control
    if $stargate_stasis_requested && !Stargate::Clock.paused?
      Stargate::Clock.pause!
    end

    # NORMAL GAME LOGIC (Protected)
    unless Stargate::Clock.paused?
      run_simulated_game(args)
    end
    
  rescue => e
    # LAW 10.1: Fail-Safe Visual
    $stargate_fail_safe = e
  end
end

def handle_chaos_inputs(args)
  if args.inputs.keyboard.key_down.c
    puts "🧨 TRIGGERING CHAOS: Critical Logic Failure!"
    raise "INTERNAL_ERROR: Causal Violation detected by User Request!"
  end

  if args.inputs.keyboard.key_down.s
    $stargate_stasis_requested = !$stargate_stasis_requested
    puts "⏸️  STASIS: #{$stargate_stasis_requested ? 'Requested' : 'Released'}"
    Stargate::Clock.resume! unless $stargate_stasis_requested
  end

  if args.inputs.keyboard.key_down.r
    $stargate_fail_safe = nil
    puts "🩹 RECOVERY: Sanctioned Fail-Safe Reset."
  end
end

def run_simulated_game(args)
  args.state.counter ||= 0
  args.state.counter += 1
  
  args.outputs.labels << {
    x: 640, y: 400,
    text: "Game Logic Running: #{args.state.counter}",
    alignment_enum: 1, size_enum: 2, r: 255, g: 255, b: 255
  }

  args.outputs.labels << {
    x: 640, y: 350,
    text: "[C] Crash  |  [S] Toggle Stasis  |  [R] Reset Fail-Safe",
    alignment_enum: 1, size_enum: 0, r: 150, g: 150, b: 150
  }
end
