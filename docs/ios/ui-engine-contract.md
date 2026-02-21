# iOS UI ↔ Mixxx Engine Contract (PoC)

## 1) Transport layer

- **Direction UI → engine**: command-oriented calls through an Objective-C++ bridge (`MixxxEngineBridge`) that writes to Mixxx ControlObjects.
- **Direction engine → UI**: event stream/callbacks (`onControlValueChanged`) for controls used by visible widgets.
- **Threading**:
  - UI calls are made from the main thread.
  - Engine callbacks are marshalled back to main thread before mutating SwiftUI state.
- **Data format**:
  - Controls are addressed as `group` + `item` (for example: `[Channel1]` + `play`).
  - Values are normalized `Double` in `[0.0, 1.0]` unless the control has natural units (`bpm`, `rate`).

### Control write API

```text
setControl(group: String, item: String, value: Double)
toggleControl(group: String, item: String)
triggerControl(group: String, item: String)
```

### Control subscribe API

```text
observeControl(group: String, item: String, callback: (Double) -> Void)
removeObserver(token)
```

## 2) Deck state contract

Per deck (`[Channel1]`, `[Channel2]`) UI reads/writes:

- Transport:
  - `play`
  - `cue_default`
  - `sync_enabled`
- Timing:
  - `bpm`
  - `rate`
  - `playposition`
- Mixer:
  - `volume`
  - `pregain`
- EQ:
  - `filterLow`
  - `filterMid`
  - `filterHigh`

## 3) EQ / FX params contract

### EQ quick mapping

- Deck EQ knobs map 1:1 to deck control objects:
  - `[ChannelN],filterLow`
  - `[ChannelN],filterMid`
  - `[ChannelN],filterHigh`

### FX unit mapping (PoC)

For a single visible FX unit:

- Enable:
  - `[EffectRack1_EffectUnit1],enabled`
- Dry/wet:
  - `[EffectRack1_EffectUnit1],mix`
- Per-effect first meta knob:
  - `[EffectRack1_EffectUnit1_Effect1],meta`

## 4) BPM sync events

UI subscribes to these events and renders explicit state badges:

- `[ChannelN],sync_enabled` (on/off)
- `[ChannelN],bpm` (current track BPM)
- `[ChannelN],rate` (tempo fader position)

Derived UI states:

- **SYNC armed**: `sync_enabled == 1`
- **Tempo drift warning**: `abs(bpmDeck1 - bpmDeck2) > 0.02`
- **Pitch override**: `sync_enabled == 1 && abs(rate) > 0.0001`

## 5) Safety / constraints

- No DSP work in UI modules.
- Gesture recognition does not directly call DSP code; it emits semantic actions (`DeckAction`) consumed by the bridge.
- Missing controls must fail soft (logged warning, UI remains responsive).
