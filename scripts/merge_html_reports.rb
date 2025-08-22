# scripts/merge_html_reports.rb
# Merges all HTML files in a directory tree into a single HTML file with collapsible blocks.

require 'find'
require 'pathname'

input_dir = ARGV[0] || 'all_html_reports'
output = ARGV[1] || 'merged_benchmarks.html'

html_files = []
Find.find(input_dir) do |path|
  html_files << path if path =~ /\.html$/
end

blocks = html_files.sort.map do |file|
  name = Pathname(file).each_filename.to_a[-2..-1].join(' / ')
  content = File.read(file)
  "<details><summary>#{name}</summary>\n#{content}\n</details>"
end

page = <<-HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>All Ruby Benchmarks</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 2em; }
    details { margin-bottom: 1em; }
    summary { font-weight: bold; cursor: pointer; }
    pre { background: #f4f4f4; padding: 1em; border-radius: 5px; }
  </style>
</head>
<body>
  <h1>All Ruby Benchmarks</h1>
  #{blocks.join("\n\n")}
</body>
</html>
HTML

File.write(output, page)
puts "Merged HTML written to #{output}"
