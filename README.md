# Docker powered NAS/Mediacenter

[![N|OMV](https://img.shields.io/badge/OpenMediaVault-4.1.21--1-blue.svg)](https://www.openmediavault.org/)
[![N|Docker](https://img.shields.io/badge/Docker-18.09.4-blue.svg)](https://www.docker.com/)

OMV combined with docker makes for a fearce nas/home mediacenter setup, OMV web panel provides host level access to various features like network sharing, raid management, user/group control, and much more, with docker making it super easy to deploy basically any app.  
  
I am a docker enthusiast and constantly learning but by no means an expert.

#### Brief overview of repo contents
- ##### docker-compose.yml
    - contains all the apps that makeup the media center
- ##### sample.env
    - contains as the name states a SAMPLE of all the environment variables you will need to change to suit your needs
- ##### config folder
    - there is a script to modify omv to be compatible with iframes
    - ovpn folder contains nordvpn (my vpn provider) server information and certs that openvpn requires
    - nginx.tmpl is the reverse-proxy config file

#### Container list

List of docker containers active and inactive that makeup the docker-compose.yml  
Shoutout to everyone envolved in making & maintaining these containers

| Active | DockerHub |
| ------ | ------ |
| nginx | https://hub.docker.com/_/nginx |
| jwilder/docker-gen | https://hub.docker.com/r/jwilder/docker-gen/ |
| jrcs/letsencrypt-nginx-proxy-companion | https://hub.docker.com/r/jrcs/letsencrypt-nginx-proxy-companion |
| emby/embyserver | https://hub.docker.com/r/emby/embyserver |
| linuxserver/airsonic | https://hub.docker.com/r/linuxserver/airsonic |
| linuxserver/ombi | https://hub.docker.com/r/linuxserver/ombi |
| organizrtools/organizr-v2 | https://hub.docker.com/r/organizrtools/organizr-v2 |
| qoomon/docker-host | https://hub.docker.com/r/qoomon/docker-host |
| linuxserver/sonarr:preview | https://hub.docker.com/r/linuxserver/sonarr |
| lsiodev/radarr:nightly | https://hub.docker.com/r/lsiodev/radarr |
| linuxserver/headphones | https://hub.docker.com/r/linuxserver/headphones |
| linuxserver/jackett | https://hub.docker.com/r/linuxserver/jackett |
| binhex/arch-delugevpn | https://hub.docker.com/r/binhex/arch-delugevpn |
| linuxserver/nzbget:testing | https://hub.docker.com/r/linuxserver/nzbget |
| linuxserver/duplicati | https://hub.docker.com/r/linuxserver/duplicati |
| linuxserver/ddclient | https://hub.docker.com/r/linuxserver/ddclient |
| portainer/portainer | https://hub.docker.com/r/portainer/portainer |
| v2tec/watchtower | https://hub.docker.com/r/v2tec/watchtower |

| Inactive | DockerHub |
| ------ | ------ |
| binhex/arch-jellyfin | https://hub.docker.com/r/binhex/arch-jellyfin |
| linuxserver/lidarr | https://hub.docker.com/r/linuxserver/lidarr |
| haugene/transmission-openvpn | https://hub.docker.com/r/haugene/transmission-openvpn |
| jshridha/docker-nzbgetvpn:latest | https://hub.docker.com/r/jshridha/docker-nzbgetvpn |
| grafana/grafana | https://hub.docker.com/r/grafana/grafana |

### Todos

 - Finish this README.md
 - Switch to traefik reverse proxy
 - Find more apps to use
 - ~~ Migrate /config mounts to docker volumes ~~

# Prerequisites
- A computer with [openmediavault](https://www.openmediavault.org/) installed onto its own harddrive, preferrably a fresh install of omv (I do not care much if boot drive fails as I don't mind if there would be downtime to reinstall os as I have backups for omv config just install os and restore, if zero downtime is a necessity you likely dont need to use my repo.)
    - It is possible to use one harddrive/ssd for omv & the download location, omv by default does not allow you through the web panel create a filesystem on the operating system partition, for this to work you have to run a rescue instance ie: Gparted live to shrink the omv os partition and create a seperate partition for your download/docker filesystem (this is how I started I eventually bought a seperate smaller ssd for boot drive, just google a how-to if this is the route you choose)

- [Docker](https://docs.docker.com/install/linux/docker-ce/debian/) & [docker-compose](https://linuxize.com/post/how-to-install-and-use-docker-compose-on-debian-9/) installed on the machine running openmediavault

- To take advantage of the speed that usenet offers i would HIGHLY recommend you have a SSD dedicated to docker & download directory for torrent/usenet clients (IF YOU ARE CHOOSING TO DOWNLOAD TO A PLATTER TYPE HARDDRIVE YOU WILL ONLY GET ABOUT 25Mb/s down, spend the better portion of your weekend wondering why reddit users are reporting upwards of 100Mb/s down and your 1Gbps expensive internet package is not..... your welcome :thumbsup: )

- Setup and mount your raid array and filesystems (obviously), again google an omv raid tutorial
    - To share some insite I have one ssd BOOT drive for omv itself, another larger ssd for docker install & download location (i also have my home dir mounted to a location on this ssd, I wanted to keep my omv boot drive as clean as possible) and a RAID 6 ext4 filesystem for the media content to be stored on, it currently consists of 5 4TB WD RED's, gives me 12TB storage plus double parity for 2 disk failure redundancy (FYI they are dirt cheap on amazon $129CAD-$149CAD (at the time of writing this) with prime shipping https://www.amazon.ca/gp/product/B00EHBERSE/ref=ppx_yo_dt_b_asin_title_o01_s01?ie=UTF8&psc=1) 

- For letsencrypt to work you will need to own your own domain ie: example.com, I am with godaddy and ive forwarded my domain to cloudflare to take advantage of ddclient
    - Please note from this point forward it is assumed your domain is controlled using cloudflare, its fast, free & feature rich so why not

- You will want to change your IP address for your omv host to a static IP, I am not going to go over how to do this, but you should add a dhcp reservation for the IP address of your choice in your router aswell

- In your router settings you will need to forward ports TCP 80, TCP 443, TCP 22, TCP/UDP 8096, TCP 58946, TCP 6789 to your newly assigned static ip address from your omv host

- Confirm if openssh-server is installed & enabled on your omv host by going to your omv webpanel Diagnostics/Dashboard there will be a services box with SSH service and 2 green dots for enabled/running
    - If memory serves ssh should be installed and enabled by default I could be wrong its been a long time
    - If you do not see both green dots then go to Services/SSH and enable and configure ssh settings

#### Getting Started
##### You will need to ssh to your omv host to run the following commands
- Clone this repository to the omv host
    ```sh
    $ git clone https://github.com/shanehughes1990/docker_mediacenter.git ~/docker_mediacenter && cd ~/docker_mediacenter
    ```

- Make a copy of sample.env in the repository directory
    ```sh
    $ cp sample.env .env
    ```
- Change the environment variables in .env to fit your needs
    ```sh
    $ nano .env
    ```
    - Once your done changing the variables press ctrl+o enter ctrl+x to save and exit file

- Make a copy of sample.traefik.toml in the repository directory
    ```sh
    $ cp sample.traefik.toml config/traefik.toml
    ```
- Change the environment variables in traefik.toml to fit your needs
    ```sh
    $ nano config/traefik.toml
    ```
    - Once your done changing the variables press ctrl+o enter ctrl+x to save and exit file

- Create a user & group for your mediacenter apps to use, I made one without a home directory as it's not needed
    - The -M creates user without the home directory 
    - The -S specifies what shell the user will use, in this case the user mediacenter does not have ssh permission
    ```sh
    $ sudo groupadd mediacenter
    $ sudo useradd -M -s /sbin/nologin mediacenter
    $ sudo usermod -aG mediacenter mediacenter
    ```
- You will need to change to port the omv runs from as port 80 will be occupied by your reverse proxy
    - Open your omv web panel and go to System/General Settings and change port from 80 to something else I am using 8443, Press save and a reload notification will popup, press that aswell, from the time being you can access your omv instance at http://hostip:8443, we will be routing this through our reverse proxy later

- This should be everything you need prior to deploying the docker media center  

**Free Software, Hell Yeah!**
