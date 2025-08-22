# scripts/merge_html_reports.rb
# Merges all HTML files in a directory tree into a single HTML file with collapsible blocks.

require 'find'
require 'pathname'


# Usage: ruby scripts/merge_html_reports.rb <ruby_version>
version = ARGV[0] or abort("Usage: ruby scripts/merge_html_reports.rb <ruby_version>")
input_dir = File.join('reports', version)

output = File.join(input_dir, 'index.html')
require 'fileutils'
FileUtils.mkdir_p(input_dir)

txt_files = Dir[File.join(input_dir, '*.txt')].sort

blocks = txt_files.map do |file|
  name = File.basename(file, '.txt')
  content = File.read(file)
  "<details><summary>#{name}</summary>\n<pre>#{content}</pre>\n</details>"
end

page = <<-HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Ruby Benchmarks for #{version}</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 2em; }
    details { margin-bottom: 1em; }
    summary { font-weight: bold; cursor: pointer; }
    pre { background: #f4f4f4; padding: 1em; border-radius: 5px; }
  </style>
</head>
<body>
  <h1>Ruby Benchmarks for #{version}</h1>
  #{blocks.join("\n\n")}
</body>
</html>
HTML

File.write(output, page)
puts "Merged HTML written to #{output}"
