# MediaPipeSwiftTask

A Swift wrapper for Google's MediaPipe GenAI tasks that provides a clean, type-safe API with automatic framework linking and graceful fallbacks for all iOS environments including Simulator and Xcode Previews.

## Features

✅ **Zero Configuration** - No manual framework linking required  
✅ **Universal Compatibility** - Works on device, simulator, and Xcode Previews  
✅ **Type-Safe API** - Clean Swift interfaces that mirror MediaPipe functionality  
✅ **Graceful Fallbacks** - Handles unsupported environments automatically  
✅ **Session Management** - Stateful conversations with memory  
✅ **Vision Support** - Process text and images together  
✅ **Async/Await** - Modern Swift concurrency support  

## Installation

### Swift Package Manager

Add MediaPipeSwiftTask to your project:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/MediaPipeSwiftTask.git", from: "1.0.0")
]
```

### Setup

1. **Add MediaPipe Frameworks**: Place your MediaPipe frameworks in the `Pods/` directory:
   ```
   Pods/
   ├── MediaPipeTasksGenAI/frameworks/MediaPipeTasksGenAI.xcframework
   └── MediaPipeTasksGenAIC/frameworks/MediaPipeTasksGenAIC.xcframework
   ```

2. **Import the Package**:
   ```swift
   import MediaPipeSwiftTask
   ```

## Quick Start

### Basic Text Generation

```swift
import MediaPipeSwiftTask

// Simple one-shot generation
let llm = try MediaPipeFactory.createLlmInference(modelPath: "path/to/model.tflite")
let response = try llm.generateResponse(inputText: "What is Swift?")
print(response)
```

### Session-Based Conversations

```swift
// Create a session for stateful conversations
let session = try llm.createSession()

// Add query chunks
try session.addQueryChunk(inputText: "Tell me about")
try session.addQueryChunk(inputText: " machine learning")

// Generate response
let response = try session.generateResponse()
print(response)

// Continue the conversation
try session.addQueryChunk(inputText: "How does it relate to AI?")
let followUp = try session.generateResponse()
```

### Vision + Text Processing

```swift
// Enable vision modality
var options = SessionOptions()
options.enableVisionModality = true
let session = try llm.createSession(options: options)

// Add image and text
try session.addImage(image: myImage)
try session.addQueryChunk(inputText: "Describe this image")
let description = try session.generateResponse()
```

### Async Streaming

```swift
// Stream responses as they're generated
for try await chunk in session.generateResponseAsync() {
    print(chunk, terminator: "")
}
```

## Advanced Configuration

### LLM Options

```swift
var options = LlmInferenceOptions(modelPath: "model.tflite")
options.maxTokens = 2048
options.maxImages = 8
options.temperature = 0.7
options.waitForWeightUploads = true

let llm = try MediaPipeFactory.createLlmInference(options: options)
```

### Session Options

```swift
var sessionOptions = SessionOptions()
sessionOptions.temperature = 0.8
sessionOptions.topk = 40
sessionOptions.topp = 0.9
sessionOptions.randomSeed = 42
sessionOptions.enableVisionModality = true

let session = try llm.createSession(options: sessionOptions)
```

## Error Handling

MediaPipeSwiftTask provides comprehensive error handling:

```swift
do {
    let response = try llm.generateResponse(inputText: "Hello")
} catch MediaPipeError.notSupported {
    // Running on unsupported platform (simulator/previews)
    print("MediaPipe not available on this platform")
} catch MediaPipeError.initializationFailed {
    // Model loading failed
    print("Failed to load model")
} catch MediaPipeError.processingFailed(let message) {
    // Processing error
    print("Processing failed: \(message)")
}
```

## Platform Support

| Platform | Text Generation | Vision | Async |
|----------|----------------|--------|-------|
| iOS Device | ✅ | ✅ | ✅ |
| iOS Simulator | ❌* | ❌* | ❌* |
| Xcode Previews | ❌* | ❌* | ❌* |
| macOS | ✅ | ✅ | ✅ |

*Gracefully fails with `MediaPipeError.notSupported`

## Checking Platform Support

```swift
// Check if MediaPipe is supported on current platform
if MediaPipeFactory.isSupported {
    let llm = try MediaPipeFactory.createLlmInference(modelPath: modelPath)
    // Use MediaPipe
} else {
    // Provide alternative or show placeholder
    showPlaceholderContent()
}

// Check specific instance
let llm = try MediaPipeFactory.createLlmInference(modelPath: modelPath)
if llm.isSupported {
    let response = try llm.generateResponse(inputText: "Hello")
}
```

## Utility Methods

```swift
// Count tokens in text
let tokenCount = try session.sizeInTokens(text: "Hello world")

// Clone session for branching conversations
let branchedSession = try session.clone()
```

## SwiftUI Integration

Safe usage in SwiftUI with Previews support:

```swift
struct ContentView: View {
    @State private var response = ""
    
    var body: some View {
        VStack {
            Text(response)
            Button("Generate") {
                Task {
                    if MediaPipeFactory.isSupported {
                        let llm = try MediaPipeFactory.createLlmInference(modelPath: modelPath)
                        response = try llm.generateResponse(inputText: "Hello AI")
                    } else {
                        response = "MediaPipe not available in Previews"
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView() // Works safely - no crashes!
}
```

## API Reference

### MediaPipeFactory

- `createLlmInference(modelPath:)` - Create LLM with model path
- `createLlmInference(options:)` - Create LLM with advanced options
- `isSupported` - Check platform support

### LlmInferenceWrapper

- `generateResponse(inputText:)` - Single-shot text generation
- `generateResponseAsync(inputText:)` - Async single-shot generation
- `createSession(options:)` - Create stateful session
- `isSupported` - Check if instance is supported

### SessionWrapper

- `addQueryChunk(inputText:)` - Add text to conversation
- `addImage(image:)` - Add image to conversation
- `generateResponse()` - Generate response from accumulated input
- `generateResponseAsync()` - Stream response generation
- `sizeInTokens(text:)` - Count tokens in text
- `clone()` - Clone session for branching

## Requirements

- iOS 15.0+ / macOS 12.0+
- Xcode 14.0+
- Swift 5.9+
- MediaPipe GenAI frameworks

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.