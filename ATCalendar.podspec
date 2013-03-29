
Pod::Spec.new do |s|
  s.name         = "ATCalendar"
  s.version      = "0.0.9"
  s.summary      = "Calendar app implementation with CoreData store"
  s.homepage     = "http://EXAMPLE/ATCalendar"
  s.license      = { :type => 'BSD', :file => 'LICENSE' }
  s.author       = { "Adrian Tofan" => "adrian@tofan.co" }
  # s.source       = { :git => "http://EXAMPLE/ATCalendar.git", :tag => "0.0.1" }
  # s.source       = { :svn => 'http://EXAMPLE/ATCalendar/tags/1.0.0' }
  # s.source       = { :hg  => 'http://EXAMPLE/ATCalendar', :revision => '1.0.0' }
  s.platform     = :ios, '6.0'
  s.source_files = 'src', 'src/**/*.{h,m}'

  # A list of file patterns which select the header files that should be
  # made available to the application. If the pattern is a directory then the
  # path will automatically have '*.h' appended.
  #
  # Also allows the use of the FileList class like `source_files' does.
  #
  # If you do not explicitly set the list of public header files,
  # all headers of source_files will be made public.
  #
  # s.public_header_files = 'Classes/**/*.h'

  # A list of resources included with the Pod. These are copied into the
  # target bundle with a build phase script.
  #
  # Also allows the use of the FileList class like `source_files' does.
  #
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # A list of paths to preserve after installing the Pod.
  # CocoaPods cleans by default any file that is not used.
  # Please don't include documentation, example, and test files.
  # Also allows the use of the FileList class like `source_files' does.
  #
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # Specify a list of frameworks that the application needs to link
  # against for this Pod to work.
  #
  # s.framework  = 'SomeFramework'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'

  # Specify a list of libraries that the application needs to link
  # against for this Pod to work.
  #
  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'

  # If this Pod uses ARC, specify it like so.
  #
  # s.requires_arc = true

  # If you need to specify any other build settings, add them to the
  # xcconfig hash.
  #
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

  # Finally, specify any Pods that this Pod depends on.
  #
  # s.dependency 'JSONKit', '~> 1.4'
end
