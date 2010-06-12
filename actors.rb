require 'beanstalk-client'
require 'json'

beanstalk = Beanstalk::Pool.new(['localhost:11300'], 'polywin')
loop do
  job = beanstalk.reserve
  data = JSON.parse(job.body)
  job.delete
  Beanstalk::Pool.new(['localhost:11300'], "polywin_response_#{data['id']}").put("RESPONSE from ruby!")
end
