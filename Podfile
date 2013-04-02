platform :ios
pod 'MTDates' , '~> 0.9.1'
pod 'Functional.m', :local => '~/Desktop/Functional.m'
pod 'MagicalRecord', '~> 2.1.0'
pod 'CocoaLumberjack'
target :test do
 pod 'OCHamcrest', '~>1.9'
 link_with 'ATCalendarTests'
end
post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      s = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
    if s==nil then s = [ '$(inherited)' ] end
    s.push('MR_ENABLE_ACTIVE_RECORD_LOGGING=0');
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = s
    end
  end
end