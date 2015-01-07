http = require "http"
queue = require "queue-async"

cb = require("./utils").cb
get_filter = require("./utils").get_filter
get_select = require("./utils").get_select
get_part = require("./utils").get_part
     
API = "http://opendata.cbs.nl/ODataApi/odata"

get_meta = (table, callback = cb) ->
	Q = queue()
	store = {}
	url = "#{API}/#{table}"
	http.get url, (res) ->
		res.setEncoding('utf8')
		res.on "data", (metadata) ->
			metadata = (JSON.parse metadata).value
			for md in metadata
				continue if md.name is "UntypedDataSet" or md.name is "TypedDataSet"
				Q.defer(get_part, md, store)
			Q.awaitAll((error, results) -> callback(error, store))
		.on "error", callback

### Get data via API, which is restricted to 10 000 rows ###
get_data = (table, select, filter, callback=cb) ->
	url = "#{API}/#{table}/TypedDataSet?$format=json"
	url += get_filter(filter)
	url += get_select(select)
	console.log "Retrieving data  from '#{url}'"
	http.get url, (res) ->
		res.setEncoding('utf8')
		data = ""
		res.on "data", (chunk) ->
			data += chunk
		res.on "end", () ->
			data = (JSON.parse data).value
			callback(null, data)
		res.on "error", callback

module.exports = 
	get_meta: get_meta
	get_data: get_data

### Testing

get_meta("81251ned")
get_data("81251ned", [] 
	{Perioden: ['2010MM12','2011MM12'], WoonregioS:['NL10  ']},
	 (_, results)-> console.log results[0], results.length)

get_tables({Language:'en'})
get_themes({Language: 'en'})
get_table_featured()

###

#get_meta("81251ned")
