assert = require 'assert'
request = require 'request'

respondsWith = (status, port) ->
	context = {
		topic: ->
			req = @context.name.split(' ')
			method = req[0].toLowerCase()
			path = req[1]
			uri = "http://localhost:#{port}#{path}"
			console.log uri
			
			request[method] uri, @callback
			return
	}
			
	context["should respond with a #{status}"] = assertStatus(status)
	test = assertStatus(status)
	return context

assertStatus = (code) ->
	return (err, res) ->
		assert.isNull err		
		assert.equal res.statusCode, code

if typeof exports != "undefined"
	module.exports = respondsWith

