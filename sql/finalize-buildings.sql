drop table if exists buildings_intermediate;
drop table if exists buildings_final;

create temporary table buildings_intermediate as
  select max(gid) as gid,
         max(bldg_addr) as addr,
         max(normalize_state_id(state_id)) as state_id,
         max(bldg_use) as bldg_use,
         max(bldg_type) as bldg_type,
         st_union(geom) as geom
  from buildings
  where bldg_addr != ''
  group by bldg_id;

create table buildings_final as
  select a.housenumber,
         a.street,
         a.postcode,
         a.state,
         a.country,
         b.gid,
         b.bldg_type,
         b.bldg_use,
         b.geom
  from buildings_intermediate b
  left outer join (select distinct on (state_id) * from addresses_final) a on a.state_id = b.state_id
  where a.state_id is not null;
