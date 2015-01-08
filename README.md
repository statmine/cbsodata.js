# CBS OData

Interface to CBS opendata. All data from the StatLine database of Statistics Netherlands can be retrieved.

## Usage

All functions are asynchronous and can be used as a Promise or with a call back.
If no callback parameter is given all api functions return a Promise object, otherwise the nodejs style callback function will be used.

### Catalog: retrieving tables and themes

```js
var catalog = require("cbsodata").catalog;

// retrieve list of tables asynchronously
catalog.get_tables( {Language: 'nl'} // filter on dutch tables
                  , function(error, tables){ nodejs style
                   // do your thing with the list of tables
                  });

// or use as a promise
catalog.get_tables( {Language: 'nl'})
.then(function(tables){
 // do your thing with the list of tables
}).catch(function(error){
  // do your thing with the error.
});


// retrieve list of themes asynchronously,, nodejs style
catalog.get_themes( {Language: 'en'} // filter on english themes
                  , null // select columns (array)
                  , function(error, themes){
                   // do your thing with the list of themes
                  });

```

### Api: Get metadata and data from table

```js
var api = require("cbsodata").api;

// retrieve metadata of table "81251ned" asynchronously
api.get_meta("81251ned").then(metadata){
  // do your thing with the meta data
});

//Note that at most 10 000 records can be retrieve with api
api.get_data( "81251ned", {Perioden: ['2009MM12']} // filter rows on values of 
            , null // select columns (array)
            )
.then(function(data){
// do your thing with the data
});
```

### Bulk: Get metadata and bulk data download
```js
var bulk = require("cbsodata").bulk;

// retrieve metadata of table "81251ned" asynchronously
bulk.get_meta("81251ned", function(error, metadata){
       // do your thing with the meta data
    });

bulk.get_data( "81251ned"
            , null // array with columns to select, null is all columns
            , {Perioden: ['2009MM12']} // filter rows
            , stream // stream to which will be written
            )
```

