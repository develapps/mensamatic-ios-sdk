#
# Be sure to run `pod lib lint MensamaticSMS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MensamaticSMS'
  s.version          = '0.1.0'
  s.summary          = 'This library allows to manage Mensamatic SMS API.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'POD for sending SMS by Mensamatic written in Swift 4.'

  s.homepage         = 'https://github.com/develapps/mensamatic-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Juantri' => 'juantri.jimenez@develapps.com' }
  s.source           = { :git => 'https://github.com/develapps/mensamatic-ios-sdk.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MensamaticSMS/Classes/**/*.swift'
  
  # s.resource_bundles = {
  #   'MensamaticSMS' => ['MensamaticSMS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
