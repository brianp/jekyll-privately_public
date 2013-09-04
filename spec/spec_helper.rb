require 'bundler/setup'
Bundler.require(:test)

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'rr'
require 'jekyll'

require './_plugins/privately_public'

include Jekyll

STDERR.reopen(test(?e, '/dev/null') ? '/dev/null' : 'NUL:')

def clear_dest
  FileUtils.rm_rf(dest_dir)
end

def dest_dir(*subdirs)
  test_dir('public', *subdirs)
end

def source_dir(*subdirs)
  test_dir('source', *subdirs)
end

def test_dir(*subdirs)
  File.join(File.dirname(__FILE__), *subdirs)
end
