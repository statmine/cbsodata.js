http = require "http"

id = (id) -> id
# default callback function
cb = (error, results) ->
	if error then console.log error, results
	if typeof results is 'object' then console.log results
	if results.length > 1
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

module.exports = 
	get_filter: get_filter
	get_select: get_select
	get_part: get_part
	cb: cb

### Testing

get_meta("81251ned")
get_data("81251ned", [] 
	{Perioden: ['2010MM12','2011MM12'], WoonregioS:['NL10  ']},
	 (_, results)-> console.log results[0], results.length)

get_tables({Language:'en'})
get_themes({Language: 'en'})
get_table_featured()

###

