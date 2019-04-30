#!/bin/bash

#
#Script to run through NEZ file and remove any events that lack all 3 components
#

dir1="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/"
dir2="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/All_Stations/"
dir3="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/DSMN/"
dir4="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/EDZN/"
dir5="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/GALN/"
dir6="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/ILKN/"
dir7="/Users/temp/Google_Drive/USGS_Work/Canadian_Data/sac_files/Reformatted/ROMN/"


# Create list of all current SAC records from POLARIS Network

cd $dir2

rm saclst.txt

# Trim to first two channel code indicators, leaving "E" "N" "Z" out
# NOTE: This is formatted for the Saudi data
###ls | awk -F. '{print $1"."$2"."$3"."$4"."$5"."$6"."$7"."$8"."$9"."$10}' | awk '{print substr($1, 1, length($1)-1)}' > saclst.txt  #Argument list too long error with pattern recognition

ls  | awk -F. '{print $1"."$2}' > saclst.txt

#Ensure newline at end of file
sed -i '' -e '$a\' saclst.txt


count=1
recct=0

tmp1=""
tmp2=""
tmp3=""

while read sacnm
do
	echo ""
	echo "New Loop"
	echo ""

	if [ $count -eq 1 ]; then
		
		tmp1=$sacnm
		echo "-----------------------------------------------------------------"
		echo "Tmp1: $tmp1"
		echo "-----------------------------------------------------------------"
	
		recct=1

	fi

	if [ $count -eq 2 ]; then
		
		tmp2=$sacnm
	
		echo "-----------------------------------------------------------------"
		echo "Tmp2: $tmp2"
		echo "-----------------------------------------------------------------"

		if [ $tmp2 != $tmp1 ]; then
			
			echo ""
			echo -e "\033[1;31m ----------------------------------------------------------------- \033[0m"
			echo -e "\033[1;31m This event tmp2 ($tmp2) does not match the previous event tmp1 ($tmp1) \033[0m"
			echo -e "\033[1;31m Event Count: $recct \033[0m"
			echo -e "\033[1;31m Count: $count \033[0m"
			echo ""	

			echo ""
			echo -e "\033[1;31m Incomplete: $tmp1 ... Now removing incomplete event \033[0m"
			rm $tmp1*
			#mv $tmp1* ../GALN_anomalously_small

			echo -e "\033[1;31m ----------------------------------------------------------------- \033[0m"

			echo ""
			tmp1=$tmp2
			count=1;
			recct=1;
			echo "-----------------------------------------------------------------"
			echo "Tmp1 set to: $tmp1"
			echo "Event Count: $recct"
			echo "Count: $count"
			echo "-----------------------------------------------------------------"
			echo ""
			tmp2=""

		elif [ $tmp2 == $tmp1 ]; then
			recct=$((recct+1))
			echo ""
			echo "Evct incremented: $recct"
			echo "Tmp1: $tmp1, Tmp2: $tmp2, Tmp3: $tmp3"
			echo ""		
		fi

	fi
				
	if [ $count -eq 3 ]; then
		
		tmp3=$sacnm
		echo "-----------------------------------------------------------------"
		echo "Tmp3: $tmp3"
		echo "-----------------------------------------------------------------"

		if [ $tmp3 != $tmp2 ]; then
			
			echo ""
			echo -e "\033[1;31m ----------------------------------------------------------------- \033[0m"
			echo -e "\033[1;31m This event tmp2 ($tmp3) does not match the previous event tmp1 ($tmp2) \033[0m"
			echo -e "\033[1;31m Event Count: $recct \033[0m"
			echo -e "\033[1;31m Count: $count \033[0m"
			echo ""	
	
			echo ""
			echo -e "\033[1;31m Incomplete: $tmp2 ... Now removing incomplete event \033[0m"
			rm $tmp2*
			#mv $tmp2* ../GALN_anomalously_small
			echo -e "\033[1;31m ----------------------------------------------------------------- \033[0m"

			echo ""
			tmp1=$tmp3
			count=1;
			recct=1;
			echo "-----------------------------------------------------------------"
			echo "Tmp1 set to: $tmp1"
			echo "Event Count: $recct"
			echo "Count: $count"
			echo "-----------------------------------------------------------------"
			echo ""
			tmp2=""

		elif [ $tmp3 == $tmp2 ]; then
			recct=$((recct + 1)) 
			echo ""
			echo "-----------------------------------------------------------------"
			echo "Tmp1: $tmp1, Tmp2: $tmp2, Tmp3: $tmp3"
			echo "-----------------------------------------------------------------"
			echo ""	
		fi

		if [ $count != $recct ]; then

			echo "-----------------------------------------------------------------"
			echo "Count is not equal to event count"
			echo "Count: $count"
			echo "Event Count: $recct"
			echo "-----------------------------------------------------------------"
			echo ""
				
		elif [ $count -eq 3 ] && [ $recct -eq 3 ]; then

			echo ""
			echo "-----------------------------------------------------------------"
			echo "Event $tmp1  contains all 3 components, moving on..."
			echo "Event Count: $recct"
			echo "Count: $count"
			echo ""
			tmp1=""
			tmp2=""
			tmp3=""
			count=0
			recct=0

			echo "Tmp1: $tmp1"
			echo "Tmp2: $tmp2"
			echo "Tmp3: $tmp3"
			echo ""
			echo "Event Count: $recct"
			echo "Count: $count"
			echo "-----------------------------------------------------------------"
			echo ""
			echo ""

		fi

		
	fi

	if [ $count -lt 4 ]; then

		count=$((count+1))
		echo "Count incremented by 1 for new loop: $count"
	
	fi
	
	echo "Count is $count"
	echo "Event count is: $recct"
	echo "End of loop"
	echo ""
	
done < saclst.txt

rm saclst.txt
