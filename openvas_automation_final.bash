#!/bin/bash

#https://superuser.com/questions/977331/how-to-make-openvas-listen-on-an-external-interface
#https://www.youtube.com/watch?v=-2vjsHmq3ak&t=284s

# This program seeks to automate the network vulnarability process on KALI LINUX SYSTEMS and #
# not on UBUNTU Systems. Rad/watch the above links to securely install openvas and then proc #
# eed as follows

omp -u subho -w zaq12wsx -G > status
if i=$( grep "Failed to acquire socket" status )
then 
	openvas-start
else 
	echo "openvas srunning"
fi

echo "1. Do you want to use previous target?"
echo "2. Do you want to scan argument target?"
echo "3.Do you want to use previous task?"
echo " 4. See report already present"
read choice

counter=0

if [ $choice -eq 1 ]
  then
	echo "Accessing already created targets"
	omp --username subho --password zaq12wsx -T
	echo "######################################################"
	echo "Which task would you want to access?"
	read name_of_target
	#takes the name of already created task

	echo
	echo "Enter the type of scan you want:" 
	echo "DiscoveryFullandfast/Fullandfastultimate\Fullandverydeep\Fullandverydeepultimate\HostDiscovery\SystemDiscovery"
	read type_of_scan
	#takes input the name of the type of scan you want

	omp --username subho --password zaq12wsx -g > list_of_tasks
	awk -vX="$var" '{ {print $1":"$2 $3 $4 $5 $6}}' list_of_tasks > temp_tasks
	#file of tasks

	scan_id=$( cat temp_tasks | awk -F':' -vX="$type_of_scan" '{ if( $2==X ) \
                { print $1 }}' )
	#get the scan_id 

	target_id=$( omp --username subho --password zaq12wsx -T | awk -vX="$name_of_target" '{ \
         if( $2==X ){ print $1 }}' )
	#get the targe id 
	
	echo "###############################################"
	echo "Enter the name of you task"
	read name_of_task
	#task name given

	task_id=$( omp --username subho --password zaq12wsx -C -c "$scan_id"  \
        	--name $name_of_task --target="$target_id" )
	#create a task
	#get task id
	
	counter=1

elif [ $choice -eq 2 ]
 then
	hosts=$1
	echo  "##########################################################"
	echo "Enter the name of your target"
	read name_of_target
	#takes the name of your target as input

	omp --username subho --password zaq12wsx --xml="<create_target> <name>"$name_of_target"</name> <hosts>"$hosts"</hosts> </create_target>"
	#to create a target from the input ip address with name 

	echo
	echo "Enter the type of scan you want: Discovery/Fullandfast/Fullandfastultimate\Fullandverydeep\Fullandverydeepultimate\HostDiscovery\SystemDiscovery"
	read type_of_scan
	#takes input the name of the type of scan you want

	omp --username subho --password zaq12wsx -g > list_of_tasks
	awk -vX="$var" '{ {print $1":"$2 $3 $4 $5 $6}}' list_of_tasks > temp_tasks
	#file of tasks

	scan_id=$( cat temp_tasks | awk -F':' -vX="$type_of_scan" '{ if( $2==X ) \
		{ print $1 }}' )
	#get the scan_id 

	target_id=$( omp --username subho --password zaq12wsx -T | awk -vX="$name_of_target" '{ \
	 if( $2==X ){ print $1 }}' )
	#get the targe id 
	
	echo 
	echo "Enter the name of you task"
	read name_of_task
	#task name given

	task_id=$( omp --username subho --password zaq12wsx -C -c "$scan_id"  \
	--name $name_of_task --target="$target_id" )
	#create a task
	#create task id

	counter=1

elif [ $choice -eq 3 ]
then	
	echo "######################################"
	omp -u subho -w zaq12wsx -G
	
	echo 
	echo "Name of task you want to start"
	read name_of_task
	#take input the name of task

	task_id=$( omp --username subho --password zaq12wsx --get-tasks | 
		awk -vX="$name_of_task" '{ if( $3==X ){ print $1 }}' )
	#task ID by searching the tasks
	
	echo $task_id
	counter=1

else	
	echo "####################################"
	omp -u subho -w zaq12wsx -G
		
	echo "proceeding to reports"
	counter=2
	echo "enter then name of your task to seach report for"
	read name_of_task
	
	task_id=$( omp --username subho --password zaq12wsx --get-tasks | 
                awk -vX="$name_of_task" '{ if( $3==X ){ print $1 }}' )
        #task ID by searching the tasks
fi

if [ $counter -eq 1 ]
then
	omp --username subho --password zaq12wsx -S "$task_id"
	#starting task
	omp --username subho --password zaq12wsx -G
	#initial progress of task

	echo "Scan Running...."


	while true
	do
   		sleep 1
   		scan_variable=$( omp --username subho --password zaq12wsx -G | grep "$name_of_task" | awk '{ print $2}' )
   		scan_percent=$( omp --username subho --password zaq12wsx -G | grep "$name_of_task" | awk '{ print $3 }' | sed 's/%//' )
   		#getting the status of scan and the percentage completed

   		if [ "$scan_variable" == "Requested" ]
    		then
			echo "Wait for scan start"
			sleep 40
   		elif [ "$scan_variable" == "Running" ]
   		then
        		if ! (( $scan_percent % 10 ))
			then
				echo  "The scan " $scan_percent " complete"
				sleep 40
			fi
   		elif [ "$scan_variable" == "Done" ]
   		then
			echo "Scan is Complete" $scan_variable
			omp --username subho --password zaq12wsx -G | grep "$name_of_task" 
			break       	   #Abandon the loop.
   	fi
	done
fi

report_id=$( omp --username subho --password zaq12wsx --get-tasks "$task_id" |
	 awk 'NR==2 {print $1}' )
#obtaining the report ID

echo "DONE REPORT"

omp --username subho --password zaq12wsx -F
#generating the list of report formats

echo "Enter your report format"
read format
#taking input of user format reuirements

omp --username subho --password zaq12wsx -F | awk '{ print $1":"$2" "$3 }' > temp_rep
format_id=$( grep $format temp_rep | awk -F':' '{print $1}' )
#getting the format ID of the user requested format


omp --username subho --password zaq12wsx -R "$report_id" -f "$format_id" > report_complete
omp --username subho --password zaq12wsx -R "$report_id" -f "$format_id" --filter="overrides=1 levels=hml notes=1 min_qod=70 autofp=0 --scanend" > result_optimized
#creating report files

echo "Report saved in file result_optimized"
echo "complete reported in file  report_complete"

echo "#############################################################"
echo "Do you want to continue to Wapiti 3.X scan? (Y/N)"
read choose

if [[ "$choose" == "Y" || "$choose" == "y" ]]
then 
	echo "enter the URL of webpage"
	read URL
	wapiti -u "$URL" -f txt
else 
	echo "end of wapiti"
fi

echo "###########################################################"
echo "starting IP info gathering"
nmcli device show eth0 | grep IP > DNS_IP_details

temp_client_var=$( ls /var/lib/NetworkManager | grep lease )
cat /var/lib/NetworkManager/"$temp_client_var" > detailed_dhcp_report

echo "enter your IP ranges"
read IP_ranges_var

nmap "$IP_ranges_var" > network_details_devices
nmap -if list > address_details

nmap -O -v "$IP_ranges_var" > OS_details
echo "read files 1. DNS_IP_details 2. detailed_dhcp_report 3. network_details_devices 4. address_details 5. OS_details"

rm list_of_tasks
rm temp_rep
rm temp_tasks
rm status
