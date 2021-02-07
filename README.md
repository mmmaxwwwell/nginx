# [mmmaxwwwell/nginx](https://github.com/mmmaxwwwell/nginx)

This is a container designed to be used in conjunction with certbot. It is intended to allow you to start nginx with your final .conf files and then automatically reboot once certbot is able to get a cert. It will also reboot the container if certbot gets a new cert.

### Features:

* Watches directories and stops container if contents have changed.
* On startup, checks template directories for references to ssl certs that don't exist yet. If certs don't exist, replace with a staging cert.
