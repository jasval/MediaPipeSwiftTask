# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MediaPipeSwiftTask is a Swift wrapper for Google's MediaPipe GenAI tasks that provides type-safe APIs with automatic framework linking and graceful fallbacks for all iOS environments including Simulator and Xcode Previews.

## Development Commands

### Dependencies
```bash
# Install CocoaPods dependencies
pod install

# Clean dependencies
make clean
```

### Build Commands
```bash
# Build the Swift package
swift build

# Test the package (when tests are added)
swift test

# Build for iOS
xcodebuild -workspace MediaPipeSwiftTask.xcworkspace -scheme MediaPipeSwiftTask -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Architecture Overview

### Core Design Pattern
The project uses a **wrapper pattern** with conditional compilation to handle platform compatibility:

- **Conditional imports**: MediaPipe frameworks are only imported on supported platforms
- **Graceful fallbacks**: All methods throw `MediaPipeError.notSupported` on unsupported platforms (simulator/previews)
- **Type-safe API**: Swift-native interfaces that mirror MediaPipe functionality

### Key Components

#### 1. MediaPipeWrapper.swift
The main implementation file containing:
- `LlmInferenceWrapper`: Primary Swift API for MediaPipe LLM inference
- `SessionWrapper`: Stateful conversation sessions with memory
- `MediaPipeFactory`: Factory methods for creating instances
- `LlmEngineWrapper`: C API wrapper (placeholder for MediaPipeTasksGenAIC)

#### 2. Conditional Compilation Strategy
```swift
#if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
// MediaPipe implementation
#else
// Fallback that throws MediaPipeError.notSupported
#endif
```

This pattern ensures:
- Code compiles on all platforms
- Runtime errors are graceful and predictable
- SwiftUI Previews don't crash

#### 3. Platform Support Matrix
- **iOS Device**: Full MediaPipe functionality
- **iOS Simulator**: Graceful fallbacks (MediaPipe frameworks don't support simulator)
- **Xcode Previews**: Graceful fallbacks
- **macOS**: Full functionality

### Dependencies Structure

#### Binary Targets
- `MediaPipeTasksGenAI.xcframework`: Swift API for MediaPipe
- `MediaPipeTasksGenAIC.xcframework`: C API for MediaPipe

These frameworks must be placed in:
```
Pods/MediaPipeTasksGenAI/frameworks/MediaPipeTasksGenAI.xcframework
Pods/MediaPipeTasksGenAIC/frameworks/MediaPipeTasksGenAIC.xcframework
```

#### Package.swift Configuration
- **Platform**: iOS 17.0+ only
- **Dependencies**: Two binary MediaPipe frameworks
- **Target**: Single library target with framework dependencies

### Error Handling Strategy

The project uses a custom `MediaPipeError` enum:
```swift
public enum MediaPipeError: Error {
    case notSupported        // Platform doesn't support MediaPipe
    case initializationFailed // Model loading failed
    case processingFailed(String) // Runtime processing error
    case invalidInput       // Invalid input data
    case sessionError       // Session creation/management error
}
```

### Key API Patterns

#### Factory Pattern
All instances are created through `MediaPipeFactory` to ensure consistent error handling and platform checks.

#### Session Management
- **Stateless**: `generateResponse(inputText:)` for single queries
- **Stateful**: `createSession()` for conversations with memory
- **Cloning**: Sessions can be cloned for branching conversations

#### Async Support
- Streaming responses via `AsyncThrowingStream`
- Modern Swift concurrency with async/await

## Working with MediaPipe Integration

### Adding New MediaPipe Features
1. Add the feature to the `#if canImport(MediaPipeTasksGenAI)` blocks
2. Provide fallback implementation that throws `MediaPipeError.notSupported`
3. Update configuration structs (`LlmInferenceOptions`, `SessionOptions`) if needed
4. Add factory methods to `MediaPipeFactory`

### Testing Platform Support
Always check platform support before using MediaPipe functionality:
```swift
if MediaPipeFactory.isSupported {
    // Use MediaPipe
} else {
    // Provide alternative or placeholder
}
```

### Framework Path Dependencies
The project expects MediaPipe frameworks in specific CocoaPods-managed paths. When updating framework versions:
1. Update the binary target paths in `Package.swift`
2. Ensure frameworks are properly linked in the Xcode project
3. Test on both device and simulator to verify graceful fallbacks

## Development Notes

- The C API wrapper (`LlmEngineWrapper`) is currently a placeholder
- Vision support requires enabling `enableVisionModality` in session options
- Token counting and session cloning are available for conversation management
- All public APIs are designed to be SwiftUI-safe (won't crash in Previews)