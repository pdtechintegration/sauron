# Weather Timbit

# load the timbits module
timbits = require 'timbits'

# create and export the timbit
timbit = module.exports = new timbits.Timbit()

# additional timbit implementation code follows...

timbit.about = 'Displays weather information for the specified city.'

timbit.examples = [
	{href: '/weather/?city=hamilton&prov=on', caption: 'Default View'}
]

timbit.params = {
	city: {description: 'The city to display the weather for.',required: true, strict: false, values: ['Toronto', 'Montreal']}
	prov: {description: 'The province the city is in.', required: true, strict: false, values: ['on', 'qc']}
}

timbit.eat = (req, res, context) ->
	
	src = {
		name: 'weather'
		uri: "http://www.canada.com/scripts/weather.aspx?city=#{context.city}&rg=#{context.prov}&item=forecast"
	}
	
	# use the helper method to @fetch the data
	# @fetch will call @render once we have the data			
	@fetch req, res, context, src
