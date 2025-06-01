import Foundation
import CoreGraphics

#if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
import MediaPipeTasksGenAI
#endif

#if canImport(MediaPipeTasksGenAIC) && !targetEnvironment(simulator)
import MediaPipeTasksGenAIC
#endif

// MARK: - Public API Types

public enum MediaPipeError: Error {
    case notSupported
    case initializationFailed
    case processingFailed(String)
    case invalidInput
    case sessionError
}

// MARK: - LLM Inference Wrapper (Swift API)

public class LlmInferenceWrapper {
    #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
    private var llmInference: LlmInference?
    #endif
    
    public init(modelPath: String) throws {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        do {
            self.llmInference = try LlmInference(modelPath: modelPath)
        } catch {
            print("MediaPipe LlmInference initialization failed: \(error)")
            print("Error details: \(String(describing: error))")
            if let nsError = error as NSError? {
                print("Error domain: \(nsError.domain)")
                print("Error code: \(nsError.code)")
                print("Error userInfo: \(nsError.userInfo)")
            }
            throw MediaPipeError.initializationFailed
        }
        #else
        throw MediaPipeError.notSupported
        #endif
    }
    
    public init(options: LlmInferenceOptions) throws {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        do {
            let llmOptions = LlmInference.Options(modelPath: options.modelPath)
            llmOptions.maxTokens = options.maxTokens
            llmOptions.maxImages = options.maxImages
            llmOptions.maxTopk = options.maxTopk
            llmOptions.waitForWeightUploads = options.waitForWeightUploads
            self.llmInference = try LlmInference(options: llmOptions)
        } catch {
            print("MediaPipe LlmInference initialization with options failed: \(error)")
            print("Error details: \(String(describing: error))")
            if let nsError = error as NSError? {
                print("Error domain: \(nsError.domain)")
                print("Error code: \(nsError.code)")
                print("Error userInfo: \(nsError.userInfo)")
            }
            throw MediaPipeError.initializationFailed
        }
        #else
        throw MediaPipeError.notSupported
        #endif
    }
    
    public func generateResponse(inputText: String) throws -> String {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        guard let llm = llmInference else { throw MediaPipeError.notSupported }
        do {
            return try llm.generateResponse(inputText: inputText)
        } catch {
            throw MediaPipeError.processingFailed(error.localizedDescription)
        }
        #else
        throw MediaPipeError.notSupported
        #endif
    }
    
    @available(iOS 15.0, macOS 12.0, *)
    public func generateResponseAsync(inputText: String) -> AsyncThrowingStream<String, Error> {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        guard let llm = llmInference else {
            return AsyncThrowingStream { continuation in
                continuation.finish(throwing: MediaPipeError.notSupported)
            }
        }
        return llm.generateResponseAsync(inputText: inputText)
        #else
        return AsyncThrowingStream { continuation in
            continuation.finish(throwing: MediaPipeError.notSupported)
        }
        #endif
    }
    
    public func createSession(options: SessionOptions? = nil) throws -> SessionWrapper {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        guard let llm = llmInference else { throw MediaPipeError.notSupported }
        return try SessionWrapper(llmInference: llm, options: options)
        #else
        throw MediaPipeError.notSupported
        #endif
    }
    
    public var isSupported: Bool {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        return llmInference != nil
        #else
        return false
        #endif
    }
}

// MARK: - Session Wrapper

public class SessionWrapper {
    #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
    private var session: LlmInference.Session?
    #endif
    
    #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
    init(llmInference: LlmInference, options: SessionOptions?) throws {
        do {
            if let opts = options {
                let sessionOptions = LlmInference.Session.Options()
                sessionOptions.topk = opts.topk
                sessionOptions.topp = opts.topp
                sessionOptions.temperature = opts.temperature
                sessionOptions.randomSeed = opts.randomSeed
                sessionOptions.enableVisionModality = opts.enableVisionModality
                self.session = try LlmInference.Session(llmInference: llmInference, options: sessionOptions)
            } else {
                self.session = try LlmInference.Session(llmInference: llmInference)
            }
        } catch {
            throw MediaPipeError.sessionError
        }
    }
    
    // Internal initializer for cloned sessions
    private init(clonedSession: LlmInference.Session) {
        self.session = clonedSession
    }
    #else
    init(llmInference: Any, options: SessionOptions?) throws {
        throw MediaPipeError.notSupported
    }
    
    // Internal initializer for cloned sessions
    private init(clonedSession: Any) {
        // Not supported on this platform
    }
    #endif
    
    public func addQueryChunk(inputText: String) throws {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        guard let session = session else { throw MediaPipeError.notSupported }
        do {
            try session.addQueryChunk(inputText: inputText)
        } catch {
            throw MediaPipeError.processingFailed(error.localizedDescription)
        }
        #else
        throw MediaPipeError.notSupported
        #endif
    }
    
    public func addImage(image: CGImage) throws {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        guard let session = session else { throw MediaPipeError.notSupported }
        do {
            try session.addImage(image: image)
        } catch {
            throw MediaPipeError.processingFailed(error.localizedDescription)
        }
        #else
        throw MediaPipeError.notSupported
        #endif
    }
    
    public func generateResponse() throws -> String {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        guard let session = session else { throw MediaPipeError.notSupported }
        do {
            return try session.generateResponse()
        } catch {
            throw MediaPipeError.processingFailed(error.localizedDescription)
        }
        #else
        throw MediaPipeError.notSupported
        #endif
    }
    
    @available(iOS 15.0, macOS 12.0, *)
    public func generateResponseAsync() -> AsyncThrowingStream<String, Error> {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        guard let session = session else {
            return AsyncThrowingStream { continuation in
                continuation.finish(throwing: MediaPipeError.notSupported)
            }
        }
        return session.generateResponseAsync()
        #else
        return AsyncThrowingStream { continuation in
            continuation.finish(throwing: MediaPipeError.notSupported)
        }
        #endif
    }
    
    public func sizeInTokens(text: String) throws -> Int {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        guard let session = session else { throw MediaPipeError.notSupported }
        do {
            return try session.sizeInTokens(text: text)
        } catch {
            throw MediaPipeError.processingFailed(error.localizedDescription)
        }
        #else
        throw MediaPipeError.notSupported
        #endif
    }
    
    public func clone() throws -> SessionWrapper {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        guard let session = session else { throw MediaPipeError.notSupported }
        do {
            let clonedSession = try session.clone()
            return SessionWrapper(clonedSession: clonedSession)
        } catch {
            throw MediaPipeError.processingFailed(error.localizedDescription)
        }
        #else
        throw MediaPipeError.notSupported
        #endif
    }
}

// MARK: - Configuration Types

public struct LlmInferenceOptions {
    public var modelPath: String
    public var visionEncoderPath: String?
    public var visionAdapterPath: String?
    public var maxTokens: Int = 1024
    public var maxImages: Int = 4
    public var maxTopk: Int = 40
    public var temperature: Float = 0.8
    public var waitForWeightUploads: Bool = true
    public var useSubmodel: Bool = false
    public var sequenceBatchSize: Int = 1
    
    public init(modelPath: String) {
        self.modelPath = modelPath
    }
}

public struct SessionOptions {
    public var topk: Int = 40
    public var topp: Float = 0.9
    public var temperature: Float = 0.8
    public var randomSeed: Int = 0
    public var loraPath: String?
    public var enableVisionModality: Bool = false
    
    public init() {}
}

// MARK: - C API Wrapper (MediaPipeTasksGenAIC)

public class LlmEngineWrapper {
    private var engineHandle: OpaquePointer?
    
    public init(settings: EngineSettings) throws {
        #if canImport(MediaPipeTasksGenAIC) && !targetEnvironment(simulator)
        // Implementation would use C API here
        // This is a placeholder for the C API wrapper
        throw MediaPipeError.notSupported
        #else
        throw MediaPipeError.notSupported
        #endif
    }
    
    deinit {
        #if canImport(MediaPipeTasksGenAIC) && !targetEnvironment(simulator)
        // Clean up C API resources
        #endif
    }
}

public struct EngineSettings {
    public var modelPath: String
    public var maxTokens: Int = 1024
    public var maxImages: Int = 4
    
    public init(modelPath: String) {
        self.modelPath = modelPath
    }
}

// MARK: - Factory

public struct MediaPipeFactory {
    public static func createLlmInference(modelPath: String) throws -> LlmInferenceWrapper {
        return try LlmInferenceWrapper(modelPath: modelPath)
    }
    
    public static func createLlmInference(options: LlmInferenceOptions) throws -> LlmInferenceWrapper {
        return try LlmInferenceWrapper(options: options)
    }
    
    public static func createEngine(settings: EngineSettings) throws -> LlmEngineWrapper {
        return try LlmEngineWrapper(settings: settings)
    }
    
    public static var isSupported: Bool {
        #if canImport(MediaPipeTasksGenAI) && !targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
}
