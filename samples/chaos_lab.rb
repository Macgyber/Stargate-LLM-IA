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
      $stargate_debug = true
    end

    # --- MANUAL VERIFICATION PLAYGROUND ---
    # No automated sequences are enforced here.
    # Decisions are left to the Human-in-the-loop.

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

  if args.inputs.keyboard.key_down.l
    puts "📖 [LEDGER] Initiating Structural Audit..."
    $stargate_audit_report = Stargate::LedgerKeeper.audit!(args)
  end

  if args.inputs.keyboard.key_down.k
    if $stargate_audit_report && ($stargate_audit_report[:ghosted].any? || $stargate_audit_report[:status] == :violations)
      puts "⚖️ [JUDGEMENT] Causal Debt Accepted. Enacting Stasis."
      $stargate_stasis_requested = true
    else
      puts "⚖️ [JUDGEMENT] No critical debt to accept."
    end
  end

  if args.inputs.keyboard.key_down.r
    $stargate_fail_safe = nil
    $stargate_audit_report = nil
    puts "🩹 RECOVERY: Sanctioned Fail-Safe Reset."
  end
end

def run_simulated_game(args)
  args.state.counter ||= 0
  args.state.counter += 1
  
  # Main HUD
  args.outputs.labels << {
    x: 640, y: 440,
    text: "Game Logic Running: #{args.state.counter}",
    alignment_enum: 1, size_enum: 2, r: 255, g: 255, b: 255
  }

  # LEDGER HUD (The Book of Truth)
  if $stargate_audit_report
    r = $stargate_audit_report
    color = (r[:ghosted].any? ? [255, 100, 100] : [100, 255, 100])
    summary = "LEDGER: Births: #{r[:birthed].size} | Ghosts: #{r[:ghosted].size}"
    
    args.outputs.labels << {
      x: 640, y: 380,
      text: summary,
      alignment_enum: 1, size_enum: 1, r: color[0], g: color[1], b: color[2]
    }
    
    if r[:ghosted].any?
      args.outputs.labels << {
        x: 640, y: 350,
        text: "GHOST NODES DETECTED: #{r[:ghosted].join(', ')}",
        alignment_enum: 1, size_enum: -1, r: 255, g: 50, b: 50
      }
    end
  end

  args.outputs.labels << {
    x: 640, y: 150,
    text: "[C] Crash | [S] Stasis | [L] Audit Ledger | [K] Accept Truth | [R] Reset",
    alignment_enum: 1, size_enum: 0, r: 150, g: 150, b: 150
  }

  args.outputs.labels << {
    x: 640, y: 120,
    text: "MANUAL VERIFICATION PLAYGROUND - NO AUTO-ENFORCEMENT",
    alignment_enum: 1, size_enum: -2, r: 100, g: 100, b: 100
  }
end
