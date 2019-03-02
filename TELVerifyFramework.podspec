

Pod::Spec.new do |s|
  s.name         = "TELVerifyFramework"
  s.version      = "1.0.0"
  s.summary      = "A short description of TELVerify."
  s.description  = "Description"
  s.homepage     = "https://www.sendit.asia/th/"
  s.author       = { "iAmSnow" => "sarawoot_khu@true-e-logistics.com" }
  s.source       = { :git => "https://github.com/iAmSnow/TELVerifyFramework/1.0.0/TELVerifyFramework.zip" }
  s.license      = "MIT"
  s.platform     = :ios, "10.0"
  s.dependency "Moya"
  s.ios.vendored_frameworks = 'TELVerifyFramework.framework'

end