guard :rspec do
  watch('spec/spec_helper.rb') { "spec" }
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/([^/]+)/(.+)\.rb$}) { |m| "spec/#{m[1]}/#{m[2]}.rb" }
end
