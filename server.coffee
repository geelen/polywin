sys: require('sys')
http: require('http')
bs: require('../nodestalker/lib/beanstalk_client')
client: bs.Client()

http.createServer((req, res) ->
  res.writeHead(200, {'Content-Type': 'text/plain'})
  sys.p req
  client.use('polywin').onSuccess (data) ->
    client.put('ohai ruby process').onSuccess (data) ->
      sys.puts data
      client.disconnect()
  res.end('Hello World\n');
).listen(8124, "127.0.0.1")

sys.puts('Server running at http://127.0.0.1:8124/')
