#!/usr/bin/env bash
regex=’\$GLOBALS\[‘\’’([a-zA-Z0-9]+)’\’’\](?\s)=(?\s)\$([a-zA-
Z0-9]+)\[([0-9]+\])\.\$([a-zA-Z0-9]+)\[([0-9]+\])\.\$([a-zA-
Z0-9]+)\[([0-9]+\])\.’
filenames=”admin.php ajax.php alias.php article.php blog.php cache.
php code.php config.php css.php db.php defines.php diff.php dir.php 
dirs.php dump.php error.php file.php files.php footer.php functions.
php gallery.php general.php global.php header.php help.php include.
php inc.php info.php ini.php javascript.php lib.php list.php log
-
in.php menu.php model.php object.php option.php options.php page.
php plugin.php press.php proxy.php search.php session.php sql.php 
start.php stats.php system.php template.php test.php themes.php 
title.php user.php utf.php view.php xml.php”
files=$(find . -type f)
high_conf_hits=0
sig_hits=0
name_hits=0
echo “”
echo “[ scanning filesystem ]”
echo “”
for filename in $files; do
    hit=$(egrep $regex $filename)
    if [ “$hit” ]; then
        sig_hits=$(($sig_hits+1))
        match=”sig match”
        for bad_name in $filenames; do
            name_match=$(echo $filename | grep “$bad_name”)
            if [ “$name_match” ]; then
                match=”sig & name *HIGH CONF*”
                high_conf_hits=$(($high_conf_hits+1))
            fi
        done;
        echo “[$match] > $filename”
    fi
done
for filename in $filenames; do
    hit=$(find . -name “$filename”)
    for suspect in $hit; do
        echo “[name match] > $suspect”
        name_hits=$(($name_hits+1))
    done
done
echo “”
echo “[ $(($sig_hits+$name_hits)) SUSPECTED FILES FOUND ]”
echo “[ $high_conf_hits HIGH CONFIDENCE SUSPECTED FILES FOUND ]”
