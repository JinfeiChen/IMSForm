#
# Be sure to run `pod lib lint IMSForm.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IMSForm'
  s.version          = '0.1.0'
  s.summary          = 'IMSForm 为开发者准备的APP端表单组件库.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
用于快速根据配置文件构建APP表单页面，减少低价值的硬编码工作，提高开发效率。
                       DESC

  s.homepage         = 'https://github.com/JinfeiChen/IMSForm'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jinfei_chen@icloud.com' => 'jinfei_chen@icloud.com' }
  s.source           = { :git => 'https://github.com/JinfeiChen/IMSForm.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'IMSForm/Classes/**/*'
  
  s.resource_bundles = {
    'IMSForm' => ['IMSForm/Assets/*.*']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Masonry' # 如果需要多个依赖库依次往下写即可
  s.dependency 'YYModel'
  s.dependency 'YYText'
  s.dependency 'YYWebImage'
  s.dependency 'TZImagePickerController'
  s.dependency 'TZImagePreviewController'
  s.dependency 'IQKeyboardManager'
  
end
