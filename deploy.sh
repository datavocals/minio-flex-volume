#!/usr/local/bin/bash

set -o errexit
set -o pipefail

VENDOR=datavocals
DRIVER_ISTALLATION_LOCATION=/flexmnt
declare -a DRIVERS=("minio")

for DRIVER in "${DRIVERS[@]}"
do
    echo "Installing $DRIVER"
    driver_dir=$DRIVER_ISTALLATION_LOCATION/${VENDOR}~${DRIVER}
    if [ ! -d "$driver_dir" ]; then
        mkdir -p "$driver_dir"
    fi

    if [ ! -d "$driver_dir/.$DRIVER" ]; then
        mkdir -p "$driver_dir/.$DRIVER"
    fi

    cp "/$DRIVER/$DRIVER" "$driver_dir/.$DRIVER/$DRIVER"
    mv -f "$driver_dir/.$DRIVER/$DRIVER" "$driver_dir/"
done

echo "Listing installed drivers:"
ls -l $DRIVER_ISTALLATION_LOCATION

# this is a workaround to prevent the container from exiting 
# and k8s restarting the daemonset pod
while true; do sleep 2; done