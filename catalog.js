// Generated by CoffeeScript 1.10.0
(function() {
  var CATALOG, Promise, add_children, get_featured, get_table_featured, get_table_themes, get_tables, get_theme_tree, get_themes, read_odata, utils;

  utils = require("./utils");

  Promise = require("promise");

  CATALOG = "https://opendata.cbs.nl/ODataCatalog";

  read_odata = require("./utils").read_odata;

  get_tables = function(filter, select, callback) {
    var url;
    url = CATALOG + "/Tables";
    return read_odata(url, filter, select).nodeify(callback);
  };

  get_themes = function(filter, select, callback) {
    var url;
    url = CATALOG + "/Themes";
    return read_odata(url, filter, select).nodeify(callback);
  };

  get_featured = function(filter, select, callback) {
    var url;
    url = CATALOG + "/Featured";
    return read_odata(url, filter, select).nodeify(callback);
  };

  get_table_featured = function(filter, select, callback) {
    var url;
    url = CATALOG + "/Table_Featured";
    return read_odata(url, filter, select).nodeify(callback);
  };

  get_table_themes = function(filter, select, callback) {
    var url;
    url = CATALOG + "/Tables_Themes";
    return read_odata(url, filter, select).nodeify(callback);
  };

  add_children = function(themes, tables, table_themes) {
    var i, j, k, l, len, len1, len2, len3, parent, roots, ta, table_idx, th, theme_idx, tt;
    theme_idx = {};
    table_idx = {};
    roots = [];
    for (i = 0, len = themes.length; i < len; i++) {
      th = themes[i];
      th.Children = [];
      theme_idx[th.ID] = th;
    }
    for (j = 0, len1 = tables.length; j < len1; j++) {
      ta = tables[j];
      table_idx[ta.ID] = ta;
    }
    for (k = 0, len2 = table_themes.length; k < len2; k++) {
      tt = table_themes[k];
      th = theme_idx[tt.ThemeID];
      if (th != null) {
        th.Children.push(table_idx[tt.TableID]);
      }
    }
    for (l = 0, len3 = themes.length; l < len3; l++) {
      th = themes[l];
      parent = theme_idx[th.ParentID];
      if (parent) {
        parent.Children.push(th);
      } else {
        roots.push(th);
      }
    }
    return roots;
  };

  get_theme_tree = function(filter, select, callback) {
    var table_themes, tables, themes;
    themes = get_themes(filter, select);
    tables = get_tables(filter, ["ShortTitle", "ID", "Identifier"]);
    table_themes = get_table_themes();
    return Promise.all([themes, tables, table_themes]).then(function(info) {
      themes = info[0], tables = info[1], table_themes = info[2];
      return add_children(themes, tables, table_themes);
    });
  };

  module.exports = {
    get_tables: get_tables,
    get_themes: get_themes,
    get_table_featured: get_table_featured,
    get_featured: get_featured,
    get_table_themes: get_table_themes
  };

}).call(this);
