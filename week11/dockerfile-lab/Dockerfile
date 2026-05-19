FROM rockylinux:8

LABEL maintainer="sinbumu"
LABEL description="week11 Dockerfile lab: simple Apache httpd image"

RUN dnf -y install httpd && dnf clean all
RUN echo "Hello from week11 Dockerfile lab" > /var/www/html/index.html

EXPOSE 80 443

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
