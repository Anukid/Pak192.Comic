#!/bin/bash

set -e

echo 'pak192.comic open-source repository compiler for Linux'
echo -e '======================================================\n'

echo 'This bash compiles this repository into a new folder'
echo -e 'called compiled, makeobj must be in root folder.\n'

# Prints a progress bar with percentage
# @param $1 current index
# @param $2 total elements
# @param $3 current dat file being processed
progressbar() {
    # 3 chars at the beginning + 7 at the end
    local width=$(($(tput cols) - 10))
    local percent=$((100 * $1 / $2))
    local loading=$(($width * $1 / $2))

    tput cuu1
    tput el
    echo "  $3"
    echo -ne '  ['
    for (( i = 0; i < $loading; i++ )); do echo -ne '#'; done
    for (( i = 0; i < $(($width - $loading)); i++ )); do echo -ne '-'; done
    printf '] %3.1u%%\r' $percent
}

# Does all the heavy work
# @param $1 pakset size
# @param $2 log message
# @param $* list of files to compile
compile() {
    echo '------------------------------------------------------'
    echo -e "Compiling $2...\n"

    local index=1
    local size=($3)
    local size=${#size[@]}

        progressbar $index $size $dat
        local index=$(( $index + 1 ))
    done

    # jump line because of progress bar
    echo -ne '\n'
}

echo -n 'Checking for makeobj... '

if [ ! -f 'makeobj' ]; then
    echo 'ERROR: makeobj not found in root folder.'
    exit 1
fi

echo -e 'OK\n'

# Create folder for *.paks or delete all old paks if folder already exists
if [ ! -d 'compiled' ]; then
    mkdir compiled
fi

csv=compiled/compile.csv

# No file from last run, create empty one
if [ ! -f $csv ]; then
    echo '' > "$csv"
fi
echo '# This file allows the compile script to only recompile changed files' > "$csv.in"

compile '192' 'Landscape' 'pakset/landscape/**/*.dat'
compile '192' 'Buildings' 'pakset/buildings/**/*.dat'
compile '192' 'Infrastructure' 'pakset/infrastructure/**/*.dat'
compile '192' 'Vehicles' 'pakset/vehicles/**/*.dat'
compile '192' 'Goods' 'pakset/buildings/factories/goods/*.dat'
compile '32' 'User Interface' 'pakset/UI/32/*.dat'
compile '64' 'User Interface' 'pakset/UI/64/*.dat'
compile '128' 'User Interface' 'pakset/UI/128/*.dat'
compile '192' 'User Interface' 'pakset/UI/192/*.dat'
compile '384' 'Larger Objects' 'pakset/384/**/*.dat'

# Finished successfully, get rid of old csv
mv "$csv.in" "$csv"

echo -e '------------------------------------------------------'
echo -e 'Moving Trunk (configs, sound, text)\n\n'

cp -r pakset/trunk/* compiled

echo '======================================================'
echo 'Pakset complete!'
echo '======================================================'
