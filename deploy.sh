#!/usr/bin/env bash

set -o errexit
set -o pipefail

VENDOR=datavocals
DRIVER_ISTALLATION_LOCATION=/flexmnt
declare -a DRIVERS=("minio")

for DRIVER in "${DRIVERS[@]}"
do
    echo "Installing $DRIVER"
    driver_dir=$DRIVER_ISTALLATION_LOCATION/${VENDOR}~${DRIVER}/${DRIVER}
    if [ ! -d "$driver_dir" ]; then
        mkdir -p "$driver_dir"
    fi

    cp "/$DRIVER" "$driver_dir/.$DRIVER"
    mv -f "$driver_dir/.$DRIVER" "$driver_dir/$DRIVER"
done

echo "Listing installed drivers:"
ls -l $DRIVER_ISTALLATION_LOCATION