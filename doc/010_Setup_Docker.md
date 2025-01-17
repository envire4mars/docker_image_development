### Docker CE

You need Docker > 19.03.

If this version of Docker is not already installed from the standard Ubuntu repositories you need to uninstall docker first. Step 5 is mandantory also if you use the ubuntu version.

Then you can install the latest Docker version as described here: https://docs.docker.com/engine/install/ubuntu/

You can copy paste the following steps or execute them all at once by using the install_docker.bash script in the tools directory:

1. Install curl (if not already done)
```bash
sudo apt install curl
```
1. Install the docker repository key: 
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
3. Install the repository:
```bash
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"
```
4. Update repositories and install docker_ce:
```bash
sudo apt update
sudo apt install docker-ce
```
5. Add your user to the docker group:

In order to be able to run docker commands without being root, you should add your user to the `docker` group (new login required to take effect).
```bash
sudo adduser $(id -un) docker
```

### NVIDIA Docker (2)

Then, you can proceed to install the NVIDIA Docker containers for 3d acceleration with access to (nvidia) graphics hardware.

Note: This requires to have the current NVIDIA driver installed, ubuntu is not updating major versions, check your 
package manager for the latest main package of the driver. When this document was written (30.11.2018) the latest version
in the standard ubuntu package repositories was: nvidia-driver-390. You can look for more recent drivers (higher numbers) via `apt search nvidia-driver-*`.

The following commands can be used to install the nvidia docker images. Original repository and installation instructions can be found
here: https://github.com/NVIDIA/nvidia-docker

```bash
# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt update && sudo apt install nvidia-docker2
sudo systemctl restart docker
```

If successful, you should be able to reproduce this command and receive a similar output (also see [here](https://github.com/NVIDIA/nvidia-docker#usage)):

    $ docker run --gpus all nvidia/cuda:10.0-base nvidia-smi
    Mon Aug 24 19:28:37 2020       
    +-----------------------------------------------------------------------------+
    | NVIDIA-SMI 440.100      Driver Version: 440.100      CUDA Version: 10.2     |
    |-------------------------------+----------------------+----------------------+
    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    |===============================+======================+======================|
    |   0  GeForce MX150       Off  | 00000000:01:00.0 Off |                  N/A |
    | N/A   46C    P3    N/A /  N/A |    474MiB /  2002MiB |     27%      Default |
    +-------------------------------+----------------------+----------------------+

    +-----------------------------------------------------------------------------+
    | Processes:                                                       GPU Memory |
    |  GPU       PID   Type   Process name                             Usage      |
    |=============================================================================|
    +-----------------------------------------------------------------------------+

IMPORTANT: In order to enable 3d acceleration, existing containers have to be re-created.

 * Stop running containers: `./stop.bash`
 * Clear container settings: `rm -f has_gpu_support.txt *-container_id.txt`
 * regenerate (and re-attach to) container: `./exec.bash`

### DNS Troubeshooting

Docker uses the DNS settigns of the host at container creation, if your system is not switching networks, DNS works just fine.

In case the host is swiching Networks and the DNS server changes, name resolution may fail in your container after switching (e.g. connecting to a new WIFI of en/disabling VPN Connections).

In this case, and if your host uses the "systemd-resolvd" (ubutnu > 18.04) you can set up dnsmasq to provide DNS name resolution on your host for your containers.

#### Install dnsmasq

* sudo apt install dnsmasq
* add the following content in the /etc/dnsmasq.d/docker.conf file
  ```
  interface=docker0
  bind-dynamic
  listen-address=172.17.0.1
  cache-size=0
  no-dhcp-interface=docker0
  ```
  * setting the cache size is important, as dnsmasq should only forward to systemd-resolvd
    * otherwise you'll have to restart dnsmasq after switching networks
* delete /etc/dnsmasq.d/ubuntu-fan as it sets bind-interfaces which is incompatible with bind-dynamic
* restart dnsmasq
  * sudo systemctl restart dnsmasq
* start dnsmasq on boot
  * sudo systemctl enable dnsmasq


#### provide dns setting to docker

As this DNS though dnsmasq and systemd-resolvd ist host-specific, you shouldn't add it to the settings.bash of this repo at all.

* edit/create /etc/docker/daemon.json
* add the DNS setting for your host
  * ```
    {
        "dns": ["172.17.0.1"]
    }
    ```
  * if there are other entries, make them "," seperated
* restart docker
  * sudo systemctl restart docker

**For these changes to take effect, you have to re-create your containers** (just call the delete_container.bash script)


### Restart and convenience 

In order to be able to run docker commands without being root, you should add your user to the `docker` group (requires new login to take effect).
```bash
sudo adduser $(id -un) docker
```

In order to make sure that the kernel modules are properly loaded, you should restart your computer. 

Now you are ready to use docker!

### Using a registry
If you want to use the image generated by the docker build from this repository, you can use the already build image from the registry server. A list of all available images can be found on [docker hub](https://hub.docker.com/u/developmentimage).

If you want to pull images from a private registry, you have to consider the following three prerequisites.

1. install the docker credential helper:
```bash
sudo apt install golang-docker-credential-helpers
```
(For ubuntu 16.04 and older this is not a package and has to be grabbed from https://github.com/docker/docker-credential-helpers/releases, install the bin in /usr/bin using the one containing "secretservice" in it's name.)

2. Set up docker to use the credential helper:
Open the file ~/.docker/config.json (or create it if it doesn't exist), and put the following content in it:
```json
{
        "credsStore": "secretservice"
}
```
3. Now login to the registry server:
```bash
docker login docker-reg.mydomain.de
```
Now you can pull images from the docker registry, e.g. by using docker pull.

The `settings.bash` file allows to set `DOCKER_REGISTRY_AUTOPULL` in order to automatically pull images, when `./exec.bash` is run.
