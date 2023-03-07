#!/bin/bash
path=$1
shift
table=$(basename $path)
sections=$@

for section in $sections; do
    echo
    echo "[ ${section^^} ]"
    echo
    if [[ "$section" == "storage" ]]; then
        # show file layout from local with tree cli
        aws s3 sync --delete $path ~/$table --exclude "*$" --exclude ".hoodie/*" --exclude "*/.hoodie*" &>/dev/null
        tree --du -ahs -D --timefmt '%T' ~/$table
    else
        # make hudi-cli scripts and execute
        echo "connect --path $path" > /tmp/hudi-stat.snippets
        case $section in
            timeline)
                echo "timeline show active" >> /tmp/hudi-stat.snippets
            ;;
            compactions)
                echo "compactions show all" >> /tmp/hudi-stat.snippets
            ;;
            commits)
                echo "commits show" >> /tmp/hudi-stat.snippets
            ;;
            fsview)
                echo "show fsview all" >> /tmp/hudi-stat.snippets
            ;;
        esac
        # for hudi-cli, only script mode can exit automatically
        hudi-cli script /tmp/hudi-stat.snippets 2>/dev/null | grep -o -e '^[╔].*\|^[║].*\|^[╠].*\|^[╟].*\|^[╚].*'
    fi
done