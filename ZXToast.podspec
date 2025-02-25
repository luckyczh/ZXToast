#
# Be sure to run `pod lib lint ZXToast.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZXToast'
  s.version          = '0.1.9'
  s.summary          = '提供toast'
  s.swift_version    = '5.5.2'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/luckyczh/ZXToast'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luckyczh' => '766479200@qq.com' }
  s.source           = { :git => 'https://github.com/luckyczh/ZXToast.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'ZXToast/Classes/**/*'
  
   s.resource_bundles = {
     'ZXToast' => ['ZXToast/Assets/*.xcassets']
   }
end
