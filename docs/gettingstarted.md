# Getting Started

## Prerequisites

You just need a machine that can run docker. This includes Docker for Mac, Docker for Windows or a Linux machine running docker.

## Setting up HaaS

The bootstrap application should start up the correct containers and get you up and running with a basic setup. This will start 3 containers for you:

* The HaaS Application itself (homelabaas/haas-application)
* Minio (minio/minio)
* Postgres (postgres)

Minio is used as a central store for files throughout the application. Postgres is the database used.

## Configure HaaS

### Set Application URL

Navigate to the Admin -> Settings page. Here you can configure 3 important items. The first is the URL of this application. This is required so that your VM's know what URL to hit, when calling back to this application. Use the IP address of the machine its running on, on port 3000. For example, if your machine's IP is 10.0.0.1, use `http://10.0.0.1:3000`. Click __Save__.

### Connect to vcenter

Enter in the vcenter details. The URL is just the IP or domain name of the server, such as `my.vmware.com` or `10.0.0.10`. You can enter in a folder, which is where all the virtual machines will be placed when automation tasks are run. Click __Connect__ and the settings will be valiated, and HaaS will connect to vcenter.

### Connect to PowerDNS

The last setting is optional, and you will probably set this up later. This is to provide integration with Power DNS for DNS automation. To set this up, type in the url of the Power DNS API, such as `http://10.0.0.15:8081`. The the API key, and then the domain name that you want all your entries to be stored under.

### Connect to Minio

Setup Minio settings.

## HaaS usage: First Steps

First step is to put some content into Minio to use with the application. Clone the following repo: https://github.com/homelabaas/haas-content and copy it into the build bucker in minio.

Second step is to get some VMs building. You can use the `/packer/ubuntu1804iso/` contents, named "Ubuntu 18.04 ISO Install", to create a base Ubuntu box, against the VMWare host, network and datastore of your choice.

Once this is built, you can use the output of that build to feed into the builder "Ubuntu 18.04 Docker" which creates a VM template which has docker installed, but also cloud-init. The means you can provision this box with the "Provision" screen as it will accept a cloud-init file for boot time configuration.

When you create a new machine from the output of the "Ubuntu 18.04 Docker" box, select the "Standard Docker Machine" user data file and load it, to create a new VM.

From one of these machines, you can then deploy straight docker containers. Use one of these machines and the docker-compose file in `/deployment-compose/powerdns/docker-compose.yml` to create a PowerDNS box.

For a docker swarm environment, use the environment provision screen and paste in the contents of `/environments/docker-swarm/environment.yaml`. Make sure the IP address settings are fine. This will provision a collection of servers, with a master and worker nodes, running as a swarm.
