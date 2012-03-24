url = require 'url'
out = (require 'styout').instance 'jsonp-filter'

out.verbosity = out.WARN_VERBOSITY

exports.setupJSONP = ->
	handleJSONP = (req, res, next) ->

		checkJSON = ->
			uri = url.parse(req.url)
			re = /json=true/i
			re.test(if uri.query? then uri.query else '')

		isJSON = checkJSON()
		exports.json = ''

		# MODIFY res.writeHead
		writeHead = res.writeHead # store the original function
		res.writeHead = (statusCode, reasonPhrase, headers) -> # wrap write to hook into the exit path through the layers
			res.writeHead = writeHead # put the original back
			out.debug 'res.writeHead'
			if !isJSON # call the original if not json
				res.writeHead statusCode, reasonPhrase, headers

		# MODIFY res.write to concatenate json
		write = res.write
		res.write = (chunk, encoding) ->
			res.write = write
			if isJSON
				out.debug 'res.write json'
				exports.json += chunk.toString()
			else
				out.debug 'res.write normal'
				res.write chunk, encoding

		# MODIFY res.end to use res.json if json exists
		end = res.end
		res.end = (data, encoding) ->
			res.end = end
			if isJSON
				out.debug 'res.end json'
				res.json exports.json
			else if data?
				out.debug 'res.end data'
				res.end data, encoding
			else
				out.debug 'res.end nodata'
				res.end()

		next() # pass through to the next layer