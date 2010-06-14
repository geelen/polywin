sys: require('sys')
kiwi: require('kiwi')
kiwi.require('express')
bs: require('../nodestalker/lib/beanstalk_client')
client: bs.Client()

get '/', ->
  this.contentType('html')
  self: this
  client.use('polywin').onSuccess (data) ->
    id: Date.now()
    client.put(JSON.stringify({'id': id, 'message': 'list'})).onSuccess (data) ->
      sys.puts "Listening on tube polywin_response_${id}"
      client.watch("polywin_response_${id}").onSuccess (data) ->
        client.reserve().onSuccess (response) ->
          sys.puts response.data
          self.respond(200, "<h1>${response.data}</h1>")

run()
