# Mixxx Swift Core (initial port)

This folder starts a real Swift port by moving pure logic into a testable Swift package.

## Current scope

- `SoftTakeover` logic ported from `src/controllers/softtakeover.{h,cpp}`.
- Unit tests covering the key ignore/accept behavior.

## Run tests

```bash
cd swift-port
swift test
```

## Next steps

1. Port additional pure-control logic modules.
2. Add a C/Objective-C++ bridge target to connect Swift UI with existing C++ engine.
3. Gradually move app-level orchestration to Swift while preserving DSP core stability.
