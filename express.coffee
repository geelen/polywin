kiwi: require('kiwi')
kiwi.require('express')
bs: require('../nodestalker/lib/beanstalk_client')
client: bs.Client()

get '/', ->
  this.contentType('html')
  client.use('polywin').onSuccess (data) ->
    client.put('ohai ruby process')
  '<h1>Welcome To Express</h1>'

run()
