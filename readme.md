### Portland, Oregon OpenStreetMap Building Import

### Getting started

```
./script/bootstrap
```

### Development Guidelines
* Have fun!
* Never leave the bootstrap process broken or partially functioning.  Anyone who
  wishes to contribute should be able to run one or two commands to get a fully
  functioning version of the source and relevant data.  
* Document *everything*.  Think about the individuals who will read your
  code six months from now.
* Keep raw source data as close to the original source as possible.  Never rename
  properties or change values during the import/download process.  There are two
  exceptions.  You should transform all geometry data to EPSG:4326, and you can
  filter which properties are retained.  However, you should never exclude
  records from raw data during the import/download process.

  For instance, if data contains name, address and type, it's ok to include only
  name and type in the resulting file, but you shouldn't remove records with type=school
  and you shouldn't alter the date to change things like St. to Street. These transformations
  will take place later on.
