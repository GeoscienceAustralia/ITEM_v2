### 
This workflow was used to create Digital Elevation Model for ITEM version 1.
It runs within arcpy environment and not used to run in NCI.

DEM AUTOMATION

# start python environment in ARCMAP and copy OFFSET and vector files to the workspace directory.

import arcpy, glob
from arcpy.sa import *
arcpy.CheckOutExtension('Spatial')
arcpy.env.workspace=r'C:\\Users\\arcmap-proj\\dem_prod'
ws = arcpy.env.workspace

sr = "C:\Program Files (x86)\ArcGIS\Desktop10.4\Reference Systems\International Map Of The World.prj"


#create TIN
featureclasses = arcpy.ListFeatureClasses()
for i in featureclasses:
    ot=i.split(".shp")[0]
    feat="{0} Shape.Z Hard_Line level".format(i)
    print feat 
    arcpy.CreateTin_3d(out_tin=ot, spatial_reference=sr, in_features=feat, constrained_delaunay="DELAUNAY")

#Create tin to raster
Copy those tin rasters directory into some other directories like (C:\Users\u81051\qld_prod) and then set the new workspace.
arcpy.env.workspace = "C:\Users\qld_prod"    
TINList = arcpy.ListDatasets()
Copy those tin rasters into some other directories like (C:\Users\u81051\qld_prod)
for i in TINList:
    outRaster = i+"O"
    arcpy.TinRaster_3d(i, outRaster, "Float", "LINEAR", "CELLSIZE 0.00025", 1)


#export raster to tif file

my_raster = glob.glob(r"C:\\Users\\arcmap-proj\\dem_prod\\con*O")
arcpy.RasterToOtherFormat_conversion(my_raster, ws, "TIFF")



# Apply mask and to have final product
# This is to do for multiple products

offset = arcpy.ListRasters('ARG25_OFFSET*')
tif_list = arcpy.ListRasters(.*O.tif.)
for i in tif_list:
    cell=(i.split("o.tif")[0]).split("con_")[1]
    print cell 
    for of in offset:
        if cell in of:
            lon = int(cell.split("_")[0])
            lat = int(cell.split("_")[1])
            arcpy.env.extent = "lon lat lon+1 lat+1"
            ras0 = arcpy.Raster(of)
            ras1 = arcpy.Raster(i)
            elevation = arcpy.sa.Con(ras0==-6666,-6666, ras1)
            fl_name = "prod_dem_" + cell + ".tif"
            elevation.save(fl_name)

#This is to do for single product

arcpy.env.extent = "130 -13 131 -12"
raster0 = arcpy.Raster("ARG25_OFFSET_130_-013_1987_01_01_2015_12_31_MEDIAN.tif")
raster1 = arcpy.Raster("con_130_-013.tif")
elevation = arcpy.sa.Con(raster0==-6666,-6666, raster1)
elevation.save('prod_dem_130_-013.tif')


