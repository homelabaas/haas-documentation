
# Walkthrough - Getting up and running

The guide will take you through the steps required to get productive with HaaS. This assumes you have HaaS up and running, connected to a database, along with Minio and vcenter.

## Prerequisites

The main prerequisite to get the VM builds and deployments working are as follows:

* Single VMWare Host with a Datastore
* The Ubuntu 18.04 installation ISO file uploaded to a datastore that the VMWare host can access.
* A range of IP addresses that you can use on you current network.

## Check Minio contents exist

The installation helper would have populated your minio installation with some initial content. Minio is automatically populated with these contents: <https://github.com/homelabaas/haas-content>. This can be browsed in two ways:

* Directly browse to Minio and log in with the test credentials. This is my default on port 9000, with the credentials __testaccesskey__ as the Access Key and __testsecretkey__ as the secret key.
* Inside of HaaS, you can navigate to Storage -> Files, and a built in file browser lets you also look at the contents of the Minio store.

Verify that files exist as expected before continuing.

## Build your base Ubuntu 18.04 machine

This step involves performing your first VM build, which will install Ubuntu 18.04 and patch it, using the ubuntu ISO file.

### Create a new Build Configuration

Navigate to Build -> Configs, then click on the New button.

The Build Definition dropdown is populated from the contents of the Minio store. If the Minio contents are correctly populated you should see a number of options on this dropdown. Select "Packer - Ubuntu 18.04 ISO Install".

Give the build config a name, such as "Ubuntu 18.04 Base", and the VM a name, such as "ubuntu1804-base".

Type in an SSH username and password, which will be your root user. Remember these credentials.

Leave the "Append Build Number ticked".

On the Host dropdown, select which VMWare host you would like to perform the build on. If the host is a member of a cluster that box will automatically populate. If it is not, leave it blank.

Select the datastore for that host which to store the VM on. The select the VM network.

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

Finally, from the "Template Build" dropdown, select Ubuntu 18.04 Base". This means this build takes the latest VM build from that configuration as the input.

Click Save.

### Run Docker machine build

Navigate to Build -> Configs. Click on "Ubuntu 18.04 Docker" and click "Run". You can now click on the build in the list below to follow the logs as the build progresses.

## Deploy a Docker Machine

Once you have a successful docker machine build, the next step is to provision a new VM with this build.

### Set up VM Sizes

Go to Compute -> VM Specs, and add a number of sizes that you will find useful. I tend to add a Tiny with 1CPU, 1 GB of RAM, Small with 1 CPU, 2 GB of RAM, Medium with 2 CPU, 4 GB of RAM and Large with 4 CPU, 8 GB of RAM.

### Set up a Network

This step sets up a number of IP addresses that can be allocated to new VMs as a pool. Note: DHCP is currently not supported.

Navigate to Network, then click New.

Enter in a name, I use "default", then the starting and ending IP range, along with subnet mask, gateway, and DNS server settings for each machine. Click Save.

Click Populate, and all the IP addresses in the range will appear with no VM associated.

### Deploy a VM

Now that you have some VM sizes and a network segment ready, you can create a VM. Navigate to Compute -> VMs. Click New VM.

Give the VM a name, select the spec from the dropdown, then the network from the network dropdown.

Under artifact, you will see all the built VMs. Pick the Ubuntu 18.04 Docker with the highest version. On the User Data dropdown, select Standard Docker Machine.

Once the user data dropdown is selected, the actual user data for the instance will appear in the text bow below for you to verify. If this is all good, click Create and wait while the VM is provisioned.

When it is ready, you will get immediate feedback in the UI.

## Deploy PowerDNS

The PowerDNS machine setup requires that you have built the base VM image with Docker. Using that base machine and some helper scripts, you can easily provision a machine that runs PowerDNS all set up for you, out of the box.

Once the Ubuntu docker machine is built, create a VM and in the user-data field, select PowerDNS.

It takes a little bit of time to install, the VM status will change to "Ready" when it is ready to use.

Say your PowerDNS server is on 10.0.0.1, browse to: http://10.0.0.1/setup.

In the Database Configuration, enter:
Database server Host: database
Username: root
Password: secretrootpassword
Database Name: pdnsadmin

Click Next

Enter in what details you would like for the Admin name, email address and password.

Enter the following fields:
Host master: authoritative
Port: 8081
Zone Path: api/v1/servers/localhost/zones
Protocol: http
Api Key: powerdnsapikey
Hostmaster record: testhostmaster

Click Next and now you can log into the admin console using the credentials you just provided.

## Hook up PowerDNS

Now we can tell HaaS where to find PowerDNS. Go to the Admin -> Settings page.

In the URL, say the IP address of your PowerDNS server is 10.0.0.1, type in: http://10.0.0.1:8081

The default API key is powerdnsapikey

It's up to you what domain name to use in "Default Domain". I have an internal domain name I like to use for all my VMs. This is the domain name they are all created in.

Click Save to check the connection works OK.

## Using PowerDNS

The last part is a bit tricky as it depends on your home setup, as you now want to make sure that your local network uses this PowerDNS server. There are a few ways you can do this.

The easiest way is to add the address of this server into your local DNS server settings. If you run your own DNS server, add it to the first forward zone.