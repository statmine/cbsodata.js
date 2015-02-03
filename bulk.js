// Generated by CoffeeScript 1.8.0
(function() {
  var BULK, Promise, get_data, get_meta, http, read_odata;

  http = require("http");

  Promise = require("promise");

  read_odata = require("./utils").read_odata;

  BULK = "http://opendata.cbs.nl/ODataFeed/odata";

  get_meta = function(table, callback) {
    var keys, store, url;
    store = {};
    url = "" + BULK + "/" + table;
    keys = [];
    return read_odata(url).then(function(metadata) {
      var md, parts, _i, _len;
      parts = [];
      for (_i = 0, _len = metadata.length; _i < _len; _i++) {
        md = metadata[_i];
        if (md.name === "UntypedDataSet" || md.name === "TypedDataSet") {
          continue;
        }
        keys.push(md.name);
        parts.push(read_odata(md.url));
      }
      return Promise.all(parts);
    }).then(function(parts) {
      var i, metadata, _i, _ref;
      metadata = {};
      for (i = _i = 0, _ref = parts.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        metadata[keys[i]] = parts[i];
      }
      return metadata;
    }).nodeify(callback);
  };

  get_data = function(table, filter, select, stream) {
    var url;
    url = "" + BULK + "/" + table + "/TypedDataSet";
    return read_odata(url, filter, select);
  };

  module.exports = {
    get_meta: get_meta,
    get_data: get_data
  };


  /* Testing
  get_meta("81251ned", console.log)
  get_data("81251ned",{Perioden: ['2010MM12','2011MM12'], WoonregioS:['NL10  ']}).
  then( (results) -> console.log results[0], results.length)
   */

}).call(this);
