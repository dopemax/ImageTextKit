#
# Be sure to run `pod lib lint ImageTextOCR.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ImageTextKit'
  s.version          = '0.0.4'
  s.summary          = 'ImageTextKit'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    ImageTextKit.
  
  
                       DESC

  s.homepage         = 'https://github.com/dopemax/ImageTextKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dopemax' => '1003990034@qq.com' }
#  s.source       = {
#    :http => 'https://github.com/dopemax/ImageTextKit/releases/download/v0.0.4/ImageTextKit.xcframework.zip',
#    :type => 'zip'
#  }
  s.source           = { :git => 'https://github.com/dopemax/ImageTextKit.git', :tag => s.version.to_s }
  s.resource_bundles = {"ImageTextKit" => ["ImageTextKit/PrivacyInfo.xcprivacy"]}
  
  s.swift_versions = ['5.5', '5.6', '5.7', '5.8', '5.9', '5.10']
  
  s.ios.deployment_target = "15.0"

  # s.resource_bundles = {
  #   'ImageTextKit' => ['ImageTextKit/Assets/*.png']
  # }

  s.vendored_frameworks = 'ImageTextKit.xcframework'
  
  s.dependency 'Alamofire', '~> 5.10'
  
  s.user_target_xcconfig = {
    'OTHER_LDFLAGS' => '-framework "Alamofire"',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "${PODS_XCFRAMEWORKS_BUILD_DIR}/Alamofire"'
  }
  
end
