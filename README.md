# Bash scripts for running Docker Image mdb-mkinstall

If you're just looking to run a dockerized Mailserver you may head directly to the GitHub Repository for **mdb-dc-mklive** (see link below).  

--

The Docker Image **mdb-mkinstall** is used for building the **mdb-install**, **mdb-mariadb** and **mdb-nginx** Docker Images.

These images are required for using the Docker Image **mdb-mklive**.

The Docker Images **mdb-install**, **mdb-mariadb** and **mdb-nginx** will contain all necessary software components for setting up a fully featured dockerized Mailserver:

- Modoboa Webinterface for  
	- domain and user management
	- webmailer
	- managing calenders and contacts
	- managing autoresponse emails
- SpamAssassin Anti-Spam-Filter
- Postfix SMTP Server
- Dovecot IMAP Server
- ClamAV Virus Scanner
- AutoMX for automated mail account configuration in email clients
- Radicale CalDAV and CardDAV Server
- MariaDB Database Server
- OpenDKIM for automaticly signing outgoing emails to reduce risk of emails being falsely classified as spam
- Apache Webserver for handling requests to the Modoboa Webinterface, AutoMX and Radicale within the Docker Container running **mdb-live**
- Nginx Reverse Proxy for forwarding requests from the outside world to the Apache Webserver

Note that the Docker Image **mdb-install** is not intended to be used directly as a Mailserver.  
Instead, use **mdb-mklive** to generate a Docker Image with your custom settings.

In order to use this Docker Image you should also get a copy of the Docker Container Repository **mdb-dc-mklive** (see below).

## Usage
1. Clone this repository to your harddrive, e.g. by running  
``$ git clone https://github.com/tsitle/dockercontainer-mdb_dc_mkinstall.git``  
2. Change the working directory, e.g. by running  
``$ cd dockercontainer-mdb_dc_mkinstall``  
3. Copy the file _config-SAMPLE.sh_ to _config.sh_  
4. Edit _config.sh_ if you want to change the defaults  
5. run  
``$ ./mkinstall.sh build all``  

You can look up further options by running
``$ ./mkinstall.sh help``  

You should now have the Docker Images **mdb-install**, **mdb-mariadb** and **mdb-nginx**.  
You could remove the Docker Image **mdb-mkinstall** now if you wanted to.  

At this point you'll need the Docker Container Repository **mdb-dc-mklive** (see below).

## Links
### GitHub
- GitHub Repository for Docker Image [mdb-mkinstall](https://github.com/tsitle/dockerimage-mdb_mkinstall)
- GitHub Repository for Docker Image [mdb-mklive](https://github.com/tsitle/dockerimage-mdb_mklive)
- GitHub Repository for Docker Container [mdb-dc-mklive](https://github.com/tsitle/dockercontainer-mdb_dc_mklive)

### Docker Hub
- [mdb-mkinstall](https://hub.docker.com/r/tsle/mdb-mkinstall "Docker Hub Repository for Docker Image mdb-mkinstall")
- [mdb-install](https://hub.docker.com/r/tsle/mdb-install "Docker Hub Repository for Docker Image mdb-install")
- [mdb-mariadb](https://hub.docker.com/r/tsle/mdb-mariadb "Docker Hub Repository for Docker Image mdb-mariadb")
- [mdb-nginx](https://hub.docker.com/r/tsle/mdb-nginx "Docker Hub Repository for Docker Image mdb-nginx")
- [mdb-mklive](https://hub.docker.com/r/tsle/mdb-mklive "Docker Hub Repository for Docker Image mdb-mklive")

