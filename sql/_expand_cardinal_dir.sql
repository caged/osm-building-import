-- Expand cardinal directions (and similar variations) to full word representations.
-- abbreviation - A string abbreviation
--
-- Returns a string
create or replace function expand_cardinal_dir(abbreviation varchar(20))
  returns varchar(20) as $$
begin
  case abbreviation
    when 'N'  then return 'North';
    when 'S'  then return 'South';
    when 'E'  then return 'East';
    when 'W'  then return 'West';
    when 'NE' then return 'Northeast';
    when 'SE' then return 'Southeast';
    when 'NW' then return 'Northwest';
    when 'SW' then return 'Southwest';
    when 'NB' then return 'Northbound';
    when 'SB' then return 'Southbound';
    else return abbreviation;
  end case;
end;
$$
language plpgsql;
