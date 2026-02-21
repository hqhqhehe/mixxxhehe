# iPad MVP build profile for Mixxx

This repository already contains iOS packaging and CMake support. This note documents a
practical "first working iPad app" profile that can be used as a baseline for stabilization.

## Scope

This profile targets:

- iPad deployment from the existing C++/Qt codebase
- full-screen orientation support
- background audio mode enabled in the iOS app metadata
- existing iOS-specific Mixxx integrations (`soundmanagerios`, screen saver handling, and optional Apple library import)

It does **not** claim full feature parity with desktop Mixxx.

## Build assumptions

1. You are building on macOS with Xcode + iOS SDK installed.
2. Qt for iOS and dependencies are available through the configured build environment.
3. `VCPKG_TARGET_TRIPLET` is set to an iOS triplet recognized by this repository.

The top-level `CMakeLists.txt` already contains the iOS target branch and iOS bundle settings.

## Configure and build (example)

```bash
cmake -S . -B build-ios \
  -DQT6=ON \
  -DVCPKG_TARGET_TRIPLET=arm64-ios

cmake --build build-ios -j
```

Use your regular signing/provisioning workflow for installation on a physical iPad.

## Runtime sanity checklist

After install, verify at minimum:

1. App launches and reaches the Mixxx UI without crash.
2. Audio output opens via iOS audio stack.
3. App keeps audio session active when moving to background (where iOS policy allows).
4. Rotation works in portrait and landscape on iPad.
5. Microphone permission prompt is shown correctly when input paths are used.

## Why this profile

A complete rewrite to Swift would be a separate long-term program. The fastest path to a
working iPad app is to keep the existing engine and stabilize the iOS target first.
