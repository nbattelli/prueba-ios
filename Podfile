source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Artsy/Specs.git'

platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

target 'rappi-ios' do
  pod 'MaterialComponents/Ink'
  pod 'MaterialComponents/Tabs'
  pod 'MaterialComponents/ActivityIndicator'
  pod 'MaterialComponents/BottomNavigation'
  pod 'SDWebImage'
  pod 'ReachabilitySwift'
end

pre_install do |installer|
  installer.analysis_result.specifications.each do |s|
    s.swift_version = '4.2'
  end
end
