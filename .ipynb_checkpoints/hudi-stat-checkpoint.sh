#!/bin/bash

path="$1"
shift
table=$(basename "$path")
sections=$@

export APP_HOME="$(
    cd "$(dirname $(readlink -nf "$0"))"
    pwd -P
)"

echo "--------------   [ $(date '+%F %T') ]   --------------" >> $APP_HOME/hudi-stat.log

for section in $sections; do
    echo
    echo "[ ${section^^} ]"
    echo
    if [[ "$section" == "storage" ]]; then
        # show file layout from local with tree cli
        aws s3 sync --delete $path $APP_HOME/$table --exclude "*$" --exclude ".hoodie/*" --exclude "*/.hoodie*" &>/dev/null
        tree --du -ahs -D --timefmt '%T' $APP_HOME/$table
        echo "tree $APP_HOME/$table" >> $APP_HOME/hudi-stat.log
    else
        # make hudi-cli scripts and execute
        hudiCliScripts="$APP_HOME/.hudi-cli.scripts"
        echo "connect --path $path" > "$hudiCliScripts"
        case $section in
            timeline)
                echo "timeline show active" >> "$hudiCliScripts"
            ;;
            compactions)
                echo "compactions show all" >> "$hudiCliScripts"
            ;;
            commits)
                echo "commits show" >> "$hudiCliScripts"
            ;;
            fsview)
                echo "show fsview all" >> "$hudiCliScripts"
            ;;
        esac
        # for hudi-cli, only script mode can exit automatically
        hudi-cli script "$hudiCliScripts" 2>/dev/null | grep -o -e '^[╔].*\|^[║].*\|^[╠].*\|^[╟].*\|^[╚].*'
        cat "$hudiCliScripts" >> $APP_HOME/hudi-stat.log
    fi
done