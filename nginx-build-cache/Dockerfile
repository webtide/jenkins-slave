FROM nginx:1.23.4

MAINTAINER Olivier Lamy <olamy@apache.org>"

RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y nginx-extras apache2-utils


COPY webdav.conf /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/sites-enabled/*


RUN mkdir -p "/media/data"

RUN chown -R www-data:www-data "/media/data"
RUn chmod -R 777 "/media/data"
VOLUME /media/data


COPY entrypoint.sh /
RUN chmod +x entrypoint.sh
CMD /entrypoint.sh && nginx -g "daemon off;"
