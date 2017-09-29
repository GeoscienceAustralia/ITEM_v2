cd /g/data/v10/ITEM/offset_products
IDIR="/g/data/r78/ITEM/OUTPUT_GA_PRODUCT"
ODIR="/g/data/r78/ITEM/NEW_ITEM"
ODEM="/g/data/r78/ITEM/DEM_OUT"
VEC_OUT="/g/data/r78/ITEM/DEM_VEC"

# elevation txt file contains elevation data for each polygon
# create contiguity layer if not exists out of all BINARY and REL rasters for each polygon.
while read line
do
	ID=$(echo $line|awk -F"," '{print $1}')
        para=$(echo $line|awk -F"," '{print $2}')
        # Create a contigous relative layer
	gdal_calc.py -A "$IDIR"/ITEM_BINARY_"$ID"_10.tif -B "$IDIR"/ITEM_BINARY_"$ID"_20.tif -C "$IDIR"/ITEM_BINARY_"$ID"_30.tif -D "$IDIR"/ITEM_BINARY_"$ID"_40.tif -E "$IDIR"/ITEM_BINARY_"$ID"_50.tif -F "$IDIR"/ITEM_BINARY_"$ID"_60.tif -G "$IDIR"/ITEM_BINARY_"$ID"_70.tif -H "$IDIR"/ITEM_BINARY_"$ID"_80.tif -I "$IDIR"/ITEM_BINARY_"$ID"_90.tif -J /g/data/v10/ITEM/rel_products/ITEM_REL_174_153.27_-27.33.tif --calc="((A+B+C+D+E+F+G+H+I))*logical_and(J>=0,logical_not(logical_or(logical_not(A==1,logical_not(B==0,logical_not(C==0,logical_not(D==0,logical_not(E==0,logical_not(F==0,logical_not(G==0,logical_not(H==0,I==0)))))))),logical_or(logical_not(A==1,logical_not(B==1,logical_not(C==1,logical_not(D==0,logical_not(E==0,logical_not(F==0,logical_not(G==0,logical_not(H==0,I==0)))))))),logical_or(logical_not(A==1,logical_not(B==1,logical_not(C==1,logical_not(D==1,logical_not(E==0,logical_not(F==0,logical_not(G==0,logical_not(H==0,I==0)))))))),logical_or(logical_not(A==1,logical_not(B==1,logical_not(C==1,logical_not(D==1,logical_not(E==1,logical_not(F==0,logical_not(G==0,logical_not(H==0,I==0)))))))),logical_or(logical_not(A==1,logical_not(B==1,logical_not(C==1,logical_not(D==1,logical_not(E==1,logical_not(F==1,logical_not(G==0,logical_not(H==0,I==0)))))))),logical_or(logical_not(A==1,logical_not(B==1,logical_not(C==1,logical_not(D==1,logical_not(E==1,logical_not(F==1,logical_not(G==1,logical_not(H==0,I==0)))))))),logical_or(logical_not(A==1,logical_not(B==1,logical_not(C==1,logical_not(D==1,logical_not(E==1,logical_not(F==1,logical_not(G==1,logical_not(H==1,I==1)))))))),logical_or(logical_not(A==1,logical_not(B==1,logical_not(C==1,logical_not(D==1,logical_not(E==1,logical_not(F==1,logical_not(G==1,logical_not(H==1,I==0)))))))),logical_not(A==1,logical_not(B==1,logical_not(C==0,logical_not(D==0,logical_not(E==0,logical_not(F==0,logical_not(G==0,logical_not(H==0,I==0))))))))))))))))))" --type=Int16 --NoDataValue=-6666 --overwrite --outfile="$ODIR"/ITEM_CONTIGOUS_REL_"$ID".tif

	#creating contour
        fl=$(ls ITEM_OFFSET_"$ID"_*.tif)
        #apply contiguity layer mask to the offset file to get a clean offset layer
	gdal_calc.py  --type Int16 -A "$fl" -B "$ODIR"/ITEM_CONTIGOUS_REL_"$ID".tif --calc="A*(B!=0)+(-6666)*(B==0)" --NoDataValue=-999 --overwrite --outfile=tmp_xxx.tif
	gdal_contour -nln con_"$ID" -3d -f "ESRI Shapefile" -a level -fl $para tmp_xxx.tif "$VEC_OUT"
done < elevation.txt
# Next step is to create tin/raster/tiff files in arcpy environment, ArcMap

# create tin/raster/tiff in arcpy (arc_raster_33.tif)
# getting final dem after applying mask to original water bodies to a no data value

arc_file="arc_raster_33.tif" 
while read line
do
	ID=$(echo $line|awk -F"," '{print $1}')
        arc_file=$(ls arc_raster_"$ID".tif)
        gdal_calc.py  --type Int16 -A "$arc_file" -B "$ODIR"/ITEM_CONTIGOUS_REL_"$ID".tif --calc="A*(B!=0)" --NoDataValue=0 --overwrite --outfile="$ODEM"/DEM_"$ID".tif

done < elevation.txt
