#
# Be sure to run `pod lib lint ImageTextOCR.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ImageTextKit'
  s.version          = '0.0.1'
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
  s.source       = {
    :http => 'https://github.com/dopemax/ImageTextKit/releases/download/v0.0.1/ImageTextKit.xcframework.zip',
    :type => 'zip'
  }

  s.vendored_frameworks = 'ImageTextKit.xcframework'

  s.swift_versions = ['5.0']

  s.ios.deployment_target = "15.0"

  # s.resource_bundles = {
  #   'ImageTextKit' => ['ImageTextKit/Assets/*.png']
  # }

  s.dependency 'Alamofire'
  
end
