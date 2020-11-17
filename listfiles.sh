bash -c 'if [ -f file.csv ]; then rm file.csv; fi' && echo "Folder;File;" >> file.csv && (xargs -n 1 -L 1 -I ? bash -c 'd=$(find ~ -name ?  -type d) && find "$d" -type f -exec echo "?;{};" \;' < $1)>>file.csv 2> /dev/null

