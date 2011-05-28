# This is a Rakefile, it is used by Ruby's "rake" utility.

task default: [:generate_html]

task :generate_html do
  Dir['./*-transformed.txt'].each do |file|
    `./replicate_claims.rb #{file} -f h > html/#{file.split('-').first}-replication-output.html`
  end
end
