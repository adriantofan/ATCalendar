platform :ios ,'7.0'
pod 'MTDates' , '~> 0.12'
pod 'Functional.m', '~> 1.0'
pod 'MagicalRecord', '~> 2.1'
pod 'CocoaLumberjack', '~> 1.6.2'
pod 'ATCalendar' ,  :path => '.'
target :test do
 pod 'OCHamcrest', '~>1.9'
 link_with 'ATCalendarTests'
end
# see how this can be reenabled

# post_install do |installer|
#   installer.project.targets.each do |target|
#     target.build_configurations.each do |config|
#       s = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
#     if s==nil then s = [ '$(inherited)' ] end
#     s.push('MR_ENABLE_ACTIVE_RECORD_LOGGING=0');
#       config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = s
#     end
#   end
# end