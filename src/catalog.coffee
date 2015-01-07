http = require "http"
utils = require("./utils")

CATALOG = "http://opendata.cbs.nl/ODataCatalog"

get_filter = require("./utils").get_filter
cb = require("./utils").cb

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

get_featured = (filter, callback=cb) ->
	url = "#{CATALOG}/Featured?$format=json"
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

get_table_featured = (filter, callback=cb) ->
	url = "#{CATALOG}/Table_Featured?$format=json"
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
	get_tables: get_tables
	get_themes: get_themes
	get_table_featured: get_table_featured
	get_featured: get_featured


