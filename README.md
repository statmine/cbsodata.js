# CBS OData

Interface to CBS opendata.

## Usage

### Catalog, retrieving tables and themes

```js
var catalog = require("cbsodata").catalog;

// retrieve list of tables asynchronously
catalog.get_tables( {Language: 'nl'} // filter on dutch tables
                  , function(error, tables){
                   // do your thing with the list of tables
                  });

// retrieve list of themes asynchronously
catalog.get_themes( {Language: 'en'} // filter on english themes
                  , function(error, themes){
                   // do your thing with the list of themes
                  });

```

### Api, Get metadata and data from table

```js
var api = require("cbsodata").api;

// retrieve metadata of table " 81251ned" asynchronously
api.get_meta("81251ned", function(error, metadata){
       // do your thing with the meta data
    });

//Note that at most 10 000 records can be retrieve with api
api.get_data( "81251ned"
            , null // array with columns to select, null is all columns
            , {Perioden: ['2009MM12']} // filter rows
            , function(error, data){
                // do your thing with the data
            }
            )
```

### Bulk, Get metadata and bulk data download
```js
var bulk = require("cbsodata").bulk;

// retrieve metadata of table " 81251ned" asynchronously
bulk.get_meta("81251ned", function(error, metadata){
       // do your thing with the meta data
    });

bulk.get_data( "81251ned"
            , null // array with columns to select, null is all columns
            , {Perioden: ['2009MM12']} // filter rows
            , stream // stream to which will be written
            )
```

