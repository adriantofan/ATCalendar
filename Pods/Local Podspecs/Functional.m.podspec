Pod::Spec.new do |s|
  s.name         = "Functional.m"
  s.version      = "1.0.0"
  s.summary      = "Functional.m is an extension for objective-c, that can be used to do functional programming."
  s.homepage     = "https://github.com/leuchtetgruen/Functional.m"
  s.license      = {
    :type => 'MIT (example)',
    :text => <<-LICENSE
              Copyright 2012 leuchtetgruen. 
              
              All rights reserved.
              
              Redistribution and use in source and binary forms, with or without
              LICENSE
  }
  s.author       =  'Hannes Walz'
  s.source       = { :git => "https://github.com/adriantofan/Functional.m.git" , :tag => "1.0.0"} 
  s.source_files = '**.{h,m}'
  s.requires_arc = true
end
