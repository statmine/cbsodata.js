// Generated by CoffeeScript 1.10.0
(function() {
  var Promise, get_column_filter, get_filter, get_select, parse_url, read_odata, request;

  request = require("superagent");

  parse_url = (require("url")).parse;

  Promise = require("promise");

  read_odata = function(url, filter, select) {
    var promise_cb;
    url += "?$format=json";
    url += get_filter(filter);
    url += get_select(select);
    promise_cb = function(resolve, reject) {
      var req;
      return req = request.get(url).withCredentials(true).end(function(error, res) {
        var data;
        if (!error && res.ok) {
          data = res.body.value;
          return resolve(data);
        } else {
          return reject(error || res.text);
        }
      });
    };
    return new Promise(promise_cb);
  };


  /*
  Create filter
   */

  get_column_filter = function(column, filter) {
    var q, value;
    if (!filter || filter.length === 0) {
      return "";
    }
    if (typeof filter === 'string') {
      filter = [filter];
    }
    q = (function() {
      var i, len, results;
      results = [];
      for (i = 0, len = filter.length; i < len; i++) {
        value = filter[i];
        results.push(column + " eq '" + value + "'");
      }
      return results;
    })();
    q = q.join(' or ');
    if (filter.length > 1) {
      q = "(" + q + ")";
    }
    return q;
  };

  get_filter = function(filter) {
    var column, parts, q, values;
    if (!filter || Object.keys(filter).length === 0) {
      return "";
    }
    q = "&$filter=";
    parts = (function() {
      var results;
      results = [];
      for (column in filter) {
        values = filter[column];
        results.push(get_column_filter(column, values));
      }
      return results;
    })();
    q += parts.join(" and ");
    return q;
  };

  get_select = function(select) {
    if (!select || select.length === 0) {
      return "";
    }
    if (typeof select === 'string') {
      select = [select];
    }
    return "&$select=" + select.join(",");
  };

  module.exports = {
    read_odata: read_odata
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
