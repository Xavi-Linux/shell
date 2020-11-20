#!/bin/bash

#Dictionary is declared:
declare -A repos;
repos[campechano]='https://github.com/rgomezh/campechano.git'
repos[goodshellers]='https://github.com/ruizber23/goodshellers.git'
repos[equipo_confinados]='https://github.com/danielgarciasanchez/Equipo_confinados.git'
repos[team5]='https://github.com/rbarlaam/Team5.git'
repos[bashers]='https://github.com/JoaquinLou/Los-Bashers.git'
repos[fantasticos]='http://github.com/hxn241/Fantasticos.git'

#Let's checkout if the value passed as argument is a dictionary key:
#The value passed as an argument is translated to lowercase
#If an invalid value is passed, a 0-byte string is returned (empty); otherwise, the byte string is larger (nums of bytes = nums of string characters as the OS identifies the file as ASCII text)
#if an invalid value is passed, the script is exited by claiming error code 1 (0 = everything's just fine. This is not the case).
#echo's n option must be used. Otherwise, a trailing new line would be printed out
if [[ $(echo -n "${repos[${1,,}]}" | wc -c) -eq 0 ]]; then
 echo "Invalid dictionary key: $1";
 exit 1;
fi

#Let's store our local repository path in order to fetch our output files later:
miruta=/home/xavi/Documents/KSchool/01_Intro/fantasticos/Fantasticos

#The following lines create a new folder to stow the targeted git repository:
repo=~/ref_repo;

# I check if the folder already exists. If it does, I will force its removal. The script would work anyways, but a nasty fatal error would be printed out if the folder had been created before the current attempt.
if [[ -d $repo ]]; then
 rm -rf $repo;
fi
mkdir "$repo";
cd "$repo";
#Targeted repository is locally cloned:
git clone "${repos[${1,,}]}";

#Let's declare an array to store the files ending with out extension from the hacked repository
#Uppercase and lowercase extensions are both considered;there is no certainty about others' preferences
declare -a dir;
dir=$(find "$repo" -type f -name "*.out" -o -name "*.OUT");

#Let's loop through the array to carry out a one-to-one file comparison:
for ele in ${dir[@]}
do
 #file name is extracted from the whole path by executing the corresponding variable expansion:
 archivo="${ele: -7:7}";
 #I first check if the hacked file is empty. if it is, there's no point in carrying the subsequent operations
 #and I will move on to the next iteration by calling continue instruction:
 wcount=$(wc -w < $ele)
 if [[ $wcount -eq 0 ]]; then
  echo "El archivo $archivo está vacío";
  continue;
 fi
 #Then I check if my group has an homologous file:
 if [[ ! -f "$miruta/${archivo^^}" ]]; then
  echo "No hicimos el ejercicio $archivo";
  continue;
 fi
 #I proceed to run the file comparison by using diff command. My group used uppercase extensions:
 content=$(diff -y --suppress-common-lines "$miruta/${archivo^^}" "$ele");
 # I count the byte length of the  output
 a=$(echo -n "$content" | wc -c);
 # if byte count of the comparison is 0, I assume that both files are equal and so will it be heralded by the terminal:
 if [[ $a -eq 0 ]]; then
  #highlighted in green
  echo -e "\033[42mEl archivo $archivo es igual\033[0m\n\n";
 else
  #highlighted in red
  echo -e "\033[41mEl archivo $archivo no es igual\033[0m";
  echo -e "Las diferencias son:\n\n$content)\n\n";
 
  # Differences are saved in a new folder
  # Let's first check if the new folder already exist:
  dfolder=~/diff
  if [[ ! -d $dfolder ]]; then
   mkdir "$dfolder";
  fi
  echo -e "$content" > "$dfolder/${archivo:0:3}.diff";
 fi
done

#I eventually erase both newly-created folders: ref_repo and diff

rm -rf "$repo";
rm -r "$dfolder";


