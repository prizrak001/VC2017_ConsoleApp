#!/usr/bin/env bash

CURRENT_SCRIPT=$(realpath "$0")
CURRENT_SCRIPT_DIR=$(dirname "$CURRENT_SCRIPT")

[[ $# -eq 0 ]] || {
    echo "${CURRENT_SCRIPT}. Error 1. Incorrect argument count" >&2
    exit 1
}

echo "${CURRENT_SCRIPT} \"$1\"" >&2

RAND=$(head -c 2048 /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

BOOST_VERSION="1.64.0.beta.2"

echo "${CURRENT_SCRIPT}. Boost version: ${BOOST_VERSION}" >&2

BOOST_ARCHIVE_FILENAME="boost_1_64_0_b2.tar.bz2"
# BOOST_ARCHIVE_FILENAME="boost_${BOOST_VERSION_1}_${BOOST_VERSION_2}_${BOOST_VERSION_3}.tar.gz"
# BOOST_DOWNLOAD_LINK="https://sourceforge.net/projects/boost/files/boost/${BOOST_VERSION}/${BOOST_ARCHIVE_FILENAME}/download"
BOOST_DOWNLOAD_LINK="https://downloads.sourceforge.net/project/boost/boost/${BOOST_VERSION}/${BOOST_ARCHIVE_FILENAME}"
TMP_DIR="/tmp/vendor-boost-${BOOST_VERSION}-${RAND}"
VENDOR_DIR=$(realpath "${CURRENT_SCRIPT_DIR}/../vendor")

echo "${CURRENT_SCRIPT}. Boost archive filename: ${BOOST_ARCHIVE_FILENAME}" >&2
echo "${CURRENT_SCRIPT}. Boost download link: ${BOOST_DOWNLOAD_LINK}" >&2
echo "${CURRENT_SCRIPT}. Temporary folder: ${TMP_DIR}" >&2
echo "${CURRENT_SCRIPT}. Vendor folder: ${VENDOR_DIR}" >&2

mkdir "$TMP_DIR" || {
    exit 1
}

(
    cd "$TMP_DIR" || {
        exit 1    
    }

    curl --location --output "$BOOST_ARCHIVE_FILENAME" "$BOOST_DOWNLOAD_LINK" || {
        echo "${CURRENT_SCRIPT}. Error 3. Unable to download Boost" >&2
        exit 1        
    }

    BOOST_ARCHIVE_FILEPATH=$(realpath "$BOOST_ARCHIVE_FILENAME")
    
    echo "${CURRENT_SCRIPT}. Boost archive filepath: ${BOOST_ARCHIVE_FILEPATH}" >&2
    
    [[ -f "$BOOST_ARCHIVE_FILEPATH" ]] || {
        echo "${CURRENT_SCRIPT}. Error 4. File '$BOOST_ARCHIVE_FILENAME' doen't exist" >&2
        exit 1
    }       
    
    [[ -d "$VENDOR_DIR" ]] || mkdir "$VENDOR_DIR" || {
        exit 1
    }

    cd "$VENDOR_DIR" || {
        exit 1    
    }

    tar -xf "$BOOST_ARCHIVE_FILEPATH" || {
        exit 1
    }
) || {
    rm -r "$TMP_DIR"
    exit 1
}

rm -r "$TMP_DIR"
