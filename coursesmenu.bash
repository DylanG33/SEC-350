#! /bin/bash
clear

# filling courses.txt
bash courses.bash

courseFile="courses.txt"

function displayCoursesofInst(){

echo -n "Please Input an Instructor Full Name: "
read instName

echo ""
echo "Courses of $instName :"
cat "$courseFile" | grep "$instName" | cut -d';' -f1,2 | \
sed 's/;/ | /g'
echo ""

}

function courseCountofInsts(){

echo ""
echo "Course-Instructor Distribution"
cat "$courseFile" | cut -d';' -f7 | \
grep -v "/" | grep -v "\.\.\." | \
sort -n | uniq -c | sort -n -r 
echo ""

}

# TODO - 1
# Make a function that displays all the courses in given location
# function dislaplays course code, course name, course days, time, instructor
# Add function to the menu
# Example input: JOYC 310
# Example output: See the screenshots in canvas
function displayCoursesInLocation() {
    echo -n "Please input a location (example: JOYC 310): "
    read location
    echo ""
    echo "Courses in $location :"
    awk -F';' -v loc="$location" '$10==loc {printf "%s | %s | %s | %s | %s\n", $1, $2, $5, $6, $7}' "$courseFile"
    echo ""
}
# TODO - 2
# Make a function that displays all the courses that has availability
# (seat number will be more than 0) for the given course code
# Add function to the menu
# Example input: SEC
# Example output: See the screenshots in canvas
function displayAvailableCourses() {
    echo -n "Please input a course code (example: SEC): "
    read code
    echo ""
    echo "Available $code Courses:"
    awk -F';' -v c="$code" '$1 ~ c && $8+0 > 0 {printf "%s | %s | %s | %s | %s\n", $1, $2, $3, $8, $7}' "$courseFile"
    echo ""
}

while :
do
	echo ""
	echo "Please select and option:"
	echo "[1] Display courses of an instructor"
	echo "[2] Display course count of instructors"
	echo "[3] Display courses in a location"
	echo "[4] Display available courses for a course code"
	echo "[5] Exit"

	read userInput
	echo ""

	if [[ "$userInput" == "5" ]]; then
		echo "Goodbye"
		break

	elif [[ "$userInput" == "1" ]]; then
		displayCoursesofInst

	elif [[ "$userInput" == "2" ]]; then
		courseCountofInsts

	elif [[ "$userInput" == "3" ]]; then
		displayCoursesInLocation

	elif [[ "$userInput" == "4" ]]; then
		displayAvailableCourses

	else
		echo "No input given, please select from 1 through 5"

	# TODO - 3 Display a message, if an invalid input is given
	fi
done
