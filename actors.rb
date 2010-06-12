require 'beanstalk-client'

beanstalk = Beanstalk::Pool.new(['localhost:11300'], 'polywin')
loop do
  job = beanstalk.reserve
  puts job.body # prints "hello"
  job.delete
end
