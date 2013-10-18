
Pod::Spec.new do |s|
  s.name         = "ATCalendar"
  s.version      = "0.1.10"
  s.summary      = "Calendar app like implementation with CoreData store"
  s.homepage     = "https://github.com/adriantofan/ATCalendar"
  s.license      = { :type => 'BSD', :file => 'LICENSE' }
  s.author       = { "Adrian Tofan" => "adrian@tofan.co" }
  s.source       = { :git => "https://github.com/adriantofan/ATCalendar.git",:tag => s.version.to_s}
  s.platform     = :ios, "6.0"
  s.source_files = "Classes", "Classes/**/*.{h,m}"



  # A list of resources included with the Pod. These are copied into the
  # target bundle with a build phase script.
  #
  # Also allows the use of the FileList class like `source_files' does.
  #
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  s.frameworks = 'QuartzCore', 'UIKit', 'Foundation', 'CoreGraphics', 'CoreData'
  s.requires_arc = true
  s.dependency 'MTDates' , '~> 0.9.1'
  s.dependency 'MagicalRecord', '~> 2.1'
  s.dependency 'CocoaLumberjack', '~> 1.6.2'
  s.dependency 'Functional.m', '~>1.0'
  s.preserve_paths = 'ATCalendar.xcodeproj', 'Resources'
  def s.post_install(target)
    puts "\nGenerating ATCalendar resources bundle\n".yellow if config.verbose?
    if Version.new(Pod::VERSION) >= Version.new('0.16.999')
      sandbox_root = target.sandbox_dir
      else
      sandbox_root = config.project_pods_root
    end
    Dir.chdir File.join(sandbox_root, 'ATCalendar') do
      command = "xcodebuild -project ATCalendar.xcodeproj -target ATCalendarResources CONFIGURATION_BUILD_DIR=../Resources"
      command << " 2>&1 > /dev/null" unless config.verbose?
      unless system(command)
        raise ::Pod::Informative, "Failed to generate ATCalendar resources bundle"
      end
      
      if Version.new(Pod::VERSION) >= Version.new('0.16.999')
        script_path = target.copy_resources_script_path
        else
        script_path = File.join(config.project_pods_root, target.target_definition.copy_resources_script_name)
        end
      File.open(script_path, 'a') do |file|
        file.puts "install_resource 'Resources/ATCalendar.bundle'"
      end
    end
  end
end
