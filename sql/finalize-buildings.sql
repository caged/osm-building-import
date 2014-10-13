drop table if exists buildings_intermediate;
drop table if exists buildings_final;

create temporary table buildings_intermediate as
  select max(gid) as gid,
         max(bldg_addr) as addr,
         max(regexp_replace(trim(state_id), '\s{2,}', ' ', 'g')) as state_id,
         max(bldg_use) as bldg_use,
         max(bldg_type) as bldg_type,
         st_union(geom) as geom
  from buildings
  where bldg_addr != ''
  group by bldg_id;

-- select count(*) from buildings_intermediate;
-- select count(distinct state_id) from buildings_intermediate;

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
  left outer join addresses_final a on a.state_id = b.state_id
  where a.state_id is not null and ((select count(*) from addresses_final where addresses_final.state_id = b.state_id) = 1);
