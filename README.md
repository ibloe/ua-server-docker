### Raspbian OPC-UA and user pi

Base of this image builds a tagged version of [debian:stretch](https://hub.docker.com/r/resin/armv7hf-debian/tags/) with enabled [SSH](https://en.wikipedia.org/wiki/Secure_Shell), created user 'pi' and preinstalled packages of a headless Raspbian lite.

#### Getting started

STEP 1. Open [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 2. Enter the following parameters under **Containers > Add Container**

* **Image**: `ibloe/ua-server-docker:latest`

* **Network > Network**: `host`

* **Restart policy** : `always`

STEP 4. Press the button **Actions > Start container**

Pulling the image may take a while (5-10mins). Sometimes it takes so long that a time out is indicated. In this case repeat the **Actions > Start container** action.

#### Accessing

The container starts the SSH server automatically. Open a terminal connection to it with an SSH client such as [putty](http://www.putty.org/) using netPI's IP address at your mapped port.

As with a Raspberry Pi use the default credentials `pi` as user and `raspberry` as password when asked and you are logged in as non-root user `pi`.

Continue to use [Linux commands](https://www.raspberrypi.org/documentation/linux/usage/commands.md) in the terminal as usual.

#### Tags

* **ibloe/ua-server-docker:latest** - non-tagged latest development output of the GitHub project master branch.

#### GitHub sources
The image is built from the GitHub project [ua-server-docker](https://github.com/ibloe/ua-server-docker). It complies with the [Dockerfile](https://docs.docker.com/engine/reference/builder/) method to build a Docker image [automated](https://docs.docker.com/docker-hub/builds/).

Hint: Cross-building the image for an ARM architecture based CPU on [Docker Hub](https://hub.docker.com/)(x86 CPU based servers) the Dockerfile uses the method described here [resin.io](https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/). If you want to build the image on a Raspberry Pi directly then comment out the two lines `RUN [ "cross-build-start" ]` and `RUN [ "cross-build-end" ]` in the file Dockerfile before.