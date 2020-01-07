# sv_calling_docker
This repository contains a dockerfile and build script to make a container for SV calling from WG(B)S

### Why a Docker container?

The main goal of building this container is simplify the dependency requirements to jointly call SVs
from WGS and WGBS using either BWA or BISCUIT, respectively.

BISCUIT: [https://github.com/huishenlab/biscuit!](https://github.com/huishenlab/biscuit)

### Building a new container

To build a container, you need to have Docker installed (which requires one to have root access)

Clone the repo:

```
git clone https://github.com/huishenlab/sv_calling_docker.git
```

Modify and ***document*** version changes to software if needed in the Dockerfile or docker-build.sh.
Ideally, documenting any changes should be done in the NEWS.md since it is effectively a new release.

(Re)build the container:

```
docker build --no-cache -t huishenlab:sv_calling
```

Push it onto dockerhub:

Generate an access token from the huishenlab dockerhub.

Login to docker using the access token:

```
docker login --username huishenlab
```

You'll now be prompted for a password:

```
Password: your_access_token_goes_here
```

Now tag and push it:

```
# Tag the release
docker tag huishenlab:sv_calling huishenlab/sv_calling:sv_calling_new_version

# Push
docker push huishenlab/sv_calling:sv_calling_new_version
```
