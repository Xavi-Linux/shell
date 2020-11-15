ls -ltr $1 | tail -n +2 | xargs -n 1 -L 1 -I{} bash -c 'var=$(echo {} | grep -oE "...\s{1,2}[1-9]{1,2}\s[0-9]{2}:[0-9]{2}") && nvar=$(date -d "$var" +"%d/%m/%Y %H:%M") && sed -n -e "s|$var|$nvar|;p" <(echo {})'

