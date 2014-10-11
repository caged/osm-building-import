drop table if exists addresses_final;

-- Create a new final table from our exiting addresses table so we can
-- alter the columns and values without mutating our "clean" data.
create table addresses_final as
  select * from addresses;

-- We're expanding
alter table addresses_final alter column fdpre type varchar(10);
alter table addresses_final alter column fdsuf type varchar(10);
alter table addresses_final alter column ftype type varchar(10);

update addresses_final
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
  fname = initcap(fname)
