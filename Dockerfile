FROM centos

#installing and configuring kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl


RUN chmod +x ./kubectl
RUN mv kubectl /usr/bin
RUN mkdir /root/.kube
COPY config  /root/.kube/
COPY ca.crt /root/
COPY client.key /root/
COPY client.crt /root/


#installing java
RUN yum install java -y

#Installing openssh-server 
RUN yum -y install openssh-server
RUN mkdir /root/jenkins_node
RUN ssh-keygen -A
COPY ssh_config /etc/ssh/ssh_config
RUN echo "root:mohit" | chpasswd


CMD ["/usr/sbin/sshd","-D"] && /bin/bash
