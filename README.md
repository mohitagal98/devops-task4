# Automated Web Server Deployment on Kubernetes through Slave Node on Jenkins
## Introduction-
In this article, I am going to show you how to deploy the web server on the kubernetes after binding the web pages into the docker image. And then roll out the deployment if there is any changes.
## Purpose-
1. Create container image that's has Linux and other basic configuration required to run Slave for Jenkins. ( example here we require kubectl to be configured )
2. When we launch the job it should automatically starts job on slave based on the label provided for dynamic approach.
3. Create a job chain of job1 & job2 using build pipeline plugin in Jenkins
4. Job1 : Pull the Github repo automatically when some developers push repo to Github and perform the following operations as:
a. Create the new image dynamically for the application and copy the application code into that corresponding docker image
b. Push that image to the docker hub (Public repository)
( Github code contain the application code and Dockerfile to create a new image )
5. Job2 ( Should be run on the dynamic slave of Jenkins configured with Kubernetes kubectl command): Launch the application on the top of Kubernetes cluster performing following operations:
a. If launching first time then create a deployment of the pod using the image created in the previous job. Else if deployment already exists then do rollout of the existing pod making zero downtime for the user.
b. If Application created first time, then Expose the application. Else don't expose it.
## Prerequisites:
Must possess basic knowledge of git, docker and kubernetes.
Jenkins, git and linux os must already be installed.

## Implementation
### Step:1 -Create docker image for dynamic slave**

Create Dockerfile for creating an image consisting linux as BaseOS with kubectl and all the configurations already there. See below image as reference:
![0](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/1.PNG)
This file solving this prerequisites for jenkins cloud:
1. Docker image must have sshd installed.
2. Docker image must have Java installed.
Log in details configured as per ssh-slaves plugin.

Get ca.crt, client.key and client.crt file from the .minikube folder in the home directory wherever the minikube is installed.

**config and ssh_config file:**
![1](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/2.PNG)
### Step:2 -Configure remote node where docker is installed
Edit /usr/lib/systemd/system/docker.service file to allow user from outside(jenkins in this case) to use docker at any random port say 4242.
![2](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/3.PNG)
Scroll through ExecStart and edit the same as above.
### Step:3 -Configure Jenkins Add Cloud details
In jenkins, Navigate to add cloud (Manage Jenkins > Manage Nodes and Clouds > Configure Clouds > Add A New Cloud ).
![3](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/4.PNG)
---

Give docker host URL, where IP is of your remote system where docker is installed and it must have connectivity with the same.
![4](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/5.PNG)
Add docker template and give details of the image built earlier. And also label which will be used in jobs later.
![5](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/6.PNG)
Provide login details like username and password set earlier in the Dockerfile.
### Step-4: Configure Jobs
**Job:1** -Job 1 to pull the Dockerfile(For web server) and web pages from github. Build image with the pages copied inside it and then push it to the Docker Hub.
Create Job -> Configure
![6](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/7.PNG)
Add URL of github repo where the dockerfile and codes are there.
![7](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/8.PNG)
Add Build Step- **Build/Publish Docker Image** and configure it as above. Give the cloud server, Docker Hub credentials and image name. This will look for Dockerfile in current directory.
**Job:2-** Configuring Job2 to create kubernetes deployment using the image uploaded on the Docker Hub.
![8](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/9.PNG)
Restricting Job to run on the cloud server. Kubessh is the tag of the template which is to be used to create the dynamic slave.
![9](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/10.PNG)
Add **Execute Shell** as a build step. And write the following kubernetes command to run inside it. This will create the deployment if not available or will roll out if already created to update the code.


---

## Setup Complete !!
Just need to push the dockerfile and code to the GitHub. See the sample files above.
Run the Jobs and visualize it using the build pipeline as follows:
![10](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/11.PNG)
To confirm:
![11](https://raw.githubusercontent.com/mohitagal98/devops-task4/master/images/12.PNG)
# Thank You !!
