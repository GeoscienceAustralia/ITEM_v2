### 
This workflow was used to create Digital Elevation Model for ITEM version 2.
It runs within arcpy environment and can not be used to run in NCI.

# DEM AUTOMATION

start python environment in ARCMAP and copy OFFSET and vector files to the workspace directory.

import arcpy, glob
from arcpy.sa import *
arcpy.CheckOutExtension('Spatial')
arcpy.env.workspace=r'C:\\Users\\arcmap-proj\\dem_prod'
ws = arcpy.env.workspace

sr = arcpy.SpatialReference("GDA 1994 Australia Albers")

# create TIN
featureclasses = arcpy.ListFeatureClasses()
for i in featureclasses:
    ot = i.split(".shp")[0]
    feat = "{0} Shape.Z Hard_Line level".format(i)
    print feat 
    arcpy.CreateTin_3d(out_tin=ot, spatial_reference=sr, in_features=feat, constrained_delaunay="DELAUNAY")

# Create tin to raster
TINList = arcpy.ListDatasets("con_*")
for i in TINList:
    outRaster = "R_" + i
# Do the same extent as original raster and it is required to do masking in the next step
    ID = i.split('_')[-1]
    InRaster = arcpy.ListDatasets("ITEM_OFFSET_" + str(ID) +  "_*")
    arcpy.env.extent = arcpy.Describe(InRaster[0]).extent
    arcpy.TinRaster_3d(i, outRaster, "INT", "LINEAR", "CELLSIZE 25", 1)


# export raster to tif file and has a default nodatavalue -1

my_raster = glob.glob(r"C:\\Users\\arcmap-proj\\dem_prod\\R_*")
arcpy.RasterToOtherFormat_conversion(my_raster, ws, "TIFF")



# Apply mask and to have final product in raijin using gdal utilty
# script to do run_contiguity_dem.sh 
