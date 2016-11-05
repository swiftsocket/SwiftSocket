Pod::Spec.new do |s|

  s.name         = "SwiftSocket"
  s.version      = "1.1"
  s.summary      = "A cool framework to work with TCP and UDP sockets"

  s.description  = <<-DESC
                    SwiftSocket profieds an easy way to create TCP or UDP clients and servers 💁
                   DESC

  s.homepage     = "https://github.com/danshevluk/SwiftSocket"
  
  s.license      = { :type => "BSD" }

  s.author             = { "Dan Shevlyuk" => "danshevlyuk@icloud.com" }
  s.social_media_url   = "http://twitter.com/danshevluk"

  s.ios.deployment_target = '8.0'
  # s.osx.deployment_target = '10.7'
  s.source   = {
    :git => 'https://github.com/danshevluk/SwiftSocket.git',
    :tag => s.version
  }
  s.source_files  = 'SwiftSocket/**/*'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
