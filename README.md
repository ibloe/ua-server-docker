### Raspbian (latest is stretch) with SSH, Node-RED, OPC-UA and user pi

Base of this image builds a tagged version of [debian:stretch](https://hub.docker.com/r/resin/armv7hf-debian/tags/) with enabled [SSH](https://en.wikipedia.org/wiki/Secure_Shell), created user 'pi' and preinstalled packages of a headless Raspbian lite.

#### Container prerequisites

##### Port mapping

For remote login to the container across SSH the container's SSH port `22` needs to be mapped to any free host port.
`1880` for Node-RED
`4840` for OPC-UA

##### Hostname 

A Raspberry Pi has the default hostname `raspberrypi`. For equal conditions set the container's hostname to the same string.

#### Getting started

STEP 1. Open [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 2. Enter the following parameters under **Containers > Add Container**

* **Image**: `ibloe/ua-server-docker`

* **Network > Network**: `host`

* **Port mapping**: `Host "22, 1880, 4840" (any unused one) -> Container "22, 1880, 4840"` 

* **Restart policy** : `always`

STEP 4. Press the button **Actions > Start container**

Pulling the image may take a while (5-10mins). Sometimes it takes so long that a time out is indicated. In this case repeat the **Actions > Start container** action.

#### Accessing

The container starts the SSH server automatically. Open a terminal connection to it with an SSH client such as [putty](http://www.putty.org/) using netPI's IP address at your mapped port.

As with a Raspberry Pi use the default credentials `pi` as user and `raspberry` as password when asked and you are logged in as non-root user `pi`.

Continue to use [Linux commands](https://www.raspberrypi.org/documentation/linux/usage/commands.md) in the terminal as usual.

#### Tags

* **ibloe/opc-ua:latest** - non-tagged latest development output of the GitHub project master branch.

#### GitHub sources
The image is built from the GitHub project [OPC-UA](https://github.com/ibloe/OPC-UA). It complies with the [Dockerfile](https://docs.docker.com/engine/reference/builder/) method to build a Docker image [automated](https://docs.docker.com/docker-hub/builds/).

Hint: Cross-building the image for an ARM architecture based CPU on [Docker Hub](https://hub.docker.com/)(x86 CPU based servers) the Dockerfile uses the method described here [resin.io](https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/). If you want to build the image on a Raspberry Pi directly then comment out the two lines `RUN [ "cross-build-start" ]` and `RUN [ "cross-build-end" ]` in the file Dockerfile before.
