#!/bin/bash

#
# Copy files (and associated components) that have anomalously low time windows into a new directory
# and remove the old ones.
#

dir1="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/TXT_Files/"
dir2="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/"
dir3="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/sac_files/All_Records/"
dir4="/Users/temp/Google_Drive/USGS_Work/Saudi_Data/Events/Event_Data/"


# Create list of all current SAC records from Saudi Network

cd $dir3

# Get list of anomalous time windows generated by "PrintRecordTimeWindows.bash"
# and placed in the TXT file folder


while read anom
do

    #search=$(echo $anom | awk -F. '{print $1.$2.$3.$4.$5.$6.$7.$8}')

    #cp $anom ../Anomalous_Time_Window_Records/

    rm $anom
    

done < ../../../TXT_Files/WindowsLT5min_Clean.txt