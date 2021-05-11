# minio-flex-volume
This repo is mainly aimed at publishing reliable s3 flex volume driver volume plugin in Kubernetes.

# Prerequisite

* s3fuse installed in each kubernetes nodes ([s3fuse installation guidance](https://github.com/s3fs-fuse/s3fs-fuse))


# workflow
The docker build workflow will triggered when each branch name after `release` is newly created.

This repo will publish usable minio flex volume distribution docker [here](https://hub.docker.com/r/datavocals/minio-flex-volume-distro/tags?page=1&ordering=last_updated)
