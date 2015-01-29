http = require "http"
Promise = require "promise"

read_odata = require("./utils").read_odata
     
API = "http://opendata.cbs.nl/ODataApi/odata"

get_meta = (table, callback) ->
	store = {}
	url = "#{API}/#{table}"
	keys = []

	read_odata(url).
	then( (metadata) -> 
		parts = []
		for md in metadata
			continue if md.name is "UntypedDataSet" or md.name is "TypedDataSet"
			keys.push md.name
			parts.push read_odata(md.url)
		Promise.all(parts)
	).
	then( (parts) -> 
		metadata = {}
		for i in [0...parts.length]
			metadata[keys[i]] = parts[i]
		metadata
	).nodeify(callback)  # ensures that both promise style and nodejs callback work

### Get data via API, which is restricted to 10 000 rows ###
get_data = (table, filter, select, callback) ->
	url = "#{API}/#{table}/TypedDataSet"
	read_odata(url, filter, select)
	.nodeify(callback) # ensures that both promise style and nodejs callback work

module.exports = 
	get_meta: get_meta
	get_data: get_data


get_meta("70636eng").then(console.log).catch(console.log)
#get_meta("81251ned", console.log)
### Testing
get_meta("81251ned", console.log)
get_data("81251ned", 
	{Perioden: ['2010MM12','2011MM12'], WoonregioS:['NL10  ']})
.then((results) -> console.log results[0], results.length)
###
