require 'beanstalk-client'
require 'json'
require 'lib/polywin'

Polywin.listen 'polywin' do
  worker 'list' do |data|
    p data
    [1,2,3,4,5]
  end

  consumer 'play' do |data|
    p data
  end
end
