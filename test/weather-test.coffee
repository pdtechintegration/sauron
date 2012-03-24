timbits = require 'timbits'
weather = require '../timbits/weather.coffee'
assert = require 'assert'
path = require 'path'
vows = require 'vows'
request = require 'request'
responds = require '../public/js/responds.coffee'
http = require 'http'

homeFolder = path.join("#{process.cwd()}")
port = 8765
server = timbits.serve( {home: homeFolder, port: port })

checkView = server.settings.views.indexOf('weather/view') != -1;

found = false
term = 'Hamilton'

options = { host: 'www.tourismhamilton.com', port: 80, path: '/' }

req = http.get(options, (res) ->
	console.log "\n______________________________________\n"
	console.log "Response: " + res.statusCode
	console.log "______________________________________\n"
)

checkCity = (term) ->
	context = {
		topic: ->
			req = @context.name.split(' ')
			method = req[0].toLowerCase()
			url = req[1]
			request[method] url, @callback
			return
	}
	
	context["should respond with a #{term}"] = 
		(err, res) ->
			pattern = new RegExp(term, "gi")
			matches = res.body.match(pattern)
			if matches isnt null
				found = true
				assert.equal(found, true)
			else
				assert.notEqual(found, false, "No matches found")

	return context

vows.describe('Weather')
	.addBatch
		'SERVER CHECK':
			topic: server
			'Checking Server...': (server) ->
				assert.equal(checkView, true, "Error: Problem running server.")
		
		'GET /weather/?city=Toronto&prov=on': responds 200, port
		
		'GET http://www.tourismhamilton.com': checkCity term

	.export module
