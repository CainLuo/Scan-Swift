#
# Be sure to run `pod lib lint Scan-Swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Scan-Swift'
  s.version          = '1.1.0'
  s.summary          = 'Scan QR With Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Swift encapsulates AVFoundation code scanning and QR code image recognition functions.

  Can generate and recognize QR codes and bar codes
  Support for custom identification areas
  Support ScanView and ScanViewController overloading.
  Support for getting photo albums for image recognition (average results)
                       DESC

  s.homepage         = 'https://github.com/350116542@qq.com/Scan-Swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CainLuo' => '350116542@qq.com' }
  s.source           = { :git => 'https://github.com/CainLuo/Scan-Swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Scan-Swift/Classes/**/*'

  s.swift_versions = ['5.0','5.1','5.2','5.3']
  
  # s.resource_bundles = {
  #   'Scan-Swift' => ['Scan-Swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
