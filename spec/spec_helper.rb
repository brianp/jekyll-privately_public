require 'bundler/setup'
Bundler.require(:test)

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/mock'
require 'jekyll'

require './_plugins/privately_public'
