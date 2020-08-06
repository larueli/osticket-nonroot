# OSTicket on OpenShift

OSTicket is an opensource ticket management system. It's one of the best.
This repo aims to make it run easily on openshift and docker.

**Features**
* Runs as random user, root group
* Latest osticket, php 7.4
* Comes with all languages
* Comes with officials plugins and more
    * Auth :: LDAP and Active Directory
    * Auth :: HTTP Pass-Through
    * Auth :: CAS (from [Kevin O'Connor repo](https://github.com/kevinoconnor7/osTicket-auth-cas), so up-to-date)
    * Storage :: Attachments on the Filesystem
    * Storage :: Attachments in Amazon S3
    * Audit :: Audit Log
    * Attachment Preview, from [Aaron Were repo](https://github.com/clonemeagain/attachment_preview)
* Run your own init scripts in container, put them in `/docker-entrypoint-init.d/`
* Delete the setup directory if the env var `IS_INSTALLED` is set to any value
* Dynamic set of `upload_max_filesize` and `post_max_size` (`4G` by default) with .htaccess as volume

## Installation

1. Comment this part inside docker-compose.yml for installation : 
```
#    environment:
#      - IS_INSTALLED=yes
#    volumes:
#      - ./ost-config.php:/var/www/html/include/ost-config.php
```
2. Launch containers with `docker-compose up -d`
3. Go to `urlcontainer/setup/`, and proceed to install : it will populate the db and create the `ost-config.php`
4. Get the content of the file `/var/www/html/include/ost-config.php` and copy it near your docker-compose.yml. You can use this command : `docker exec -it osticket-openshift_osticket_1 cat include/ost-config.php > ost-config.php`
5. Uncomment the env and volumes part, and restart : `docker-compose up`

**I've got troubles with URL and ports !**

The port inside the container is 8080, it may cause some troubles if you don't have reverse proxy (this is the case with a simple docker-compose).
If you have, fix this with hardcoded values. Inside your `ost-config.php`, add at the bottom :
```
$_SERVER['SERVER_PORT'] = 80; //the real port, 443 or 80 or whatever on your host
$_SERVER['HTTPS'] = "on" // do not set this value at all if you don't use https
```

## Configure CAS

To make it work, you must authorize the following attributes : uid, mail, completeName/cn.

1. Disable public registration. Go to admin panel > settings > users. In registration method, choose `Private - Only Agents can register users`.
2. Force connection. In the admin panel, user settings, tick `login required`
3. Disable agent password reinit. In admin panel > settings > agents, untick `Authorize password reinit`.

You're ready to go !

1. Go to the plugin page inside the admin panel > Manage > Plugins
2. Add the CAS Plugin
3. Click on the plugin to configure it.
    * Server hostname : `cas.yourcompany.com`
    * Server port : 443 usually
    * Server context : `/cas`
    * CA Cert Path : the complete path in the container where the cert lives. You can mount it as a volume.
    * E-mail suffix : if the CAS doen't give full adress, put your mail domain address. This is usually not needed. The mail will be used to find users in the database.
    * Name attribute key : `cn` usually
    * Single sign off : if you want your users to be also disconnected from CAS when they log out
    * Force client registrations : tick it, it will auto create client accounts. The staff accounts still needs to be created by hand before they can login.
    * Auth : set it for both agents and clients
4. Select the plugin, and activate it

## The attachment on file system.

It's not recommended to store attachment in database.

1. Mount a volume inside the /var/www/html/ directory, like `/var/www/html/attachments`. You may need to set rights on the folder on the host (`chgrp 0 attachments && chmod g+rwx attachments`)
2. Activate the plugin attachment on filesystem, and in the config set it to the full path : `/var/www/html/attachments`
3. Enable the plugin (select it, enable)
4. Inside the admin panel, parameters, system, at the bottom, select `Filesystem` in `Store the attachment`