# scripts/generate_listing_page.rb
# Generates an index.html listing all Ruby version benchmark pages found in the given directory.

require 'pathname'
require 'find'

dir = ARGV[0] || 'all_html_reports'
output = ARGV[1] || 'index.html'

version_pages = []
Find.find(dir) do |path|
  if path =~ /\/index\.html$/
    version = Pathname(path).each_filename.to_a[-2]
    version_pages << [version, File.basename(path)]
  end
end

version_pages.sort_by! { |v, _| v }

links = version_pages.map do |version, file|
  "<li><a href=\"#{version}/index.html\">Ruby #{version}</a></li>"
end

page = <<-HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Ruby Benchmarks Index</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 2em; }
    ul { font-size: 1.2em; }
  </style>
</head>
<body>
  <h1>Ruby Benchmarks Index</h1>
  <ul>
    #{links.join("\n    ")}
  </ul>
</body>
</html>
HTML

File.write(output, page)
puts "Listing page written to #{output}"
