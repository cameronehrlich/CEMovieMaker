Pod::Spec.new do |s|
	  s.name         = 'CEMovieMaker'
	  s.version      = '1.0.0'
	  s.license      = 'MIT'
	  s.summary      = 'CEMovieMaker is a quick and dirty way to create a movie from and array of UIImages.'
	  s.author       = { "Cameron Ehrlich" => "cameronehrlich@gmail.com" }
	  s.homepage     = 'https://github.com/rahuldeojoshi/CEMovieMaker'
	  s.platform     = :ios, '8.0'
	  s.source = {
	    :git => 'https://github.com/cameronehrlich/CEMovieMaker.git',
	    :branch => 'master',
	    :tag => s.version.to_s
	  }
s.source_files = ['CEMovieMaker/CE*.{h,m}']
end
