# Quickstart of the Corob-X simulator

## Create access token to be able to load docker images:

- edit profile
- acess tokens
- select a name
- check read/write registry
- copy your token

$ docker login git.hb.dfki.de:5050 -u USER -p TOKEN

## Clone this repository 

First clone this repo if you haven't done it yet. Open a terminal and run this command to do so.

    $ git clone https://git.hb.dfki.de/corob-x/consortium/docker_image_development.git corob_x_docker_image_development

## Startscripts for CoRob-X

### Start the simulation

Open a new terminal, go to the folder where you cloned the repo, and run these two commands.

    $ cd corob_x_docker_image_development
    corob_x_docker_image_development $ source autocomplete.me
    corob_x_docker_image_development $ ./exec.bash start_sherpa_sim.bash

To stop the simulation just press 'q' in the terminal. If something goes wrong
it might be necessary to stop the docker container (`./stop.bash`) and start from scratch.

If everything starts fine, the simulation should look like this:

![](/doc/figures/MARS_simulation_start.png)

### Start a demo controller

Once the simulation is running, to start a controller that will connect to the running simulation and move the robot. This has to be done in a new terminal:

    corob_x_docker_image_development $ ./exec.bash execute_sherpa_controller_demo.bash

If things starts fine, then the simulated robot should reach this position after a while (and continue moving):

![](/doc/figures/MARS_simulation_rrc.png)
MARS_simulation_rrc

### Access the camera streams

The cameras can be accessed via vlc ('media->open network stream': `http://0.0.0.0:57781/video.mjpg` to `http://0.0.0.0:57784/video.mjpg`).

You can find more information about how to connect and process these video streams [here](http://wiki.ros.org/video_stream_opencv)

### Accessing the release container with exec.bash

It might be that you will at some point want to run some command directly on the release container or open a terminal session on it.

To start a terminal session on the container you can use:
```
    corob_x_docker_image_development $ ./exec.bash /bin/bash
```
`./exec.bash` without parameters defaults to /bin/bash, the parameter for exec can be any executable in the path. The startscripts are just added to the path in the container.


### Access the code of the controller

The demo controller can be found in the folder: "/opt/workspace/interaction/libraries/robot_remote_control/examples" of the released image.

Now you can access the folder to check the code using a terminal session on the release container or you can use a development environment which allows connections to running containers for example [this one](https://code.visualstudio.com/docs/remote/containers)

The repository in which this example is based is [robot_remote_control](https://github.com/dfki-ric/robot_remote_control). Partners can use the repo as starting point for the develpment of the API on their end.


## Notes:

  If there are problems with processes that are not shut down correctly after stopping the simulation, it is recommended to stop the docker container before restarting the application:

  $ ./stop.bash

# Docker Image Development 

This is a collection of scripts that enables a development process using docker images.

It was initiated and is currently developed at the
[Robotics Innovation Center](http://robotik.dfki-bremen.de/en/startpage.html) of the
[German Research Center for Artificial Intelligence (DFKI)](http://www.dfki.de) in Bremen,
together with the [Robotics Group](http://www.informatik.uni-bremen.de/robotik/index_en.php)
of the [University of Bremen](http://www.uni-bremen.de/en.html).

## Motivation

In robot development using several robots, there are sometimes different OS systems and software version used.
In oder to be able to develop for robots running on different OS version (e.g. Ubuntu 16.04 and 18.04) docker is a very useful tool, but not really intended to be used for development.

Also, there is a need in research projects to provide partners with runnable software, using this approach, runnable images can be created and sent to the partners without the need for them to install and set up other dependencies than docker.


These scripts are helping to set up a docker-based development and release workflow.

The goal is to prepare docker _images_ that encapsulate a component's or a project's dependencies so that work is being done in a consistent, reproducible environment, i.e., to prevent that code not only builds or runs on the developer's machine and fails elsewhere.
In order to achieve this, the **devel image** is created to contain all dependencies for the workspace preinstalled. The devel image mounts local directories into the container so they can be modified by editors on the host machine, while they are compiled and run in the container.

Devel images are usually based on **base images**, that encapsulate dependencies shared by many projects.
The build process will automatically try to pull required images from a docker registry.
If the image is already available locally, it doesn't need to be pulled again.

Another goal of this approach is to be able to preserve a working version of a component, a project or a demo and possibly ship it to external partners.
In order to achieve this, the **release image** can be created, which contains the devel image plus the additional workspace files and run scripts required to operate the product.

![process overview](/doc/docker_development_image.png?raw=true "process overview")



## Getting Started

Please read the [usage howto](doc/020_Usage.md)

## Requirements / Dependencies

You need docker installed and usable for your user.
If 3D accelleration is needed, nvidia-docker can be utilized.

Please read the [docker howto](doc/010_Setup_Docker.md)

## Installation

Just fork/clone this repository.

A fork can be used to store your settings and share them with the developers of your project.

## Documentation

The Documentation is available in the doc folder of this repository.

## Current State

This software is stable and maintained by the authors.

## Bug Reports

To search for bugs or report them, please use GitHubs issue tracker at:

http://github.com/dfki-ric/docker_image_development


## Referencing

Please reference the github page: http://github.com/dfki-ric/docker_image_development

## Releases

We use semantic versioning: See [VERSION](VERSION) file

### Semantic Versioning

Semantic versioning is used.

(The major version number will be incremented when the API changes in a backwards incompatible way, the minor
version will be incremented when new functionality is added in a backwards compatible manner, and the patch version is incremented for bugfixes, documentation, etc.)

## License

See [LICENSE](LICENSE) file.

## Maintainer / Authors / Contributers

Maintainer: Steffen Planthaber

Authors:

* Steffen Planthaber
* Leon Danter

Contributors:

* Elmar Berghöfer
* Fabian Maas
* Tom Creutz
* Raul Dominguez
* Bojan Kocev
* Christian Koch
* Leif Christensen

Copyright 2020, DFKI GmbH / Robotics Innovation Center, University of Bremen / Robotics Research Group
