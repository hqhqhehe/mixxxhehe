# iOS MVP build and runtime notes

This document captures the current MVP path for building and running Mixxx on iOS.
The baseline is the existing `APPLE AND IOS` path in `CMakeLists.txt`.

## Required toolchain and CMake flags

Use a vcpkg-based cross build. Required flags/toolchain settings:

- `-DCMAKE_TOOLCHAIN_FILE=<vcpkg-root>/scripts/buildsystems/vcpkg.cmake`
- `-DMIXXX_VCPKG_ROOT=<vcpkg-root>`
- `-DVCPKG_TARGET_TRIPLET=arm64-ios` for real device builds, or
  `-DVCPKG_TARGET_TRIPLET=arm64-ios-simulator` for Simulator builds.

When `VCPKG_TARGET_TRIPLET` matches `*-ios`, Mixxx configures:

- `CMAKE_SYSTEM_NAME=iOS`
- `CMAKE_OSX_DEPLOYMENT_TARGET=14.0` (default minimum iOS version)

Example configure commands:

```bash
# iPad/iPhone Simulator
cmake -S . -B build-ios-sim -G Xcode \
  -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" \
  -DMIXXX_VCPKG_ROOT="$VCPKG_ROOT" \
  -DVCPKG_TARGET_TRIPLET=arm64-ios-simulator

# Physical iPad/iPhone device
cmake -S . -B build-ios-device -G Xcode \
  -DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" \
  -DMIXXX_VCPKG_ROOT="$VCPKG_ROOT" \
  -DVCPKG_TARGET_TRIPLET=arm64-ios
```

## Bundle metadata checklist

Current iOS packaging files now include:

- `Info.plist.in`
  - App name/identifier/version wiring
  - `MinimumOSVersion`
  - `UIDeviceFamily` (iPhone + iPad)
  - Launch storyboard reference
  - Microphone and Apple Music privacy usage strings
  - Interface orientation entries for iPhone and iPad
- `Assets.xcassets`
  - Catalog root metadata
  - App icon set with marketing icon declaration (`ios-marketing` 1024x1024)
  - Launch logo image set
- `LaunchScreen.storyboard`
  - Dark background
  - Centered Mixxx logo with adaptive width constraint for larger iPad layouts

## iOS runtime feature matrix (MVP)

| Area | Status | Source |
|---|---|---|
| Audio output backend (`soundmanagerios`) | ✅ Supported in iOS build | Compiled when `IOS` is enabled. |
| Screensaver control (`screensaverios`) | ✅ Supported in iOS build | Compiled when `IOS` is enabled. |
| iTunes/Apple Music importer | ✅ Supported by default (toggle) | `IOS_ITUNES_LIBRARY` defaults to `ON`; links MediaPlayer weakly and defines `__IOS_ITUNES_LIBRARY__`. |
| Broadcasting (Shoutcast) | ❌ Disabled on iOS | `BROADCAST` option is forced off with `"NOT IOS"`. |
| Battery integration | ❌ Not implemented on iOS | Explicit CMake fatal error if battery feature is enabled on iOS. |

## Known limitations (MVP)

- No battery meter implementation for iOS yet.
- Live broadcasting is disabled on iOS builds.
- iOS support is currently oriented to direct app execution (Xcode target) rather than desktop-style installation packaging.

## Run steps (Simulator and device)

1. Configure with CMake using one of the commands above.
2. Open generated Xcode project in `build-ios-*/mixxx.xcodeproj`.
3. Set a valid Apple Team / signing profile in Xcode:
   - Simulator build: signing usually not required.
   - Device build: signing is required.
4. Choose destination:
   - iPad simulator (for example: iPad Pro 12.9").
   - Connected physical iPad.
5. Build and run target `mixxx` from Xcode.
6. On first launch, grant requested permissions (microphone and media library).

