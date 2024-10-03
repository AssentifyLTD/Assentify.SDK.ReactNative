require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  s.name         = "react-native-assentify-sdk"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://... react-native-assentify-sdk.git", :tag => "#{s.version}" }

  s.swift_versions = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5']

  s.ios.deployment_target = '14.0'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }


  s.source_files = "ios/**/*.{h,m,mm,swift}"
  s.resources = ["ios/id_card_rotation.mp4"]

  s.dependency "React-Core"
  s.dependency "AssentifySdk", '0.0.14'

end
