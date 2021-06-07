source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

target 'CN Facts' do
  use_frameworks!

  # Pods for CN Facts
  pod 'RxSwift', '6.2.0'
  pod 'RxCocoa', '6.2.0'
  pod 'RealmSwift', '=10.1.4'
  pod 'PKHUD', '~> 5.0'
  pod 'Toaster', '2.3.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
