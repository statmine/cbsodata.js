request = require "superagent"
parse_url = (require "url").parse
Promise = require "promise"

read_odata = (url, filter, select) ->
	url += "?$format=json"
	url += get_filter filter
	url += get_select select
	promise_cb = (resolve, reject) ->
		req = request
		  .get(url)
		  .withCredentials()
		  .end((error, res) ->
			#console.log error
			if not error and res.ok 
				data = res.body.value #(JSON.parse body).value
				resolve data
			else 
				reject error or res.text)
	new Promise(promise_cb)

###
Create filter
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
	select = [select] if typeof select is 'string'
	"&$select=" + select.join ","

module.exports = 
	read_odata: read_odata

### Testing

get_meta("81251ned")
get_data("81251ned", [] 
	{Perioden: ['2010MM12','2011MM12'], WoonregioS:['NL10  ']},
	 (_, results)-> console.log results[0], results.length)

get_tables({Language:'en'})
get_themes({Language: 'en'})
get_table_featured()

###

