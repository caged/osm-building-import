-- Update addresses to adhere to OSM's style.
-- This is largely based off of http://git.io/qM401g
drop table if exists addresses_final;

-- Create a new intermediate table from our exiting addresses table so we can
-- alter the columns and values without mutating our "clean" data.
create temporary table addresses_intermediate as
  select * from addresses;

-- We're expanding two character abbreviations to full words so we
-- need some extra characters
alter table addresses_intermediate alter column fdpre type varchar(10);
alter table addresses_intermediate alter column fdsuf type varchar(10);
alter table addresses_intermediate alter column ftype type varchar(10);

-- Expand abbreviations in addresses to full words.
-- Also normalize names from NAME to Name where only the initial
-- letter is capitalized.
--
-- Example:
--    29751 SW TOWN CENTER LOOP W becomes Southwest Town Center Loop West
update addresses_intermediate
  set fdpre =
  case fdpre
    when 'N' then 'North'
    when 'S' then 'South'
    when 'E' then 'East'
    when 'W' then 'West'
    when 'NE' then 'Northeast'
    when 'SE' then 'Southeast'
    when 'NW' then 'Northwest'
    when 'SW' then 'Southwest'
  end,
  fdsuf =
  case fdsuf
    when 'N' then 'North'
    when 'S' then 'South'
    when 'E' then 'East'
    when 'W' then 'West'
    when 'NE' then 'Northeast'
    when 'SE' then 'Southeast'
    when 'NW' then 'Northwest'
    when 'SW' then 'Southwest'
    when 'NB' then 'Northbound'
    when 'SB' then 'Southbound'
  end,
  ftype =
  case ftype
    when 'ALY' then 'Alley'
    when 'AVE' then 'Avenue'
    when 'BLVD' then 'Boulevard'
    when 'CIR' then 'Circle'
    when 'CRST' then 'Crest'
    when 'CT' then 'Court'
    when 'DR' then 'Drive'
    when 'FWY' then 'Freeway'
    when 'GLN' then 'Glen' --?
    when 'HWY' then 'Highway'
    when 'LN' then 'Lane'
    when 'LNDG' then 'Landing'
    when 'LOOP' then 'Loop'
    when 'LP' then 'Loop'
    when 'PATH' then 'Path'
    when 'PKWY' then 'Parkway'
    when 'PL' then 'Place'
    when 'PT' then 'Point'
    when 'RD' then 'Road'
    when 'RDG' then 'Ridge'
    when 'RUN' then 'Run'
    when 'SPUR' then 'Spur'
    when 'SQ' then 'Square'
    when 'ST' then 'Street'
    when 'SW' then 'Southwest'
    when 'TER' then 'Terrace'
    when 'TERR' then 'Terrace'
    when 'TR' then 'Trail'
    when 'TRL' then 'Trail'
    when 'VW' then 'View'
    when 'WALK' then 'Walk'
    when 'WAY' then 'Way'
  end,
  fname = initcap(fname);

-- Update the full address to use the modifications we made above.  We don't
-- include the house number because OSM requires that it's set seperately
update addresses_intermediate
  set fulladd = array_to_string(array[fdpre,fname,ftype,fdsuf], ' ');

-- Create the final address table with all of our mutations complete.
-- We only want a few relevant properties from the intermediate table
create table addresses_final as
  select distinct on (tlid, housenumber, street, postcode)
    tlid,
    house as housenumber,
    fulladd as street,
    zip as postcode,
    initcap(mail_city) as city,
    'OR'::varchar(2) as state,
    'US'::varchar(2) as country,
    geom
  from addresses_intermediate;

-- Create some relevant indexes
create index on addresses_final (tlid);
create index on addresses_final using gist(geom);
