FROM ubuntu

RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean

COPY index.html /var/www/html/

CMD ["apachectl", "-D", "FOREGROUND"]
