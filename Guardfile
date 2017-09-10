guard :rspec, all_after_pass: false, all_on_start: false, cmd: 'rspec' do
  watch(%r{spec/.+_spec\.rb$})
  watch(%r{lib/(.+)\.rb$}) {|m| "spec/#{m[1]}_spec.rb"}
  watch(%r{lib/(.+)/.+\.rb$}) {|m| "spec/#{m[1]}_spec.rb"}
end

guard :rubocop, all_on_start: false, cmd: 'rubocop' do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
