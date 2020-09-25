#
#  Be sure to run `pod spec lint Scan-Swift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name              = "Scan-Swift"
  s.version           = "1.0.0"
  s.summary           = "Scan QR With Swift"
  s.homepage          = "http://EXAMPLE/Scan-Swift"
  s.license           = { :type => "MIT", :file => "LICENSE" }
  s.author            = { "CainLuo" => "350116542@qq.com" }
  s.source            = { :git => "https://github.com/CainLuo/Scan-Swift.git", :tag => s.version }
  s.documentation_url = 'https://github.com/CainLuo/Scan-Swift'

  s.source_files = 'Sources/*.swift'

  s.ios.deployment_target = '10.0'

  s.swift_versions = ['5.0']
end
