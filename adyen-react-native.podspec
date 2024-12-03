require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "adyen-react-native"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

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
