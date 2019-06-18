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
  s.source                = { :git => "https://github.com/MyFiziqApp/reactnative-plugin-myfiziq", :branch => "master" }
  s.source_files          = "*.{h,m}"
  s.requires_arc          = true


  s.dependency "React"
  # s.dependency 'MyFiziqSDK', :git => 'https://external-myfiziq-at-175889021455:Nf1Hwj3e77INg5cqytVri1tvXM0tzUyN63AuUAievL4%3D@git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/myfiziq-sdk-ios', :branch => '19.0.2'
  # s.dependency 'MyFiziqSDKBilling', :git => 'https://external-myfiziq-at-175889021455:Nf1Hwj3e77INg5cqytVri1tvXM0tzUyN63AuUAievL4%3D@git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/myfiziq-sdk-ios-billing', :branch => '19.0.2'
  # s.dependency 'MyFiziqSDKCommon', :git => 'https://external-myfiziq-at-175889021455:Nf1Hwj3e77INg5cqytVri1tvXM0tzUyN63AuUAievL4%3D@git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/myfiziq-sdk-common'
  s.dependency 'MyFiziqSDKCommon'
  s.dependency 'MyFiziqSDKBilling'
  s.dependency 'MyFiziqSDK'
  

end

  