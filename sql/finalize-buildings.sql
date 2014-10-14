-- Always start fresh
drop table if exists buildings_final;

-- Create a temporary table for buildings.  We want to group all buildings with the
-- same bldg_id and union their geometries since some buildings contain over 90
-- polygons.  For more details, check out https://github.com/rosecitygis/osm-building-import/issues/1
create temporary table buildings_intermediate as
  select max(gid) as gid,
         max(bldg_addr) as addr,
         max(normalize_state_id(state_id)) as state_id,
         max(bldg_use) as bldg_use,
         max(bldg_type) as bldg_type,
         round(max(max_height) * 0.3048, 2) as height,
         round(max(surf_elev) * 0.3048, 2) as ele,
         st_union(geom) as geom
  from buildings
  where bldg_addr != ''
  group by bldg_id;

-- Join buildings with addresses.  We are only choosing a single address for
-- buildings at the moment which is why you see the distinct addresses query in
-- the join.
create table buildings_final as
  select a.housenumber,
         a.street,
         a.postcode,
         a.state,
         a.country,
         b.gid,
         b.height,
         b.ele,
         b.bldg_type,
         case lower(b.bldg_use)
          when 'commercial general'         then 'commercial'
          when 'commercial grocery'         then 'retail'
          when 'commercial hotel'           then 'hotel'
          when 'commercial office'          then 'office'
          when 'commercial restaurant'      then 'commercial'
          when 'commercial retail'          then 'retail'
          when 'industrial'                 then 'industrial'
          when 'institutional religious'    then 'church'
          when 'multi family residential'   then 'apartments'
          when 'parking'                    then 'garage'
          when 'single family residential'  then 'residential'
          else 'yes'
         end as building,
         b.geom
  from buildings_intermediate b
  left outer join (select distinct on (state_id) * from addresses_final) a on a.state_id = b.state_id
  where a.state_id is not null;

-- Create some relevant indexes
create index on buildings_final using gist(geom);
