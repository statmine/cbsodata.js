http = require "http"
queue = require "queue-async"
     
API = "http://opendata.cbs.nl/ODataApi/odata"
BULK = "http://opendata.cbs.nl/ODataFeed/odata"
CATALOG = "http://opendata.cbs.nl/ODataCatalog"

id = (id) -> id
# default callback function
cb = (error, results) ->
	if error then console.log error, results
	if results.length 
		console.log "Length: #{results.length}"
		console.log "First item:"
		console.log results[0]

get_part = (options, store, next) ->
	console.log "Getting '#{options.url}'..."
	http.get options.url, (res) ->
		res.setEncoding('utf8')

		metadata = ""
		res.on "data", (chunk) ->
			metadata += chunk
		
		res.on "end", () ->
			metadata = (JSON.parse metadata).value
			store[options.name] = metadata
			next(null, metadata)

get_meta = (table, callback=cb) ->
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

###
Create filter and select query
###
get_column_filter = (column, filter) ->
	return "" if not filter or filter.length is 0
	filter = [filter] if typeof filter is 'string'
	q = ("#{column} eq '#{value}'" for value in filter)
	q = q.join ' or '
	q = "(#{q})" if filter.length > 1
	q

get_filter = (filter) ->
	return "" if not filter or Object.keys(filter).length is 0
	q = "&$filter="
	parts = (get_column_filter(column, values) for column, values of filter)
	q += parts.join " and "
	q

get_select = (select) ->
	return "" if not select or select.length is 0
	"&$select=" + select.join ","

### Get data via API, which is restricted to 10 000 rows ###
get_data = (table, select, filter, callback=cb) ->
	#TODO change this to API?
	url = "#{API}/#{table}/TypedDataSet?$format=json"
	#url = "#{BULK}/#{table}/TypedDataSet?$format=json"
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

### large data download, writes to a (file) stream ###
get_data_bulk = (table, select, filter, stream) ->
	#TODO change this to API?
	url = "#{BULK}/#{table}/TypedDataSet?$format=json"
	url += get_filter(filter)
	url += get_select(select)
	console.log "Retrieving data  from '#{url}'"
	### rewrite to retrieve nextLink etc... ###
	http.get url, (res) ->
		res.setEncoding('utf8')
		data = ""
		res.on "data", (chunk) ->
			data += chunk
		res.on "end", () ->
			data = (JSON.parse data).value
			callback(null, data)
		res.on "error", callback

get_tables = (filter, callback=cb) ->
	url = "#{CATALOG}/Tables?$format=json"
	url += get_filter filter
	http.get url, (res) ->
		res.setEncoding('utf8')
		data = ""
		res.on "data", (chunk) ->
			data += chunk
		res.on "end", () ->
			data = (JSON.parse data).value
			callback(null, data)

get_themes = (filter, callback=cb) ->
	url = "#{CATALOG}/Themes?$format=json"
	url += get_filter filter
	console.log url
	http.get url, (res) ->
		res.setEncoding('utf8')
		data = ""
		res.on "data", (chunk) ->
			data += chunk
		res.on "end", () ->
			data = (JSON.parse data).value
			callback(null, data)

module.exports = 
	get_meta: get_meta
	get_data: get_data
	get_tables: get_tables
	get_themes: get_themes

### Testing
get_meta("81251ned")
get_data("81251ned", [] 
	{Perioden: ['2010MM12','2011MM12'], WoonregioS:['NL10  ']},
	 (_, results)-> console.log results[0], results.length)

get_tables({Language:'en'})
get_themes({Language: 'en'})
###
