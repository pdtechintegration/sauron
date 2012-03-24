html ->
	head ->
		title -> 'Weather Timbit',
		link rel: 'stylesheet', href: '/css/weather.css'
	body ->
		div id: 'icon', -> 
			img src: 'http://www.canada.com/images/weather/large/hp_w_i' + @weather['current']['icon'] + '.gif'

		div id: 'city', -> 
			a href: '/weather/index.html?city=' + @city + '&rg=' + @prov, -> @weather['@']['name']

		div id: 'temperature', -> 
			"&nbsp;" + @weather['current']['temp'][0]['#'] + "°" + @weather['current']['temp']['0']['@']['units']

		div id: 'details_holder', -> 
			span id: 'details', -> @weather['current']['details']

		div id: 'forecast_link', -> 
			a href: '/weather/index.html?city=' + @city + '&rg=' + @prov, -> 'Detailed Forecast'

