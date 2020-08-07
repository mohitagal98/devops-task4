FROM centos
RUN yum install httpd -y
RUN yum update -y
RUN yum install php -y

EXPOSE 80
#RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

COPY ./website  /var/www/html

CMD /usr/sbin/httpd -DFOREGROUND
