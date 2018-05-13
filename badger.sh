#!/bin/bash

# Badger
#
# Michal Tynior (c) 2018
# License: MIT
#
# https://github.com/mtynior/badger

function checkTools() {
    PATH_TO_IMAGE_MAGIC=$(which convert)
    
    if [ -z $PATH_TO_IMAGE_MAGIC ]; then
        logError "You have to install ImageMagick to use 'badger'."
        echo "Install it using: 'brew install imagemagick'"
        exit 1
    fi
}

function addBadge() {
    ICON_PATH=$1
    BADGE_PATH=$2

    WIDTH=$(identify -format %w ${ICON_PATH})
    HEIGHT=$(identify -format %h ${ICON_PATH})
    SIZE="${WIDTH}x${HEIGHT}"
    
    composite -resize ${SIZE} ${BADGE_PATH} ${ICON_PATH} ${ICON_PATH}    
}

function reportUsage() {
    echo "Usage: ${0} -b <path to badge file> -i <path to .appiconset file>"
}

function logError() {
    echo -e "\033[1;31m${1}\033[0m"
}

function logInfo() {
    echo -e "\033[1;36m${1}\033[0m"
}

function logDebug() {
    echo $1
}

function logSuccess() {
    echo -e "\033[1;32m${1}\033[0m"
}

#------------------------------------------------------------------------------
# Main script

BADGER_VERSION="1.0.0"

logInfo "Badger v${BADGER_VERSION}"

# Check if we have all available tools
checkTools

# Set an initial values for the flags
BADGE_IMAGE_PATH=""
ICONSET_PATH=""

# Read options
OPTS=`getopt b:i: $*`
eval set -- "$OPTS"

if [ $? != 0 ] ; then
     reportUsage
     exit 1
fi

# Extract options and their arguments into variables.
while true ; do
    case "$1" in
        -b) BADGE_IMAGE_PATH=$2 ; shift 2 ;;
        -i) ICONSET_PATH=$2 ; shift 2 ;;
        --) shift ; break ;;
        *) reportUsage ; exit 1 ;;
    esac
done

# Check if we got all reqired arguments

if [ -z $BADGE_IMAGE_PATH ]; then
    logError "Path to badge image is missing."
    reportUsage
    exit 1
fi

if ! [ -f "$BADGE_IMAGE_PATH" ]; then
    logError "Could not find file ${BADGE_IMAGE_PATH}"
    exit 1
fi

if [ -z $ICONSET_PATH ]; then
    logError "Path to .appiconset file is missing."
    reportUsage
    exit 1
fi

if ! [ -d "$ICONSET_PATH" ]; then
    logError "Could not find file ${ICONSET_PATH}"
    exit 1
fi

# Get all icons from .appiconset

ICONS=$(find -E "$ICONSET_PATH" -regex '.*\.(png|PNG)')
NUMBER_OF_ICONS=$(wc -l <<< "$ICONS" | xargs)

logInfo "Found ${NUMBER_OF_ICONS} icons."

while read -r icon; do
    logDebug "Adding badge to ${icon}."
    addBadge $icon "$BADGE_IMAGE_PATH"
done <<< "$ICONS"

logSuccess "Successfully finished adding badge to ${NUMBER_OF_ICONS} icons."
