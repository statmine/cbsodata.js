// Generated by CoffeeScript 1.8.0
(function() {
  var API, get_data, get_meta, http, queue, utils;

  http = require("http");

  queue = require("queue-async");

  utils = require("./utils");

  API = "http://opendata.cbs.nl/ODataApi/odata";

  get_meta = function(table, callback) {
    var Q, store, url;
    if (callback == null) {
      callback = utils.cb;
    }
    Q = queue();
    store = {};
    url = "" + API + "/" + table;
    return http.get(url, function(res) {
      res.setEncoding('utf8');
      return res.on("data", function(metadata) {
        var md, _i, _len;
        metadata = (JSON.parse(metadata)).value;
        for (_i = 0, _len = metadata.length; _i < _len; _i++) {
          md = metadata[_i];
          if (md.name === "UntypedDataSet" || md.name === "TypedDataSet") {
            continue;
          }
          Q.defer(utils.get_part, md, store);
        }
        return Q.awaitAll(function(error, results) {
          return callback(error, store);
        });
      }).on("error", callback);
    });
  };


  /* Get data via API, which is restricted to 10 000 rows */

  get_data = function(table, select, filter, callback) {
    var url;
    if (callback == null) {
      callback = utils.cb;
    }
    url = "" + API + "/" + table + "/TypedDataSet?$format=json";
    url += utils.get_filter(filter);
    url += utils.get_select(select);
    console.log("Retrieving data  from '" + url + "'");
    return http.get(url, function(res) {
      var data;
      res.setEncoding('utf8');
      data = "";
      res.on("data", function(chunk) {
        return data += chunk;
      });
      res.on("end", function() {
        data = (JSON.parse(data)).value;
        return callback(null, data);
      });
      return res.on("error", callback);
    });
  };

  module.exports = {
    get_meta: get_meta,
    get_data: get_data
  };


  /* Testing
  
  get_meta("81251ned")
  get_data("81251ned", [] 
  	{Perioden: ['2010MM12','2011MM12'], WoonregioS:['NL10  ']},
  	 (_, results)-> console.log results[0], results.length)
  
  get_tables({Language:'en'})
  get_themes({Language: 'en'})
  get_table_featured()
   */

}).call(this);
