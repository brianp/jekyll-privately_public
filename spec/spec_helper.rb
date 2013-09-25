require 'bundler/setup'
Bundler.require(:test)

require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/pride'
require 'rr'
require 'jekyll'

Dir['./spec/support/**/*.rb', './_plugins/**/*.rb'].each {|f| require f}

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

def capture_stdout
  $old_stdout = $stdout
  $stdout = StringIO.new
  yield
  $stdout.rewind
  return $stdout.string
ensure
  $stdout = $old_stdout
end

def suppress_output
  $suppressed_stdout = $stdout
  $stdout = StringIO.new
end

def unsuppress_output
  $stdout = $suppressed_stdout
end

def private_post_url
  @private_post_url = '/private/0426e1/privpub-post'
end
