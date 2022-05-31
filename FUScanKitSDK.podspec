#
# Be sure to run `pod lib lint FUScanKitSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FUScanKitSDK'
  s.version          = '0.1.0'
  s.summary          = 'FUScanKitSDK是基于华为统一扫码服务（Scan Kit）提供便捷的条形码和二维码扫描、解析、生成能力，帮助您快速构建应用内的扫码功能。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
得益于华为在计算机视觉领域能力的积累，ScanKit可以实现远距离码或小型码的检测和自动放大，同时针对常见复杂扫码场景（如反光、暗光、污损、模糊、柱面）做了针对性识别优化，提升扫码成功率与用户体验。
                       DESC

  s.homepage         = 'https://github.com/huicongfu/FUScanKitSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fuhc' => 'fu_huicong@qq.com' }
  s.source           = { :git => 'https://github.com/huicongfu/FUScanKitSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

#  s.vendored_frameworks = 'FUScanKitSDK/HWScanKitSDK/ScanKitFrameWork.framework'
  s.source_files = 'FUScanKitSDK/Classes/**/*'
  
  s.resource_bundles = {
#     'ScanKitFrameWorkBundle' => ['FUScanKitSDK/HWScanKitSDK/ScanKitFrameWorkBundle.bundle'],
     'FUScanKitSDKBundle' => ['FUScanKitSDK/Assets/**/*']
  }

#  s.public_header_files = 'FUScanKitSDK/HWScanKitSDK/ScanKitFrameWork.framework/Headers/*.h'
#  s.frameworks = 'AVFoundation', 'CoreImage', 'CoreGraphics', 'QuartzCore', 'Accelerate', 'CoreVideo', 'CoreMedia', 'AssetsLibrary'
  s.dependency 'Masonry', '~> 1.1.0'
  s.dependency 'ScanKitFrameWork', '~> 1.1.0.302'
end
