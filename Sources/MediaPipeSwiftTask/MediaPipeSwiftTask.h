//
//  MediaPipeSwiftTask.h
//  MediaPipeSwiftTask
//
//  Umbrella header for MediaPipeSwiftTask framework
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <Metal/Metal.h>
#import <MetalPerformanceShaders/MetalPerformanceShaders.h>

//! Project version number for MediaPipeSwiftTask.
FOUNDATION_EXPORT double MediaPipeSwiftTaskVersionNumber;

//! Project version string for MediaPipeSwiftTask.
FOUNDATION_EXPORT const unsigned char MediaPipeSwiftTaskVersionString[];

// Optional weak linking for CoreAudioTypes
#if __has_include(<CoreAudioTypes/CoreAudioTypes.h>)
#import <CoreAudioTypes/CoreAudioTypes.h>
#endif