Pod::Spec.new do |s|
  s.name                  = 'AKForm'
  s.version               = '0.0.6'
  s.summary               = 'A refreshing iOS 7 form framework with the works'
  s.homepage              = 'https://github.com/mrackwitz/MRProgress'
  s.author                = { 'Ahmed Khalaf' => 'ahmed@arkuana.co' }
  s.license               = 'MIT License'
  s.source                = { :git => 'https://github.com/arkuana/AKForm.git', :tag => s.version.to_s }
  s.source_files          = 'src/**/*.{h,m}'
  s.prefix_header_file    = 'src/AKForm.h'
  s.platform              = :ios, '7.0'
  s.requires_arc          = true
  s.ios.frameworks        = %w{UIKit}
  s.dependency 'NSDate+Helper'
  s.dependency 'NSString-Hashes'
  s.dependency 'PhoneNumberFormatter'
end
