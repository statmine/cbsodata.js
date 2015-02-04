utils = require("./utils")
Promise = require("promise")

CATALOG = "http://opendata.cbs.nl/ODataCatalog"

read_odata = require("./utils").read_odata

get_tables = (filter, select, callback) ->
	url = "#{CATALOG}/Tables"
	read_odata(url, filter, select)
	.nodeify(callback)

get_themes = (filter, select, callback) ->
	url = "#{CATALOG}/Themes"
	read_odata(url, filter, select)
	.nodeify(callback)

get_featured = (filter, select, callback) ->
	url = "#{CATALOG}/Featured"
	read_odata(url, filter, select)
	.nodeify(callback)

get_table_featured = (filter, select, callback) ->
	url = "#{CATALOG}/Table_Featured"
	read_odata(url, filter, select)
	.nodeify(callback)

get_table_themes = (filter, select, callback) ->
	url = "#{CATALOG}/Tables_Themes"
	read_odata(url, filter, select)
	.nodeify(callback)
   
add_children = (themes, tables, table_themes) ->
	theme_idx = {}
	table_idx = {}

	roots = []
	for th in themes
		th.Children = []
		theme_idx[th.ID] = th
	for ta in tables
		table_idx[ta.ID] = ta

	for tt in table_themes
		th = theme_idx[tt.ThemeID]
		th?.Children.push table_idx[tt.TableID]

	for th in themes
		parent = theme_idx[th.ParentID]
		if (parent)
			parent.Children.push th
		else 
			roots.push th
	roots

get_theme_tree = (filter, select, callback) ->
	themes = get_themes(filter, select)
	tables = get_tables(filter, ["ShortTitle", "ID", "Identifier"])
	table_themes = get_table_themes()

	Promise.all([themes, tables, table_themes])
	.then( (info) ->
		[themes, tables, table_themes] = info
		add_children(themes, tables, table_themes)
	)
	

module.exports = 
	get_tables: get_tables
	get_themes: get_themes
	get_table_featured: get_table_featured
	get_featured: get_featured
	get_table_themes: get_table_themes


#get_theme_tree({Language: 'en'}).then (x) -> console.log JSON.stringify x
#get_tables({Language: 'nl'},["ShortTitle", "ID", "Identifier"]).then console.log
