guard 'minitest', :cli => "--seed 123456" do
  watch(%r|^spec/(.*)_spec\.rb|)
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})  { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r|^spec/minispec_helper\.rb|)    { "spec" }
  watch(%r{^_plugins/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
end
