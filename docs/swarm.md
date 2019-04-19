# Docker Swarm

The walkthrough dealt with a simple case of building and deploying virtual machines. One more advanced feature of HaaS, is the ability to create groups of machines, which can tie into a single "Environment".

## The Scaling Group

A scaling group is a collection of virtual machines that are configured the same way, which are easy to scale up and down on demand.

An example of a good use of a scaling group is a collection of worker nodes for containers.

## The Environment

An environment is a collection of Scaling Groups, which will be provisioned in order.

## Install a Docker Swarm

With a docker swarm, you want to create a number of master nodes, then a number of workder nodes. It is a single environment, that has two scaling groups.