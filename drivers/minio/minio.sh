
#!/bin/bash

usage() {
	err "Invalid usage. Usage: "
	err "\t$0 init"
	err "\t$0 mount <mount dir> <json params>"
	err "\t$0 unmount <mount dir>"
	exit 1
}

err() {
	echo -ne $* 1>&2
}

log() {
	echo -ne $* >&1
}

ismounted() {
	MOUNT=`findmnt -n ${MNTPATH} 2>/dev/null | cut -d' ' -f1`
	if [ "${MOUNT}" == "${MNTPATH}" ]; then
		echo "1"
	else
		echo "0"
	fi
}

domount() {
	MNTPATH=$1

	local S3_ACCESS_KEY=$(echo $2 | jq -r '.s3_access_key')
	local S3_ACCESS_SECRET=$(echo $2 | jq -r '.s3_access_secret')
	local S3_BUCKET=$(echo $2 | jq -r '.s3_bucket')

	if [ $(ismounted) -eq 1 ] ; then
		log '{"status": "Success"}'
		exit 0
	fi

	mkdir -p ${MNTPATH} &> /dev/null
    mkdir -p ${MNTPATH}_passwd &> /dev/null

    echo ${S3_ACCESS_KEY}:${S3_ACCESS_SECRET} > ${MNTPATH}_passwd/.passwd-s3fs

	local S3FUSE_OPTS="_netdev,allow_other 0 0"

	s3fs ${S3_BUCKET} ${MNTPATH} -o passwd_file=${MNTPATH}/.passwd-s3fs  &> /dev/null
	if [ $? -ne 0 ]; then
		err "{ \"status\": \"Failure\", \"message\": \"Failed to mount s3 bucket ${S3_BUCKET} at ${MNTPATH}\"}"
		exit 1
	fi
	log '{"status": "Success"}'
	exit 0
}

unmount() {
	MNTPATH=$1
	if [ $(ismounted) -eq 0 ] ; then
		log '{"status": "Success"}'
		exit 0
	fi

	umount ${MNTPATH} &> /dev/null
	if [ $? -ne 0 ]; then
		err "{ \"status\": \"Failed\", \"message\": \"Failed to unmount volume at ${MNTPATH}\"}"
		exit 1
	fi
    rm -rf ${MNTPATH}_passwd

	log '{"status": "Success"}'
	exit 0
}

op=$1

if ! command -v jq >/dev/null 2>&1; then
	err "{ \"status\": \"Failure\", \"message\": \"'jq' binary not found. Please install jq package before using this driver\"}"
	exit 1
fi

if [ "$op" = "init" ]; then
	log '{"status": "Success", "capabilities": {"attach": false}}'
	exit 0
fi

if [ $# -lt 2 ]; then
	usage
fi

shift

case "$op" in
	mount)
		domount $*
		;;
	unmount)
		unmount $*
		;;
	*)
		log '{"status": "Not supported"}'
		exit 0
esac

exit 1