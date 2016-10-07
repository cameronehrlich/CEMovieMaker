Pod::Spec.new do |s|
	  s.name         = 'CEMovieMaker'
	  s.version      = '1.0.0'
	  s.license      = 'MIT'
	  s.summary      = 'An image/photo picker for Facebook albums & photos modelled after UIImagePickerController'
	  s.author       = { "Cameron Ehrlich" => "cameronehrlich@gmail.com" }
	  s.homepage     = 'https://github.com/rahuldeojoshi/CEMovieMaker'
	  s.platform     = :ios, '8.0'
	  s.source = {
	    :git => 'https://github.com/rahuldeojoshi/CEMovieMaker.git',
	    :branch => 'master',
	    :tag => s.version.to_s
	  }
s.source_files = ['CEMovieMaker/CE*.{h,m}']
end
