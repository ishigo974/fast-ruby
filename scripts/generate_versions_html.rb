# scripts/generate_versions_html.rb
# Parses all txt files in reports/ and generates a single HTML view for all versions.

require 'erb'
require 'pathname'

reports_dir = 'reports'
output = 'all_versions_benchmarks.html'

files = Dir[File.join(reports_dir, '*.txt')]

version_results = files.map do |file|
  {
    version: File.basename(file, '.txt'),
    content: File.read(file)
  }
end

template = <<-HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Ruby Benchmarks by Version</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 2em; }
    h2 { margin-top: 2em; }
    pre { background: #f4f4f4; padding: 1em; border-radius: 5px; }
    .collapsible { background: #eee; cursor: pointer; padding: 10px; border: none; text-align: left; outline: none; font-size: 1.1em; margin-top: 1em; }
    .content { display: none; padding: 0 18px; }
  </style>
</head>
<body>
  <h1>Ruby Benchmarks by Version</h1>
  <% version_results.each do |v| %>
    <button type="button" class="collapsible">Ruby <%= v[:version] %></button>
    <div class="content">
      <pre><%= v[:content] %></pre>
    </div>
  <% end %>
  <script>
    document.querySelectorAll('.collapsible').forEach(function(btn) {
      btn.addEventListener('click', function() {
        var content = this.nextElementSibling;
        content.style.display = content.style.display === 'none' ? 'block' : 'none';
      });
    });
  </script>
</body>
</html>
HTML

File.write(output, ERB.new(template).result(binding))
puts "Generated HTML view: #{output}"
