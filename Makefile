# export common environment variables
DOCKER_REGISTRY_USERNAME = $(or $(shell printenv DOCKER_REGISTRY_USERNAME), )
DOCKER_REGISTRY_PASSWORD = $(or $(shell printenv DOCKER_REGISTRY_PASSWORD), )
DOCKER_REGISTRY = $(or $(shell printenv DOCKER_REGISTRY), datavocals)
GIT_BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_IMAGE_TAG = $(DOCKER_REGISTRY)/minio:$(GIT_BRANCH)


# https://www.gnu.org/software/make/manual/make.html#index-_002eEXPORT_005fALL_005fVARIABLES
.EXPORT_ALL_VARIABLES:
export DOCKER_REGISTRY

# remove the PHONY no longer needed
.PHONY: all
all: docker-login docker-build

.PHONY: docker-login
docker-login:
	docker login --username=$(DOCKER_REGISTRY_USERNAME)  --password=$(DOCKER_REGISTRY_PASSWORD)

.PHONY: docker-build
docker-build-spark: dockerfile/minio-flex-volume-distro-dockerfile
	docker build \
		--iidfile .minio-imageid
		-f dockerfile/minio-flex-volume-distro-dockerfile \
		.
	docker tag $(cat .minio-imageid) $(DOCKER_IMAGE_TAG)
