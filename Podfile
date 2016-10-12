#platform :ios, '10.0'

use_frameworks!

target 'threadchannelapp' do
  pod 'AFNetworking'
  pod 'Alamofire'
  pod 'SwiftyJSON', '3.0.0'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
  pod 'Toucan'
  pod 'iCarousel'
  pod 'Mixpanel'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
  end
