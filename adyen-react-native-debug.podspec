require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "adyen-react-native-debug"
  s.module_name  = 'adyen_react_native'
  s.version      = '2.0.0'
  s.summary      = '"Wraps Adyen Checkout Drop-In and Components for iOS and Android for convenient use with React Native",'
  s.homepage     = "https://adyen.com"
  s.license      = "MIT"
  s.authors      = "ivan@moego.pet"

  s.platform     = :ios, "12.0"
  s.source       = { :git => "https://github.com/Adyen/adyen-react-native.git", :tag => "#{s.version}" }
  s.source_files = "ios/**/*.{h,m,swift}"


  s.dependency "React-Core"
  s.resource_bundles = { 'adyen-react-native' => [ 'ios/PrivacyInfo.xcprivacy' ] }

  # s.dependency "Adyen"
  
  s.vendored_frameworks = [
    'meogoPart/ios/Adyen/Adyen.xcframework',
    'meogoPart/ios/Adyen/AdyenNetworking.xcframework',
    'meogoPart/ios/Debug/AdyenPOS.xcframework',
  ]
  
  s.resource = [
    "meogoPart/ios/Adyen/Adyen.bundle",
    "meogoPart/ios/Adyen/AdyenActions.bundle",
    "meogoPart/ios/Adyen/AdyenCard.bundle"
  ]

  # s.dependency 'AdyenNetworking', '2.0.0'
  s.dependency 'Adyen3DS2', '2.4.2'

end
