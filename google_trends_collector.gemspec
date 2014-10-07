require File.expand_path('../lib/google_trends_collector/version', __FILE__)
require 'date'

Gem::Specification.new do |gem|
  gem.name = 'google_trends_collector'
  gem.version = GoogleTrendsCollector::VERSION
  gem.date = Date.today.to_s
  gem.license = 'private'
  gem.summary = %Q{Google Trends Collector}
  gem.description = %Q{Allows to collect Google Trends data and not get blocked.}
  gem.authors = ['Max Makarochkin']
  gem.email = 'maxim.makarochkin@gmail.com'
  gem.homepage = 'https://github.com/attractor-labs/google_trends_collector'
  gem.require_path = 'lib'
  gem.files = Dir.glob("{lib,spec}/**/*")
  gem.required_ruby_version = '>= 1.9.3'
  gem.add_dependency 'bundler'
  gem.add_dependency 'rake'
  gem.add_dependency 'watir-webdriver'
  gem.add_dependency 'headless'
end