#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'anura_flutter_ios'
  s.version          = '0.0.1'
  s.summary          = 'An iOS implementation of the anura_flutter plugin.'
  s.description      = <<-DESC
  An iOS implementation of the anura_flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }  
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.dependency 'Starscream', '~> 4.0.8'

  s.vendored_frameworks = [
    'Frameworks/AnuraCore.xcframework',
    'Frameworks/FaceMesh.xcframework',
    'Frameworks/libdfx.xcframework'
  ]
  
  s.user_target_xcconfig = {
    'SWIFT_OBJC_BRIDGING_HEADER' => '${PODS_ROOT}/../.symlinks/plugins/anura_flutter_ios/ios/Classes/anura_flutter_ios-Bridging-Header.h'
  }

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
