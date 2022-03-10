#Get base image
FROM ubuntu:18.04

#Author
MAINTAINER "Dinh Xuan Duong"

ENV TZ=Asia/Ho_Chi_Minh
# Set timezone:
RUN ln -snf /usr/share/zoneinfo/TZ /etc/localtime && echo TZ > /etc/timezone

# Install dependencies:
RUN apt-get update && apt-get install -y tzdata

#INSTALL NGINX
RUN apt -y update
RUN apt-get install -y nginx

#install php 7.04
RUN apt -y update
RUN apt -y install software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt -y update
RUN apt -y install php7.4
RUN apt-get install -y php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath

#Set directory working
WORKDIR /var/www/html/

#copy code to image
ADD ./code /var/www/html/

# start nginx (Nếu không dùng docker file thì nỏ commnet)
#CMD ["nginx", "-g", "daemon off;"]

EXPOSE 80 443
