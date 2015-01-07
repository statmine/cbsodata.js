module.exports = 
	api: require "./api"
	bulk: require "./bulk"
	catalog: require "./catalog"


###
api = require "./api"
catalog = require "./catalog"
api.get_meta "81251ned"
#catalog.get_tables {Language: 'nl'}
###