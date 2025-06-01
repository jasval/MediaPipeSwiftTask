# Uncomment the next line to define a global platform for your project
platform :ios, '17.0'

# CocoaPods analytics sends network stats synchronously affecting flutter performance.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'MediaPipeSwiftTask.xcodeproj'

target 'MediaPipeSwiftTask' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # MediaPipe GenAI dependencies
  pod 'MediaPipeTasksGenAI'
  pod 'MediaPipeTasksGenAIC'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      
      # Ensure proper architecture settings
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['VALID_ARCHS'] = 'arm64 arm64e x86_64'
      config.build_settings['ARCHS'] = '$(ARCHS_STANDARD)'
      
      # Fix CoreAudioTypes linking issue
      if target.name.include?('MediaPipeTasksGenAIC')
        config.build_settings['OTHER_LDFLAGS'] ||= []
        config.build_settings['OTHER_LDFLAGS'] << '-weak_framework CoreAudioTypes'
        config.build_settings['OTHER_LDFLAGS'] << '-framework Accelerate'
      end
    end
  end
end
