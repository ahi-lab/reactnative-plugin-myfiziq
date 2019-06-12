#
# MyFiziqSDK Podspec
# Copyright (c) 2017-2019 MyFiziq. All rights reserved.
#

Pod::Spec.new do |s|
  s.name         = "RNMyFiziqSdk"
  s.version      = "19.0.2"
  s.summary      = "RNMyFiziqSdk"
  s.description  = <<-DESC
    MyFiziq ReactNative plugin
                   DESC
  s.homepage              = "https://myfiziq.com"
  s.license               = { :type => 'Commercial', :file => 'LICENSE.md' }
  s.author                = { 'MyFiziq' => 'dev@myfiziq.com' }
  s.ios.deployment_target = '12.1'
  s.source                = { :git => "https://github.com/MyFiziqApp/reactnative-plugin-myfiziq", :tag => "master" }
  s.source_files          = "RNMyFiziqSdk/**/*.{h,m}"
  s.requires_arc          = true


  s.dependency "React"
  s.dependency "MyFiziqSDK", '~> 19.0.2'

end

  