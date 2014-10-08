.SECONDARY:

# Extract, simplify, and reproject shapefiles from compressed archives.
#
# * Extract shapefiles
shp/%.shp:
	rm -rf $(basename $@)
	mkdir -p $(basename $@)
	tar --exclude="._*" -xzm -C $(basename $@) -f $<

	for file in `find $(basename $@) -name '*.shp'`; do \
		ogr2ogr -simplify 0.2 -dim 2 -t_srs EPSG:4326 $(basename $@).$${file##*.} $$file; \
		chmod 644 $(basename $@).$${file##*.}; \
	done
	rm -rf $(basename $@)

# Download compressed archives from Oregon Metro.
gz/metro/%.zip:
	mkdir -p $(dir $@)
	curl -L --remote-time 'http://library.oregonmetro.gov/rlisdiscovery/$(notdir $@)' -o $@.download
	mv $@.download $@

shp/buildings.shp: gz/metro/buildings.zip
shp/addresses.shp: gz/metro/master_address.zip
shp/precincts.shp: gz/metro/precinct.zip
