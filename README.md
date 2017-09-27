# ITEM_v2
ITEM v2

###
The following steps are used to create ITEM version 2 products.
###

    This repository has only scripts and can be used in conjunction with datacube-stats package
    from agdc_statistics repo.
###

1. First run agdc_stats using multipolyregion branch from https://github.com/GeoscienceAustralia/agdc_statistics.
   Use config files(item_10.yaml, item_20.yaml, .. item_90.yaml) to run statistics ndwi and stddev. 
   The source code and config files are under agdc_statistics/datacube_stats and agdc_statistics/configurations
   respectively.
   
2. Once all the statistics netcdf files are generated, create tiff files

   qsub run_create_tiff.pbs

3. Once step 2 completes, now run to create relative, confidence and offset files

   qsub run_ITEM.pbs

4. Now run python program to convert tiff file into netcdf files for indexing in datacube

   a. item_all_netcdf.py REL # Can be passed REL for relative and STD for standard layer
   b. #Make sure all netcdf files are CF and ACDD compliant.

       update_nc_files_item.sh, update_nc_files_std.sh, update_attr.sh and reset_dataset_dim.sh
