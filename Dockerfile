FROM ubuntu/apache2:latest
LABEL maintainer="capstone-project"
COPY . /var/www/html/
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
