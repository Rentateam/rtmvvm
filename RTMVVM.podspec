#
# Be sure to run `pod lib lint RTMVVM.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RTMVVM'
  s.version          = '0.1.8'
  s.summary          = 'Library for RentaTeam internal MVVM implementation.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This library contains generamba template for module generation and contains some boilerplate classes for subscriber implementation.
                       DESC

  s.homepage         = 'https://github.com/Rentateam/rtmvvm'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RentaTeam' => 'info@rentateam.ru' }
  s.source           = { :git => 'https://github.com/Rentateam/rtmvvm.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.3'
  s.swift_version = '4.2'

  s.source_files = 'RTMVVM/Classes/**/*'
  s.dependency 'Dip', '~> 7.0.1'
  s.dependency 'RealmSwift', '~> 3.13.1'
end
