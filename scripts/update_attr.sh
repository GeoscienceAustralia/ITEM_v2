#while read line
for i in $(ls ITEM_REL*-*.nc);
do
	#i=$(ls ITEM_REL_"$line"_*-*.nc)
	#i=$(ls ITEM_STD_"$line"_*-*.nc)
        st="1986-01-01"
        en="2016-10-31"
        echo $i
	#ncatted -h -a units,time,o,c,"seconds since 1970-01-01 00:00:00" -a standard_name,time,o,c,"time" -a long_name,time,o,c,"Time, unix time-stamp" -a axis,time,o,c,"T" -a calendar,time,o,c,"standard" -a _FillValue,x,d,c,"NaN" -a _FillValue,y,d,c,"NaN" -a _FillValue,time,d,c,"NaN" -a license,global,c,c,"CC BY Attribution 4.0 International License" -a product_version,global,c,c,"2.0.0" -a id,global,c,c,"6e1e826e-90f1-41da-8346-1533c1e08097" -a cdm_data_type,global,c,c,"Grid" -a contact,global,c,c,"clientservices@ga.gov.au" -a publisher_email,global,c,c,"earth.observation@ga.gov.au" -a time_coverage_start,global,c,c,"$st" -a time_coverage_end,global,c,c,"$en" -a title,global,c,c,"Intertidal Extents Model 25m v. 2.0.0" -a publisher_name,global,c,c,"Section Leader, Operations Section, NEMO, Geoscience Australia" -a institution,global,c,c,"Commonwealth of Australia (Geoscience Australia)" -a summary,global,c,c,"The Intertidal Extents Model (ITEM) product is a national dataset of the\n exposed intertidal zone; the land between the observed highest and lowest tide.\nITEM provides the extent and topography of the intertidal zone of Australia''s\ncoastline (excluding off-shore Territories). This information was collated using\nobservations in the Landsat archive since 1986. ITEM can be a valuable complimentary\ndataset to both onshore LiDAR survey data and coarser offshore bathymetry data,\nenabling a more realistic representation of the land and ocean interface.\n\n" $i
        #ncatted -h -a valid_range,relative,o,short,0,9 $i
        #ncatted -h -a _FillValue,x,d,c,"NaN" -a _FillValue,y,d,c,"NaN" -a _FillValue,time,d,c,"NaN" $i
        # for  composite products 
        ncatted -h -a keywords,global,c,c,"TIDAL, COMPOSITE, LANDSAT" -a coverage_content_type,blue,c,c,"physicalMeasurement" -a coverage_content_type,green,c,c,"physicalMeasurement" -a coverage_content_type,red,c,c,"physicalMeasurement" -a coverage_content_type,nir,c,c,"physicalMeasurement" -a coverage_content_type,swir1,c,c,"physicalMeasurement" -a coverage_content_type,swir2,c,c,"physicalMeasurement" -a source,global,c,c,"OTPS TPX08 Atlas" $i
        # for ITEM products relative
        ncatted -h -a keywords,global,c,c,"TIDAL, TOPOGRAPHY, LANDSAT, MEDIAN, EXTENT" -a coverage_content_type,relative,c,c,"modelResult" -a source,global,c,c,"OTPS TPX08 Atlas" -a units,relative,c,c,"0.1" $i
        # for ITEM product stddev
        ncatted -h -a keywords,global,c,c,"TIDAL, UNCERTAINTY, CONFIDENCE" -a coverage_content_type,stddev,c,c,"modelResult" -a source,global,c,c,"OTPS TPX08 Atlas" -a units,stddev,c,c,"1" $i
        # for count layers
        ncatted -h -a keywords,global,c,c,"TIDAL, COMPOSITE, LANDSAT" -a coverage_content_type,count_observations,c,c,"qualityInformation" -a source,global,c,c,"OTPS TPX08 Atlas" $i
done
#done < $1
