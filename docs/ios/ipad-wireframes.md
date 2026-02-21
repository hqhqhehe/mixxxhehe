# iPad 2-Deck Mixer Wireframes + Control Mapping

## Wireframe (landscape)

```text
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ Deck A                                                                                   Deck B         │
│ ┌─────────────── Waveform A ────────────────┐                        ┌────────────── Waveform B ──────┐ │
│ │ pos, beatgrid, playhead                    │                        │ pos, beatgrid, playhead         │ │
│ └────────────────────────────────────────────┘                        └──────────────────────────────────┘ │
│ [PLAY] [CUE] [SYNC]   BPM: 124.00  RATE: +0.00%                      [PLAY] [CUE] [SYNC]               │
│                                                                                                           │
│ EQ:  LOW  MID  HIGH                     CROSSFADER                     EQ:  LOW  MID  HIGH               │
│      ○    ○    ○                    <──────────────>                        ○    ○    ○                 │
│      VOL fader                                                                             VOL fader     │
│      │                                                                                          │       │
│      │                                                                                          │       │
│                                                                                                           │
│ FX UNIT: [ON] [DRY/WET knob] [META knob]                                                               │
└─────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## Control mapping table

| UI control | Mixxx control object |
|---|---|
| Deck A PLAY | `[Channel1],play` |
| Deck A CUE | `[Channel1],cue_default` |
| Deck A SYNC | `[Channel1],sync_enabled` |
| Deck A BPM label | `[Channel1],bpm` |
| Deck A RATE label/slider | `[Channel1],rate` |
| Deck A waveform position | `[Channel1],playposition` |
| Deck A VOL fader | `[Channel1],volume` |
| Deck A GAIN | `[Channel1],pregain` |
| Deck A EQ LOW/MID/HIGH | `[Channel1],filterLow` / `[Channel1],filterMid` / `[Channel1],filterHigh` |
| Deck B PLAY | `[Channel2],play` |
| Deck B CUE | `[Channel2],cue_default` |
| Deck B SYNC | `[Channel2],sync_enabled` |
| Deck B BPM label | `[Channel2],bpm` |
| Deck B RATE label/slider | `[Channel2],rate` |
| Deck B waveform position | `[Channel2],playposition` |
| Deck B VOL fader | `[Channel2],volume` |
| Deck B GAIN | `[Channel2],pregain` |
| Deck B EQ LOW/MID/HIGH | `[Channel2],filterLow` / `[Channel2],filterMid` / `[Channel2],filterHigh` |
| Crossfader | `[Master],crossfader` |
| FX unit ON | `[EffectRack1_EffectUnit1],enabled` |
| FX dry/wet | `[EffectRack1_EffectUnit1],mix` |
| FX macro | `[EffectRack1_EffectUnit1_Effect1],meta` |

## Gesture mapping (high-level)

- Tap on PLAY/CUE/SYNC buttons → trigger/toggle action.
- Vertical pan on fader lane → continuous value updates with throttling.
- Rotary knob drag (circular/vertical fine adjust) → normalized delta to target control.
- Long-press on EQ knob → reset to neutral (`0.5`).
