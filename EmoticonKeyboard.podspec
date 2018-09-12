Pod::Spec.new do |s|
  s.name         = "EmoticonKeyboard"
  s.version      = "0.0.1"
  s.summary      = "A clone of emoticonkeyboard, support picking multiple photos、original photo and video"
  s.homepage     = "https://github.com/kerain/EmoticonKeyboard"
  s.license      = "MIT"
  s.author       = { "kerain" => "kerain@foxmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/kerain/EmoticonKeyboard.git", :tag => "#{s.version}" }
  s.requires_arc = true
  s.source_files = 'EmoticonKeyboard/EmoticonKeyboard/**/*.{swift}'
  s.resources    = "EmoticonKeyboard/EmoticonKeyboard/*.{png,xib,nib,bundle}"
end