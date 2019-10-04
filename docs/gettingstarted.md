# Getting Started

## Prerequisites

To run HaaS, you just need a machine that can run docker. This includes Docker for Mac, Docker for Windows or a Linux machine running docker.

To use HaaS, you will need VMware VCenter as the target hypervisor.

## Installing HaaS

To start up the installation application, run:

```text
docker run -v /var/run/docker.sock:/var/run/docker.sock -p 3010:3010 homelabaas/haas-bootstrap
```

Once the container is up and running, browse to <http://localhost:3010> and step through the installation steps.

The bootstrap application should start up the correct containers and get you up and running with a basic setup. This will start 3 containers for you:

* The HaaS Application itself (homelabaas/haas-application)
* Minio (minio/minio)
* Postgres (postgres)

Minio is used as a central store for files throughout the application, and sample files will be copied from <https://github.com/homelabaas/haas-content> into the Minio store as part of the installation procedure. These files are a great place to start.

Postgres is the database used, which will be automatically populated when the application starts.

## Check Hass

Browse to the IP address of where you installed HaaS, on port 3000. You will notice a message that states "Warning. It seems not all the dependencies for this application are configured. Click here to proceed to the setup screen. The status page will tell you what's not connected."

If you click on Admin -> Status, you can see that only Postgres and Docker are connected.

We now want to connect VCenter and Minio. PowerDNS can come later as this requires setting
up a PowerDNS server.

## Configure HaaS

Navigate to the Admin -> Settings page. Here you can configure 3 important items.

### Set Application URL

The first is the URL of __this__ application. This is required so that your VM's know what URL to hit, when calling back to this application. Use the IP address of the machine its running on, on port 3000.

For example, if your machine's IP is 10.0.0.1, use `http://10.0.0.1:3000`. Click __Save__.

### Connect to vcenter

Enter in the vcenter details. The URL is just the IP or domain name of the server, such as `my.vmware.com` or `10.0.0.10`. You can enter in a folder, which is a VMWare folder where all the virtual machines will be placed when automation tasks are run. Click __Connect__ and the settings will be valiated, and HaaS will connect to vcenter.

### Connect to Minio

Configure the application to connect to Minio, by entering in a url. If you are using the bootstrap application, you can enter in your local IP, such as: `http://10.0.0.10:9000` with __testaccesskey__ as the Access Key and __testsecretkey__ as the secret key. The Content Bucket is called __content__ by default.

### Connect to MiniDNS (optional)

This is optional, and you will probably set this up later as this requires a running MiniDNS server. Once connected, this will automatically manage your DNS. You will need to provide the API endpoint of MiniDNS to interact with, plus it's IP address for use with network configuration services.

## Next Steps

Now that you have configured the main items (excepting PowerDNS), continue to the [Walkthrough](walkthrough.md) section to get up and running.
