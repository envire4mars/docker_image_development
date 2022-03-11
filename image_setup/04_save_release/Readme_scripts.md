## Preparation

You need to install Docker and (optional) Nvidia hardware graphics acceleration for Docker. See separate Readme_Docker.md file.

## Load Image Into Docker

Load the provided Docker image, to enable containers to run the functionality this package provides:

    docker load < <provided image.tar.gz file>

## Run Provided Commands in Docker Container

Unpack the provided scripts archive.

Run commands:

 * `./exec.bash` : Attach a new shell (bash) to the container
 * `./exec.bash hello_world` : An example entry for a custom start script
 * TODO: provide project-specific documentation for users of the package

You can activate autocompletion hints for `./exec.bash` scripts arguments by running

    $ source autocomplete.me
    $ ./exec.bash [double-tap tab key]

## Startscripts for CoRob-X:

Run the simulation setup:

    $ ./exec.bash 03_start_sim2.bash

To stop the simulation just press 'q' in the terminal. If something goes wrong
it might be necessary to stop the docker container (`./stop.bash`) and start from scratch.

Once the simulation is running, one can start a control example via:

    $ ./exec.bash 02_execute_controller_demo

The cameras can be accessed via vlc ('media->open network stream': `http://0.0.0.0:57781/video.mjpg` to `http://0.0.0.0:57784/video.mjpg`).

The demo controller can be found in the archive: "workspace/interaction/libraries/robot_remote_control/examples".

