Pod::Spec.new do |spec|
  spec.name             = "CEMovieMaker"
  spec.version          = "1.0"
  spec.summary          = "CEMovieMaker is a quick and dirty way to create a movie from and array of UIImages."
  spec.description      = "Get a list of images, initialize with initWithSettings:, use the h.264 encoding, and make sure the width is divisible by 16."
  spec.homepage         = "https://github.com/cameronehrlich/CEmovieMaker"
  spec.license          = { :type => "MIT", :file => "LICENSE" }
  spec.author           = { "Cameron Ehrlcih" => "cameronehrlich@gmail.com" }
  spec.social_media_url = "https://twitter.com/cameronehrlich"
  spec.platform         = :ios, "7.0"
  spec.source           = { :git => "https://github.com/cameronehrlich/CEMovieMaker.git" }
  spec.source_files     = "CEMovieMaker/CEMovieMaker/CEMovieMaker.{h,m}"
  spec.frameworks       = "AVFoundation", "UIKit", "Foundation"
  spec.requires_arc     = true
end
