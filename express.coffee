sys: require('sys')
kiwi: require('kiwi')
kiwi.require('express')
bs: require('../nodestalker/lib/beanstalk_client')
client: bs.Client()

get '/', ->
  this.contentType('html')
  client.use('polywin').onSuccess (data) ->
    id: Date.now()
    client.put(JSON.stringify({'id': id, 'message': 'lol'})).onSuccess (data) ->
      client.watch("response_${id}").onSuccess (data) ->
        sys.puts data
  '<h1>Welcome To Express</h1>'

run()
