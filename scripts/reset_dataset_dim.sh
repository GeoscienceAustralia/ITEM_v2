#for i in $(ls -ltr ITEM_STD*.nc|grep "Sep  2"|awk '{print $NF}'); do ds_name=$(ncdump -h $i|grep string|grep -v time|awk -F"=" '{print $1}'|sed -e 's/^[\t ]*//g' -e 's/\s$//g'); echo $ds_name; echo $i; ncrename -Oh -d "$ds_name",dataset_nchar "$i"; ncap2 -Oh -s 'where(time >= 0) time=1477958399.0' $i $i; done
for i in $(ls ITEM_*.nc); do ncap2 -Oh -s 'time=double(time)' $i $i; echo $i; done

