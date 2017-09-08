import xarray as xr
import glob
import numpy as np
import sys

IDIR = "/g/data/r78/ITEM/OUTPUT_GA"
ODIR = "/g/data/v10/ITEM/NC_DATASETS_TIME"
#ODIR = "/g/data/r78/ITEM/junk"
NCDIR = "/g/data/r78/ITEM/ITEM_NC"
NCDIR = "/g/data/r78/ITEM/ITEM_NC_108"
#for i in range(1,2):
#f = open("/g/data/r78/ITEM/script/all_poly")
f = open("/g/data/r78/ITEM/script/poly_extra_108")
#f = open("/g/data/r78/ITEM/script/poly_27")
content = f.readlines()
lines = [line.strip() for line in content]
#m = open("/g/data/r78/ITEM/tidal_model.csv")
m = open("/g/data/r78/ITEM/script/tidal_mod_108.csv")
poly_map = [line.strip() for line in m.readlines()]

prod=""
if len(sys.argv) !=2:
    print ("Needs REL or STD parameter to generate relative or confidence netcdf")
    sys.exit()
else:
   prod=sys.argv[1]

file_pat = NCDIR + '/ITEM_' + prod + '_'

for lnn in lines:
    print (lnn)
    lnlt = ''
    i = lnn.split(',')[0]
    for ln in poly_map:
        if i == ln.split(",")[0]:
            lnlt = ln.split(",")[1]
            print (i + " " + lnlt)
            break
    if prod == "STD":
        ifile = NCDIR + '/ITEM_STD_' + str(i) + '_' + lnlt + '.nc'
        std = xr.open_dataset(ifile)
        std = std.expand_dims('time')
        files = glob.iglob('%s/ITEM_%s_*%s*PER_10.nc' % (IDIR, i, prod))
        files = sorted(files)
        cc = xr.open_dataset(files[0], drop_variables=['dataset','std'])
        nds = xr.open_dataset(files[0], drop_variables=['crs','std'])
        nds = nds['dataset'].data.tostring()
        print (files[0])
        for fl in files[1:]:
            print (fl)
            tmp = xr.open_dataset(fl, drop_variables=['crs','std'])
            tmp = tmp['dataset'].data.tostring()
            nds = nds + tmp
        cc['stddev'] = std['Band1']
        cc.stddev.attrs['long_name']='Average ndwi Standard Deviation'
        cc.stddev.attrs['grid_mapping']='crs'
    elif prod == "REL":
        ifile = NCDIR + '/ITEM_REL_' + str(i) + '_' + lnlt + '.nc'
        rel = xr.open_dataset(ifile)
        rel = rel.expand_dims('time')

        files = glob.iglob('%s/ITEM_%s_*MEDNDWI*.nc' % (IDIR, i))
        #files = glob.iglob('%s/ITEM_%s_*MEDNDWI*PER_10.nc' % (IDIR, i))
        files = sorted(files)
        cc = xr.open_dataset(files[0], drop_variables=['dataset','ndwi'])
        nds = xr.open_dataset(files[0], drop_variables=['crs','ndwi'])
        nds = nds['dataset'].data.tostring()
        print (files[0])
        for fl in files[1:]:
            print (fl)
            tmp = xr.open_dataset(fl, drop_variables=['crs','ndwi'])
            tmp = tmp['dataset'].data.tostring()
            nds = nds + tmp
        cc['relative'] = rel['Band1']
        cc.relative.attrs['long_name']='ITEM relative model'
        cc.relative.attrs['grid_mapping']='crs'
    else :
        print ("No valid product is found")
        sys.exit()

    dr = xr.DataArray(np.asarray(nds))
    ff = dr.to_dataset(name='dataset')
    ff = ff.expand_dims('time')
    cc['dataset'] = ff['dataset']
    

#cc.stddev.attrs['units']=''
    ofile = ODIR + '/ITEM_' + prod + '_' + str(i) + '_' + lnlt + '.nc'
    cc.to_netcdf(ofile)
    print ("created output file " + ofile)
