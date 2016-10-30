class Stats
  def self.list_languages
    redis = Redis.new(url: ENV['REDIS_URI'])

    say 'The following members exist in your organisation:'
    redis.keys.each do |key|
      say '- ' + key
    end

    say "\nPlease input the name of the member you are curious about."
    member_name = ask("\nMember Name: ")

    stats = JSON.parse(redis.get(member_name))
    repos = stats['repos']
    languages = repos.map { |r| r['language'] }
    languages = Hash[languages.group_by { |x| x }.map { |k, v| [k, v.count] }]
    languages.sort_by { |_language, count| count }.reverse

    say "\n - #{member_name}"
    languages.each do |language, count|
      say "    #{language} - #{count}"
    end
  end
end
