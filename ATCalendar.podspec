
Pod::Spec.new do |s|
  s.name         = "ATCalendar"
  s.version      = "0.0.9"
  s.summary      = "Calendar app like implementation with CoreData store"
  s.homepage     = "https://github.com/adriantofan/ATCalendar"
  s.license      = { :type => 'BSD', :file => 'LICENSE' }
  s.author       = { "Adrian Tofan" => "adrian@tofan.co" }
  s.source       = { :git => "https://github.com/adriantofan/ATCalendar.git"}
  s.platform     = :ios, "6.0"
  s.source_files = "Classes", "Classes/**/*.{h,m}"



  # A list of resources included with the Pod. These are copied into the
  # target bundle with a build phase script.
  #
  # Also allows the use of the FileList class like `source_files' does.
  #
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  s.resources = 'ATCalendar.bundle'
  s.frameworks = 'QuartzCore', 'UIKit', 'Foundation', 'CoreGraphics', 'CoreData'
  s.requires_arc = true
  s.dependency 'MTDates' , '~> 0.9.1'
  s.dependency 'MagicalRecord', '~> 2.1.0'
  s.dependency 'CocoaLumberjack', '~> 1.6.2'
  s.dependency 'Functional.m', '~>1.0'
end
