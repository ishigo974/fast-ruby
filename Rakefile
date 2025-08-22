desc "run benchmark in current ruby"
task :run_benchmark do
  require 'fileutils'
  FileUtils.mkdir_p("reports/#{RUBY_VERSION}") if ENV['CI'] == '1'

  benchmarks = Dir["code/*/*.rb"].sort_by { |path| path =~ /^code\/general/ ? 0 : 1 }

  if ENV['CI'] == '1'
    # Always use Ruby threads for parallel execution
    require 'thread'
    total = benchmarks.size
    done = 0
    mutex = Mutex.new
    threads = benchmarks.map do |benchmark|
      Thread.new do
        out_file = "reports/#{RUBY_VERSION}/#{File.basename(benchmark, '.rb')}.txt"
        system("ruby -v -W0 #{benchmark} > #{out_file}")
        mutex.synchronize do
          done += 1
          print "\rProgress: #{done}/#{total} benchmarks completed"
          $stdout.flush
        end
      end
    end
    threads.each(&:join)
    puts "\nAll benchmarks completed."
  else
    benchmarks.each do |benchmark|
      puts "$ ruby -v #{benchmark}"
      system("ruby -v -W0 #{benchmark}")
    end
  end
end

task default: :run_benchmark
