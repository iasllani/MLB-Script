#Manrique Iriarte
#April 17, 2018
#Shell script for getting mlb standings

clear

programHeading() {
	echo "MLB Shell Script: "
	echo -e "\t1) View Standings"
	echo -e "\t2) View Scores"
	echo -e "\t3) View Player Stats" 
	echo -e "\t4) Exit Script"
}

programHeading

echo -n "Enter a selection: "

while read selection
do
	case $selection in
		1)
			clear
			wget -qO- https://erikberg.com/mlb/standings.xml > mlb1
			displaydata() {
				if [ $6 == "0.0" ]
				then
					echo "$1     $2     $3     $4-$5     -"  | awk '{printf"%7s %7s %7s %7s %7s\n", $1, $2, $3, $4, $5}'
				else
					echo "$1     $2     $3     $4-$5     $6" | awk '{printf"%7s %7s %7s %7s %7s %7s\n", $1, $2, $3, $4, $5, $6}'
				fi
				echo ----------------------------------------
			}
		    NLdisplaydata() {
				if [ $6 == "0.0" ]
				then
					tput cup $7 50
					echo "$1     $2     $3     $4-$5     -"   | awk '{printf"%7s %7s %7s %7s %7s\n", $1, $2, $3, $4, $5}'
				else
					tput cup $7 50
					echo "$1     $2     $3     $4-$5     $6"  | awk '{printf"%7s %7s %7s %7s %7s %7s\n", $1, $2, $3, $4, $5, $6}'
				fi
				let theNextRow=$7+1
				tput cup $theNextRow 50
				echo ----------------------------------------
			}

			getdata() {
				grep 'team-key' mlb1 | head -$1 | tail -5 | cut -d'"' -f2 | cut -d'"' -f1 > division
				grep 'events-all' mlb1 | cut -d'=' -f5 | cut -d'"' -f2 | cut -d'"' -f1 | head -$1 | tail -5 > wins
				grep 'events-all' mlb1 | cut -d'=' -f6 | cut -d'"' -f2 | cut -d'"' -f1 | head -$1 | tail -5 > losses
				grep 'events-all' mlb1 | cut -d'=' -f7 | cut -d'"' -f2 | cut -d'"' -f1 | head -$1 | tail -5 > winpercentage
				grep 'events-most-recent-10' mlb1 | cut -d'=' -f3 | cut -d'"' -f2 | cut -d'"' -f1 | head -$1 | tail -5 > lasttenwins
				grep 'events-most-recent-10' mlb1 | cut -d'=' -f4 | cut -d'"' -f2 | cut -d'"' -f1 | head -$1 | tail -5 > lasttenlosses
				grep 'games-back' mlb1 | cut -d'=' -f3 | cut -d'"' -f2 | cut -d'"' -f1 | head -$1 | tail -5 > gb
			}

			makevariables() {
				wins=`cat wins | head -$1 | tail -1`	
				losses=`cat losses | head -$1 | tail -1`
				winpercentage=`cat winpercentage | head -$1 | tail -1`
				lasten=`cat lasttenwins | head -$1 | tail -1`
				lastenlosses=`cat lasttenlosses | head -$1 | tail -1`
				gamesback=`cat gb | head -$1 | tail -1`
			}

			ALheadings() {
				echo "    $1"
				echo
				echo "W      L     PCT     L10     GB"  | awk '{printf"%7s %7s %7s %7s %7s\n", $1, $2, $3, $4, $5}'
				echo ----------------------------------------
			}

			NLheadings() {
				tput cup $2 50
				echo "    $1"
				nextRow=$2+1
				tput cup $nextRow 50
				echo
				let nextRow=$nextRow+1
				tput cup $nextRow 50
				echo "W      L     PCT     L10     GB" | awk '{printf"%7s %7s %7s %7s %7s\n", $1, $2, $3, $4, $5}'
				let nextRow=$nextRow+1
				tput cup $nextRow 50
				echo ----------------------------------------
			}

			echo "                American League"
			echo
			ALheadings "AL East" 
			getdata 5
			i=1
			for team in `cat division`
			do
				echo $i. $team | sed s/"-"/" "/g | sed -e "s/\b\(.\)/\u\1/g"
				makevariables $i
				displaydata $wins $losses $winpercentage $lasten $lastenlosses $gamesback
				let i=$i+1
			done

			echo 
			ALheadings "AL Central" 
			getdata 10
			i=1
			for team in `cat division`
			do
				echo $i. $team | sed s/"-"/" "/g | sed -e "s/\b\(.\)/\u\1/g"
				makevariables $i
				displaydata $wins $losses $winpercentage $lasten $lastenlosses $gamesback
				let i=$i+1
			done
			echo
			ALheadings "AL West"
			getdata 15
			i=1
			for team in `cat division`
			do
				echo $i. $team | sed s/"-"/" "/g | sed -e "s/\b\(.\)/\u\1/g"
				makevariables $i
				displaydata $wins $losses $winpercentage $lasten $lastenlosses $gamesback
				let i=$i+1
			done
	
			tput cup 0 50
			echo "                National League"
			tput cup 1 50
			echo

			NLheadings "NL East" 2
			getdata 20
			i=1
			row=6
			for team in `cat division`
			do
				let dataRow=$row+1
				tput cup $row 50
				echo $i. $team | sed s/"-"/" "/g | sed -e "s/\b\(.\)/\u\1/g"
				makevariables $i
				NLdisplaydata $wins $losses $winpercentage $lasten $lastenlosses $gamesback $dataRow
				let i=$i+1
				let row=$row+3
			done
			tput cup 21 50
			echo
			NLheadings "NL Central" 22
			getdata 25
			i=1
			row=26
			for team in `cat division`
			do
				let dataRow=$row+1
				tput cup $row 50
				echo $i. $team | sed s/"-"/" "/g | sed -e "s/\b\(.\)/\u\1/g"
				makevariables $i
				NLdisplaydata $wins $losses $winpercentage $lasten $lastenlosses $gamesback $dataRow
				let i=$i+1
				let row=$row+3
			done
			tput cup 41 50
			echo
			NLheadings "NL West" 42
			getdata 30
			i=1
			row=46
			for team in `cat division`
			do
				let dataRow=$row+1
				tput cup $row 50
				echo $i. $team | sed s/"-"/" "/g | sed -e "s/\b\(.\)/\u\1/g"
				makevariables $i
				NLdisplaydata $wins $losses $winpercentage $lasten $lastenlosses $gamesback $dataRow
				let i=$i+1
				let row=$row+3
			done    
			echo
			programHeading
			;;
		2)
			clear
			echo -n "Enter month (mm): "
			read mm
			echo -n "Enter day (dd): "
			read dd
			echo -n "Enter year (yyyy): "
			read yyyy
			wget -qO- https://www.cbssports.com/mlb/scoreboard/$yyyy$mm$dd/ > scores
			grep 'game-status' -A 1 scores | cut -d'>' -f2 | cut -d'-' -f2 > gamestatus |		
			grep 'http://www.cbssports.com/mlb/teams/page' scores | cut -d'/' -f18 | cut -d'"' -f1 > h2h	
			grep "</td>" scores | cut -d'>' -f2 | cut -d'<' -f1 > scoreboard
			i=1
			for team in `cat h2h`
			do
				echo $team > teamslist
				grep `cat h2h | head -$i | tail -1` scores -A 6 | tail -3 | head -1 | cut -d'>' -f2 | cut -d'<' -f1 > runs
				grep `cat h2h | head -$i | tail -1` scores -A 6 | tail -3 | head -2 | tail -1 | cut -d'>' -f2 | cut -d'<' -f1 > hits
				grep `cat h2h | head -$i | tail -1` scores -A 6 | tail -1 | cut -d'>' -f2 | cut -d'<' -f1 > errors
				#check to see if hits, runs, or errors give me my desired output. This usually happens on current date
				if [ "`cat hits | cut -c1`" == " " ]
				then
					paste teamslist runs errors | awk '{printf "%25s %7s %7s %7s\n", $1, $2, $3, $4}' | sed s/'-'/' '/g | sed -e "s/\b\(.\)/\u\1/g" >> teamstats
				elif [ "`cat errors | cut -c1`" == " " ]
				then
					paste teamslist runs hits | awk '{printf "%25s %7s %7s %7s\n", $1, $2, $3, $4}' | sed s/'-'/' '/g | sed -e "s/\b\(.\)/\u\1/g" >> teamstats
				elif [ "`cat runs | cut -c1`" == " " ]
				then
					paste teamslist hits errors | awk '{printf "%25s %7s %7s %7s\n", $1, $2, $3, $4}' | sed s/'-'/' '/g | sed -e "s/\b\(.\)/\u\1/g" >> teamstats
				else
					paste teamslist runs hits errors | awk '{printf "%25s %7s %7s %7s\n", $1, $2, $3, $4}' | sed s/'-'/' '/g | sed -e "s/\b\(.\)/\u\1/g" >> teamstats
				fi
				#####
				let i=$i+1
			done
				
			teams=2
			play=1
			echo Team Runs Hits Errors | awk '{printf "%25s %7s %7s %7s\n", $1, $2, $3, $4}'
				
			for gamestatus in `cat gamestatus`
			do
				if [ $gamestatus == "moon" -o $gamestatus == "bar" ]
				then
					gamestatus="In Progress"
				fi	
				echo $gamestatus
				
				cat teamstats | head -$teams | tail -2 
					
				echo --------------------------------------------------------------------
				let teams=$teams+2
				let play=$play+1
			done
			rm teamstats runs
			programHeading
			;;
		3)
						### Shell script for getting Batting avg leaders and their ba
			clear
			echo -n "Press 1 for Batting Stats, 2 for Pitching Stats: "
			while read choice
			do
				case $choice in 
					1)
						clear
						wget -qO- https://www.teamrankings.com/mlb/player-stat/batting-average > test1

						cat test1 | grep "/player/" | cut -d'"' -f4 | cut -d'"' -f1 > baplayers
						cat test1 | grep '"text-right" data-sort="0' | cut -d">" -f2 | cut -d"<" -f1 > bavg

						paste baplayers bavg > combine1
						cat combine1 | sed s/" "/"_"/g |awk 'BEGIN {printf "%-20s %11s\n-------------------------------------\n", "Player Name", "Bat Avg"}NR==1, NR==10 {printf "%-20s %11s\n-------------------------------------\n", $1, $2}' | sed s/"_"/" "/g

						### Shell script for getting Home Run leaders and their Homeruns

						wget -qO- https://www.teamrankings.com/mlb/player-stat/home-runs > test2

						cat test2 | grep "/player/" | cut -d'"' -f4 | cut -d'"' -f1 > hrplayers
						cat test2 | grep '"text-right" data-sort="0' | cut -d">" -f2 | cut -d"<" -f1 > hr

						paste hrplayers hr > combine2
						echo 
						cat combine2 | sed s/" "/"_"/g |awk 'BEGIN {printf "%-20s %11s\n-------------------------------------\n", "Player Name", "Home Runs"}NR==1, NR==10 {printf "%-20s %11s\n-------------------------------------\n", $1, $2}' | sed s/"_"/" "/g

						### Shell script for getting RBI leaders

						wget -qO- https://www.teamrankings.com/mlb/player-stat/runs-batted-in > test3

						cat test3 | grep "/player/" | cut -d'"' -f4 | cut -d'"' -f1 > rbiplayers
						cat test3 | grep '"text-right" data-sort="0' | cut -d">" -f2 | cut -d"<" -f1 > rbi
						paste rbiplayers rbi > combine3
						echo 
						cat combine3 | sed s/" "/"_"/g |awk 'BEGIN {printf "%-20s %11s\n-------------------------------------\n", "Player Name", "RBI"}NR==1, NR==10 {printf "%-20s %11s\n-------------------------------------\n", $1, $2}' | sed s/"_"/" "/g
						echo -n "Choose again or press 3 to stop: "
						;;
			### Shell script for getting top pitchers sorted by ERA
				2)
						clear
						wget -qO- https://www.teamrankings.com/mlb/player-stat/earned-runs-allowed?rate=per-pitcher-game > test4

						cat test4 | grep "/player/" | cut -d'"' -f4 | cut -d'"' -f1 > eraplayers
						cat test4 | grep '"text-right" data-sort="0' | cut -d">" -f2 | cut -d"<" -f1 > era

						paste eraplayers era > combine4
						echo 
						cat combine4 | sed s/" "/"_"/g |awk 'BEGIN {printf "%-20s %11s\n-------------------------------------\n", "Player Name", "ERA"}NR==1, NR==10 {printf "%-20s %11s\n-------------------------------------\n", $1, $2}' | sed s/"_"/" "/g

						### Shell script for getting top pitchers sorted by wins
						wget -qO- https://www.teamrankings.com/mlb/player-stat/strikeouts > test6

						cat test6 | grep "/player/" | cut -d'"' -f4 | cut -d'"' -f1 > ksplayers
						cat test6 | grep '"text-right" data-sort="0' | cut -d">" -f2 | cut -d"<" -f1 > ks

						paste ksplayers ks > combine6
						echo 
						cat combine6 | sed s/" "/"_"/g |awk 'BEGIN {printf "%-20s %11s\n-------------------------------------\n", "Player Name", "Strikes"}NR==1, NR==10 {printf "%-20s %11s\n-------------------------------------\n", $1, $2}' | sed s/"_"/" "/g

						### Shell script for getting top pitchers sorted by wins
						wget -qO- https://www.teamrankings.com/mlb/player-stat/wins > test5

						cat test5 | grep "/player/" | cut -d'"' -f4 | cut -d'"' -f1 > winsplayers
						cat test5 | grep '"text-right" data-sort="0' | cut -d">" -f2 | cut -d"<" -f1 > wins

						paste winsplayers wins > combine5
						echo 
						cat combine5 | sed s/" "/"_"/g |awk 'BEGIN {printf "%-20s %11s\n-------------------------------------\n", "Player Name", "Wins"}NR==1, NR==10 {printf "%-20s %11s\n-------------------------------------\n", $1, $2}' | sed s/"_"/" "/g
						echo -n "Choose again or press 3 to stop: "
						;;
					3)
						break
						;;
					*)
						echo -n "Not valid. Enter again: "
						;;
				esac
			done
			programHeading
			;;
		4)
			echo "Exiting Script"
			break
			;;
		*)
			echo "Not Valid. Enter again: "
			programHeading
			;;
	esac
done
