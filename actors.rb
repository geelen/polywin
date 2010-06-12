require 'beanstalk-client'
require 'json'

beanstalk = Beanstalk::Pool.new(['localhost:11300'], 'polywin')
loop do
  job = beanstalk.reserve
  puts JSON.parse(job.body)
  job.delete
end
