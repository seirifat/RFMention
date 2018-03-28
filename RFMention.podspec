
Pod::Spec.new do |s|
  s.name             = 'RFMention'
  s.version          = '0.1.1'
  s.summary          = 'Mention people/user in UITextView'
  s.description      = 'You can Mention people/user in UITextView likes whatsapp'

  s.homepage         = 'https://github.com/seirifat/RFMention'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'seirifat' => 'garu.okigaru@gmail.com' }
  s.source           = { :git => 'https://github.com/seirifat/RFMention.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'RFMention/Classes/**/*'
  s.swift_version = '4'
  
  # s.resource_bundles = {
  #   'RFMention' => ['RFMention/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
