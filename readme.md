### Portland, Oregon OpenStreetMap Building Import

![coverage](https://cloud.githubusercontent.com/assets/25/4600812/150fcace-50de-11e4-9703-2f3c0f0926c5.png)

### Getting started

``` bash
# Pulls down portland building footprints, addresses, election precincts and existing
# OSM building data and imports the data into the pdx_osm database
./script/bootstrap -d pdx_osm

# Runs all the required alterations that prepares all addresses and buildings
# for OSM import.  
./script/finalize -d pdx_osm

```

### Development Guidelines
* **Have fun!**  
* **Never leave the bootstrap process broken or partially functioning.**  Anyone who
  wishes to contribute should be able to run one or two commands to get a fully
  functioning version of the source and relevant data.  
* **Document *everything*.**  Think about the individuals who will read your
  code six months from now.
* **Consider raw source data immutable.** All tables
  created in the bootstrap process should be considered immutable so we always have
  a clean data set to work from without having to rebootstrap.  
* **Never rename properties or change values during a bootstrap operation.**  There are two
  exceptions.  You should transform all geometry data to EPSG:4326, and you can
  filter which properties are retained.  However, you should never exclude
  records from raw data during the import/download process.

  For instance, if data contains name, address and type, it's ok to include only
  name and type in the resulting file, but you shouldn't remove records with type=school
  and you shouldn't alter the data to change things like St. to Street. These transformations
  will take place later on.
