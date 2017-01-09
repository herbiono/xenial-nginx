FROM ubuntu:xenial

MAINTAINER Uchup Herbie <herbiono@gmail.com>

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

#install nginx
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
	echo "deb http://nginx.org/packages/mainline/ubuntu/ xenial nginx" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get install -y \
			ca-certificates \
			nginx \
			nginx-module-xslt \
			nginx-module-geoip \
			nginx-module-image-filter \
			nginx-module-perl \
			nginx-module-njs \
			gettext-base && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get -y autoremove && apt-get clean

VOLUME ["/etc/nginx", "/var/log/nginx"]

#forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
	ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]