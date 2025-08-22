task :generate_versions_html do
  ruby_script = File.expand_path('scripts/generate_versions_html.rb', Dir.pwd)
  sh "ruby #{ruby_script}"
end
desc "run benchmark in current ruby"
task :run_benchmark do
  require 'fileutils'
  if ENV['CI'] == '1'
    FileUtils.mkdir_p("reports/#{RUBY_VERSION}")
  end

  benchmarks = Dir["code/*/*.rb"].sort_by { |path| path =~ /^code\/general/ ? 0 : 1 }

  if ENV['CI'] == '1'
    # Use GNU parallel if available, else fallback to Ruby threads
    parallel_cmd = "parallel --will-cite --halt soon,fail=1 --jobs $(( $(nproc) )) 'ruby -v -W0 {} > reports/#{RUBY_VERSION}/{/.}.txt' ::: #{benchmarks.join(' ')}"
    if system('which parallel > /dev/null')
      puts "Running benchmarks in parallel with GNU parallel"
      system(parallel_cmd)
    else
      puts "GNU parallel not found, running benchmarks in Ruby threads"
      threads = benchmarks.map do |benchmark|
        Thread.new do
          out_file = "reports/#{RUBY_VERSION}/#{File.basename(benchmark, '.rb')}.txt"
          system("ruby -v -W0 #{benchmark} > #{out_file}")
        end
      end
      threads.each(&:join)
    end
  else
    benchmarks.each do |benchmark|
      puts "$ ruby -v #{benchmark}"
      system("ruby -v -W0 #{benchmark}")
    end
  end
end

task default: :run_benchmark
