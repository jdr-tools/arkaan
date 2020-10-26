require 'gems'
require 'semantic'
require 'gitlab'

Gitlab.endpoint = 'https://gitlab.com/api/v4'
Gitlab.private_token = ENV['GITLAB_API_TOKEN']

def docker_url
  'https://registry.hub.docker.com/v2/repositories/virtuatable/accounts/tags'
end

def last_commit
  commits = Gitlab.commits(
    'virtuatable/services/accounts',
    { page: 1, per_page: 1 }
  )
  commits.first
end

def current_version
  Semantic::Version.new(Gems.info('arkaan')['version'])
end

def next_version
  current_version.increment!(increment)
end

def increment
  %w[major minor].each do |label|
    return label if labels.include? label
  end
  'patch'
end

def labels
  merge_request = Gitlab.merge_requests(ENV['CI_PROJECT_ID']).find do |mr|
    mr['merge_commit_sha'] == last_commit['id']
  end
  merge_request.nil? ? [] : merge_request['labels']
end

if ARGV.first == 'next'
  puts next_version.to_s
else
  puts current_version.to_s
end
