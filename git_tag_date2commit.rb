require 'csv'

CSV.parse(File.read(ARGV[0])).each do |tag,date|
  if (tag =~ /^v\d{14}$/)
    branch = "master"
  end
  if (tag =~ /v(\d\.\d)/)
    branch = $1
  end

  git_cmd = "git rev-list -1 --before=\"#{date}\" \"remotes/origin/#{branch}\""
  commit_id = `#{git_cmd}`.chop
  curl_cmd= "curl -H \"X-API-Key: #{ENV['ATHENIAN_TOKEN']}\" https://api.athenian.co/v1/events/releases --data '[{\"repository\": \"github.com/akeneo/pim-community-dev\", \"commit\": \"#{commit_id}\", \"published_at\":\"#{date}\"}]'"

  puts curl_cmd
  puts `#{curl_cmd}`
end
