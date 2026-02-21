# Mixxx iOS 2-deck PoC

This folder contains a proof-of-concept single-screen mixer implementation:

- `MixerScreenView.swift`: SwiftUI 2-deck mixer UI.
- `MixerScreenViewController.swift`: UIKit container hosting SwiftUI.
- `MixxxEngineBridge.h/.mm`: Objective-C++ adapter boundary for C++ engine controls.
- `TouchGestureMapper.swift`: isolated gesture-to-action mapping module.

## Architecture notes

- UI code emits semantic `DeckAction` commands.
- `TouchGestureMapper` translates raw touch coordinates into normalized semantic actions.
- `MixerScreenViewModel` maps `DeckAction` to Mixxx control-object writes.
- `MixxxEngineBridge` is the only place that should know how to talk to C++ ControlObjects.

This keeps gesture/touch code independent from DSP/engine internals.
