lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'button'

Gem::Specification.new do |spec|
  spec.name = 'button'
  spec.version = Button::VERSION
  spec.authors = ['Button']
  spec.email = ['support@usebutton.com']
  spec.summary = 'ruby client for the Button Order API'
  spec.description = 'Button is a contextual acquisition channel and closed-loop attribution and affiliation system for mobile commerce.'
  spec.homepage = 'https://usebutton.com'

  spec.files = Dir.glob('lib/**/*') + ['LICENSE', 'README.md', 'CHANGELOG.md']
  spec.license = 'MIT'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.3'
end
