"""
Used by ogr2osm python script to translate shapefile properties to OSM tags.
"""

def filterTags(attrs):
    if not attrs: return
    tags = {}

    if 'BLDG_ID' in attrs:    tags['metro:id'] = attrs['BLDG_ID']
    if 'BUILDING' in attrs:    tags['building'] = attrs['BUILDING']
    if 'CITY' in attrs:       tags['addr:city'] = attrs['CITY']
    if 'COUNTRY' in attrs:    tags['addr:country'] = attrs['COUNTRY']
    if 'ELE' in attrs:    tags['ele'] = attrs['ELE']
    if 'HEIGHT' in attrs and float(attrs['HEIGHT']) > 0.0: tags['height'] = str(round(float(attrs['HEIGHT']), 2))
    if 'HOUSENUMBE' in attrs: tags['addr:housenumber'] = attrs['HOUSENUMBE']
    if 'LEVELS' in attrs and float(attrs['LEVELS']) > 0: tags['building:levels'] = attrs['LEVELS']
    if 'POSTCODE' in attrs: tags['addr:postcode'] = attrs['POSTCODE']
    if 'STATE' in attrs: tags['addr:state'] = attrs['STATE']
    if 'STREET' in attrs: tags['addr:street'] = attrs['STREET']

    return tags
