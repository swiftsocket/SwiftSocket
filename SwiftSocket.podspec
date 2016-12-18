Pod::Spec.new do |s|

  s.name         = 'SwiftSocket'
  s.version      = '2.0.1'
  s.summary      = 'A cool framework to work with TCP and UDP sockets'

  s.description  = <<-DESC
                    SwiftSocket profieds an easy way to create TCP or UDP clients and servers 💁
                   DESC

  s.homepage     = 'https://github.com/swiftsocket/SwiftSocket'
  
  s.license      = { :type => 'BSD' }

  s.author             = { 'Dan Shevlyuk' => 'danshevlyuk@icloud.com' }
  s.social_media_url   = 'http://twitter.com/danshevluk'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.source   = {
    :git => 'https://github.com/swiftsocket/SwiftSocket.git',
    :tag => s.version
  }
  s.source_files  = 'Sources/**/*.{swift,c}'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
