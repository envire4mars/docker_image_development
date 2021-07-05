To create the container where development is possible, we need first a `base image` and then a `devel image`. The `devel image` is built on top of the `base image` and from the `devel image` we can generate the `development container`.

## Generate the Base Image

If you have access to the dfki docker registry, you can skip this step.
If you don't have access to the DFKI docker registry, then you will have to generate locally on your machine the image:

1. Modify `settings.bash` file, to set these variables blank as shown below:
```
export DOCKER_REGISTRY=
export BASE_REGISTRY=
```
 
2. Go to `image_setup/01_base_images`
3. Run 
```bash
bash build_rock_master_18.04.bash
```

If no errors are prompted then the image has been generated, you can check it by running `docker images`. The following entry should be present:
```
REPOSITORY                                                       TAG                           IMAGE ID       CREATED        SIZE
d-reg.hb.dfki.de/developmentimage/rock_master_18.04              base                          40eafcf6b45d   3 days ago     2.1GB
```

## Generate the Devel Image
If you have access to the dfki docker registry, you can skip this step.
If you don't have access to the DFKI docker registry, then you will have to generate locally on your machine the image:

1. Modify `settings.bash` file, to set these variables blank as shown below:
```
export DOCKER_REGISTRY= 
export BASE_REGISTRY=
```
 
2. Go to `image_setup/02_devel_images`
3. Run 
```bash
bash build.bash
```



## Generate the Devel Container

You will be asked for your user and password for the DFKI repos, since some are needed for this intallation.

0. Go to the root folder of this repo
0. Run
```bash
bash exec.bash devel
```