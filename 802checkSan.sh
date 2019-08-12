#!/bin/bash

echo "			**Welcome to 802.1x Checker Script**"

read -p "Please enter the project name: " filename && echo

if [ -f "$filename.xlsx" ]; then
	echo "$filename already exists. Append to file?"
	read -p "yes/no? " fileNameAnswer

	if [ "$fileNameAnswer" = "no" ]; then
		read -p "Enter new filename: " fileReName
		while [ "$fileReName" = "$filename" ]; do
		read -p "enter new filename: " fileReName
		done

		touch $fileReName.xlsx
		echo "file $fileReName.xlsx created"
		echo "Location	Floor	Room	Port	Result	Comment" > $fileReName.xlsx
		[ "$fileRename = $filename" ]
	fi

else
	touch $filename.xlsx
	echo "file $filename.xlsx created"
	echo "Location	Floor	Room	Port	Result	Comment" > $filename.xlsx

fi


clear
while [ True ]; do
	echo
	echo "|-----------------------|"
	echo "|    Select an Option   |"
	echo "| 1: New Entry          |"
	echo "| 2: View Project File  |"
	echo "| 3: Quit?              |"
	echo "|-----------------------|" 

	echo && read -p "1/2/3?: " caseInput

	case $caseInput in

	1)	echo && echo "			New Entry" && echo
		echo "Select Sound Transit Location by number" && echo
		echo "1: 5th & Jackson"
		echo "2: Bldg 705"
		echo "3: Bldg 605"
		echo "4: Bldg 625"
		echo "5: Mountlake Terrace"
		echo "6: Bellevue"
		echo

		read -p "1/2/3/4/5/6?: " locationChoice
		case $locationChoice in
			1) echo "5th & Jackson" && location="5th & Jackson" 
				;;
			2) echo "Bldg 705" && location="Bldg 705" 
				;;
			3) echo "Bldg 605" && location="Bldg 605"
				;;
			4) echo "Bldg 625" && location="Bldg 625"
				;;
			5) echo "Mountlake Terrace" && location="Mountlake Terrace"
				;;
			6) echo "Bellevue" && location="Bellevue"
				;;
		esac


		read -p "Floor?: " floor
		read -p "Room?: " room
		read -p "Port?: " port && echo

		macchanger eth0 -r > /dev/null

		clear
		echo "			Entering testing phase." && echo 
			##connection testing area
				ifconfig wlan0 down && echo "Disable WiFI [COMPLETE]"
				echo "Randomizing MAC address [COMPLETE]" && echo

				echo "			Connect ethernet cable now"
				while [ true ]; do
					read -p "press y when connected: " connectedVar
						if [ "$connectedVar" = "y" ]; then
							break
						else
							echo "Please type y"
						fi
				done

				echo "Testing connection" && echo
				nmTestVar=`nm-online -t 240` && echo `echo "$nmTestVar" | grep "online"` > /dev/null

				if [ -n "$nmTestVar" ]; then
					echo "Connection detected" && echo
				else
					echo "Connection not detected" && ConnResult="No Connection Detected"
				fi

					while [ testingnVar="true" ]; do

						echo "Checking for Whitelist IP"


						pulledIP=`hostname -I`
						whitelistIPCheck=`echo "$pulledIP" | cut -d . -f 1 = 10`

						 if [ "$pulledIP" != "" ] && [ "$whitelistIPCheck" = "10" ]; then
							echo "Pulled whitelist IP: $pulledIP"
						   else
							echo "Did not pull Whitelist IP"
							echo "$pulledIP"
						   fi







						echo "Checking for Internet Connectivity"
							ping 8.8.8.8 -c 5
						echo "Checking for Server Resource Connectivity(Sanitized)"
 							ping 8.8.8.8 -c 5
						echo ""

						while [ true ]; do
							echo "1: Set Access Granted?"
							echo "2: Set Access Denied? "
							echo "3: Test again?"
							read -p "1/2/3: " testDecide
							case $testDecide in
								1)result="Access Granted" && echo "granted"
									break
									;;
								2)result="Access Denied" && echo "Denied"
									break
									;;
								3)break
									;;
							esac

						done
							if [ -n "$result" ]; then
								break
							else
								continue
							fi
					done


			##connection testing area
			read -p "Comments?: " comment

			echo "$location	$floor	$room	$port	$result	$comment" >> $filename.xlsx && echo 

		;;

	2)echo 
		cat $filename.xlsx
		;;
	3)echo "Goodbye"
		exit 0
		;;
	*)echo "Invalid choice"
		;;
	esac
done
