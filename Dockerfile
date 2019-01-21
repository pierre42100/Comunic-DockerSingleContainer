FROM debian

#Run in non-interactive mode
ENV DEBIAN_FRONTEND="noninteractive" HOME="/"

#Install dependencies
RUN apt update
RUN apt install -y apache2 php7.0 php7.0-mysql php7.0-gd php7.0-mbstring mysql-server git uglifyjs zip

#Add shorcuts
RUN echo 'eval "mysqld_safe&"; sleep 10;' > /root/start_mysql.sh

#Configure servers
RUN a2enmod rewrite
RUN sh /root/start_mysql.sh; mysqladmin -u root password root; mysql -e "CREATE DATABASE comunic"; exit
RUN sh /root/start_mysql.sh; mysql -e "CREATE USER 'comunic'@'localhost'; GRANT ALL PRIVILEGES ON comunic.* To 'comunic'@'localhost' IDENTIFIED BY 'comunic';"; exit
RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY apache2.conf /etc/apache2/sites-enabled

#Retrieve Comunic API
RUN mkdir /data/
RUN git clone https://github.com/pierre42100/ComunicAPI /data/api

#Import database
RUN sh /root/start_mysql.sh; mysql comunic < /data/api/db_struct.sql; exit

#Update API config
COPY overwriteAPIconfig.php /data/api/config/

#Create API client
RUN sh /root/start_mysql.sh; /data/api/bin/add_client client token; exit

#Initialize user data directory
COPY empty_user_data_dir.tar.gz /root/
RUN mkdir /data/user_data/
RUN tar -xf /root/empty_user_data_dir.tar.gz -C /data/user_data
RUN chmod a+rwxX /data/user_data -R

#Retrieve Comunic Web APP
RUN git clone https://github.com/pierre42100/ComunicWeb /root/webapp 

#Build webapp
RUN /root/webapp/builder build docker
RUN mv /root/webapp/output/* /data; mv /root/webapp/output/.htaccess /data/


#Copy start script
COPY start.sh /root/start
RUN chmod +x /root/start
CMD /root/start
