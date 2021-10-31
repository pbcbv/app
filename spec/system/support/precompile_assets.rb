RSpec.configure do |config|
  config.before(:suite) do
    examples = RSpec.world.filtered_examples.values.flatten
    has_no_system_tests = examples.none? { |example| example.metadata[:type] == :system }

    if has_no_system_tests
      $stdout.puts "\n🚀️️  No system test selected. Skip assets compilation.\n"
      next
    end

    $stdout.puts "\n🐢  Running CSS and JS builds.\n"
    original_stdout = $stdout.clone
    start = Time.current
    begin
      # Silence NPM build output
      $stdout.reopen(File.new("/dev/null", "w"))
      system("yarn build")
      system("yarn build:css")
    ensure
      $stdout.reopen(original_stdout)
      $stdout.puts "Finished in #{(Time.current - start).round(2)} seconds"
    end
  end
end
