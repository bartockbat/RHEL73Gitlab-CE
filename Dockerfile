FROM registry.access.redhat.com/rhel7.3:latest 

MAINTAINER Redhat Inc. connect@redhat.com


# Many of the commented out lines below were included in the Gitlab-CE Dockerfile. I left them in case they were needed
#RUN  yum -y install curl policycoreutils openssh-server openssh-clients

RUN  yum -y install curl policycoreutils

#RUN  systemctl enable sshd
#RUN  systemctl start sshd
RUN  yum -y install postfix

#RUN  systemctl enable postfix
#RUN  systemctl start postfix
#RUN  firewall-cmd --permanent --add-service=http
#RUN  systemctl reload firewalld

#Copy the help file - atomic helps - satisfy the scanner requirements
COPY help.1 /
RUN mkdir /licenses
COPY license /licenses

#This seemed to be error prone - I just grabbed the RPM and installed it with a yum local install
#RUN curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh 

RUN curl -LJO https://packages.gitlab.com/gitlab/gitlab-ce/packages/el/7/gitlab-ce-8.13.1-ce.0.el7.x86_64.rpm/download

RUN yum -y install gitlab-ce-8.13.1-ce.0.el7.x86_64.rpm 

#Copy config file - I borrowed this from the Ubuntu based image
RUN mv /etc/gitlab/gitlab.rb /etc/gitlab/gitlab.rb.orig

#Finish copying config file
COPY gitlab.rb /etc/gitlab/gitlab.rb
RUN mkdir -p /assets
COPY wrapper /assets

# Expose web & ssh
EXPOSE 443 80 22


#Clean up container - it's still huge - needs to be flattened
RUN rm -rf gitlab-ce-9.3.5-ce.0.el7.x86_64.rpm
RUN yum clean all

# The wrapper script - I borrowed this from the Ubuntu based Docker imaage - it's there in case it's usable with RHEL
#Run setup
#CMD gitlab-ctl reconfigure
#CMD ["/assets/wrapper"] 
