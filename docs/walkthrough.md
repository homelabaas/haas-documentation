
# Walkthrough - Getting up and running

The guide will take you through the steps required to get productive with HaaS. This assumes you have HaaS up and running, connected to a database, along with Minio and vcenter.

## Prerequisites

The main prerequisite to get the VM builds and deployments working are as follows:

* Single VMWare Host with a Datastore
* The Ubuntu 18.04 installation ISO file uploaded to a datastore that the VMWare host can access.
* A range of IP addresses that you can use on you current network.

## Check Minio contents exist

The installation helper would have populated your minio installation with some initial content. Minio is automatically populated with these contents: <https://github.com/homelabaas/haas-content>. This can be browsed in two ways:

* Directly browse to Minio and log in with the test credentials. This is by default on port 9000, with the credentials __testaccesskey__ as the Access Key and __testsecretkey__ as the secret key.
* From the HaaS application, you can navigate to Storage -> Files, and a built in file browser lets you also look at the contents of the Minio store.

Verify that files exist as expected before continuing.

## Build your base Ubuntu 18.04 machine

This step involves performing your first VM build, which will automatically install Ubuntu 18.04 and patch it, using the ubuntu ISO file.

### Create a new Build Configuration

Navigate to Build -> Configs, then click on the New button.

The Build Definition dropdown is populated from the contents of the Minio store. If the Minio contents are correctly populated you should see a number of options on this dropdown. Select "Packer - Ubuntu 18.04 ISO Install".

Give the build config a name, such as "Ubuntu 18.04 Base", and the VM a name, such as "ubuntu1804-base".

Type in an SSH username and password, which will be your root user. Remember these credentials.

Leave the "Append Build Number" ticked.

On the Host dropdown, select which VMWare host you would like to perform the build on. If the host is a member of a cluster that box will automatically populate. If it is not, leave it blank.

Select the datastore for that host which to store the VM on. Then select the VM network.

Last but not least, select the datastore which the ISO file resides on. The file dropdown will automatically populate with all the .ISO files inside that datastore for you. Select the Ubuntu 18.04 ISO file from this dropdown.

Now Select Save.

### Perform a base machine build

Select Build -> Configs, then click on "Ubuntu 18.04 Base". From that screen click Run. The VM build will now start.

You can click on the build to watch the logs as the build progresses. When the build is finished, it should read "Completed Successfully".

## Build your Docker machine

The next step is to take the output of the base VM build, and add Docker on top. This is done separately to speed up the docker server builds, as the installation from ISO can be quite slow.

### Create Docker Build Configuration

Navigate to Build -> Configs and select New.

Same as before, give the build config a name such as "Ubuntu 18.04 Docker" and a VM name of "ubuntu1804docker".

Use the same SSH username and password. __Note: If they don't match the base build, this will fail.__

Keep Append build number ticked.

Select the VM Host and datastore to store the VM on, and the VM network.

Finally, from the "Template Build" dropdown, select "Ubuntu 18.04 Base". This means this build takes the latest VM build from that configuration as the input.

Click Save.

### Run Docker machine build

Navigate to Build -> Configs. Click on "Ubuntu 18.04 Docker" and click "Run". You can now click on the build in the list below to follow the logs as the build progresses.

## Deploy a Docker Machine

Once you have a successful docker machine build, the next step is to provision a new VM with this build. Before you provision a new virtual machine, you will need to create some VM sizes, and a network.

### Set up VM Sizes

Go to Compute -> VM Specs, and add a number of sizes that you will find useful. I tend to add a Tiny with 1 CPU, 1 GB of RAM, Small with 1 CPU, 2 GB of RAM, Medium with 2 CPU, 4 GB of RAM and Large with 4 CPU, 8 GB of RAM. These sizes are entirely up to you.

### Set up a Network

This step sets up a number of IP addresses that can be allocated to new VMs as a pool. Note: DHCP is currently not supported in HaaS, instead, IP addresses are allocated from a static pool.

Navigate to Network, then click New.

Enter in a name, I use "default" since I only ever have one of these defined, then enter a starting IP and ending IP range, along with subnet mask, gateway, and DNS server settings for each machine. Click Save.

Click Populate, and all the IP addresses in the range will appear with no VM associated.

### Deploy a VM

Now that you have some VM sizes and a network segment ready, you can create a VM. Navigate to Compute -> VMs. Click New VM.

Give the VM a name, select the spec from the dropdown, then the network from the network dropdown.

Under artifact, you will see all the built VMs. Pick the Ubuntu 18.04 Docker with the highest version. On the User Data dropdown, select Standard Docker Machine.

Once the user data dropdown is selected, the actual user data for the instance will appear in the text bow below for you to verify. If this is all good, click Create and wait while the VM is provisioned.

When it is ready, you will get immediate feedback in the UI.

## Deploy MiniDNS

Mini DNS is very simple to run, just start a machine up and run the `homelabaas/dns-api` container, exposing the correct ports.

There is a User Data selection built into Homelab as a Service that will create a docker machine and install Mini DNS for you. Create a new VM and select "Mini DNS" in the "User Data" dropdown.

## Hook up MiniDNS

Now we can tell HaaS where to find Mini DNS. Go to the Admin -> Settings page.

Say Mini DNS is running on a sever with the IP address of 10.0.0.1.

In the URL, enter the HTTP address of the API that controles Mini DNS. Using the IP address above, it would be: `http://10.0.0.1/api`.

For the DNS IP Address, just type in it's IP address, ie `10.0.0.1`.

For the default domain, enter in a domain name you want all your machines to be added to, for example, `myprivatedomain.com`.

## Using MiniDNS

You will now need to tell your servers to point to Mini DNS for all DNS resolution. Ensure the DNS name server on all machines is the IP address of the Mini DNS server.
