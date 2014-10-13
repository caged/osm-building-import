create or replace function normalize_state_id(state_id varchar(20))
  returns varchar(20) as $$
declare
  id_num varchar;
  out_str varchar;
begin
  -- Trim all whitespace at the edges and collapse all whitespace in the middle
  -- to a single space
  out_str = regexp_replace(trim(state_id), '\s{2,}', ' ', 'g');

  -- Many addresses contain an erroneous? - character before the suffix.  However,
  -- buildings do not contain this dash so we remove it.
  out_str = regexp_replace(out_str, '\s-', ' ', 'g');

  -- Extract the number suffix from the state_id/tlid.  This is usually a number
  -- preceeded by a space
  id_num  = split_part(out_str, ' ', 2);

  -- Numbers with leading zeros are highly inconsistent between addresses and buildings
  -- For this reason we want to ensure all "id numbers" contain 5 characters with
  -- zeros padded to the front of the number.  For instance, 200 becomes 00200 and
  -- 00400 and 92345 remain unchanged.
  id_num  = lpad(id_num, 5, '0');

  -- Now perform the replacement, transforming state_ids such as state_
  -- Examples:
  --  1S1E33BC  200: 1S1E33BC 00200
  --  1S1E33BC  -00200: 1S1E33BC 00200
  out_str = regexp_replace(out_str, '\s[0-9]+', ' ' || id_num, 'g');
  return out_str;
end;
$$
language PLPGSQL;
