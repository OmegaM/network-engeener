# Урок 8. Работа с Web, TFTP сервером

### 1.
```bash
root@fhm8h226240hifnufcbm:/home/ubuntu# useradd ssh_user -p ssh_password --create-home

ssh-copy-id -f -i ~/.ssh/id_rsa ssh_user@51.250.10.201                                                                                                                       ─╯
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/Users/m.ostromogolskii/.ssh/id_rsa.pub"
ssh_user@51.250.10.201's password:

Number of key(s) added:        1

Now try logging into the machine, with:   "ssh 'ssh_user@51.250.10.201'"
and check to make sure that only the key(s) you wanted were added.

root@fhm8h226240hifnufcbm:/home/ubuntu# cat /etc/ssh/sshd_config | grep PasswordAuthentication
PasswordAuthentication no
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication, then enable this but set PasswordAuthentication

 ssh ssh_user@51.250.10.201                                                                                                                                                   ─╯
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Sat Sep 17 15:05:48 2022 from 46.138.56.31
```
### 2.
```bash
for port in 21 22 443 80; do ufw allow proto tcp to any port $port; done
Rules updated
Rules updated (v6)
Rules updated
Rules updated (v6)
Rules updated
Rules updated (v6)
Rules updated
Rules updated (v6)

root@fhm8h226240hifnufcbm:/home/ubuntu# ufw status
Status: active

To                         Action      From
--                         ------      ----
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
22/tcp                     ALLOW       Anywhere
21/tcp                     ALLOW       Anywhere
80/tcp (v6)                ALLOW       Anywhere (v6)
443/tcp (v6)               ALLOW       Anywhere (v6)
22/tcp (v6)                ALLOW       Anywhere (v6)
21/tcp (v6)                ALLOW       Anywhere (v6)
```
### 3. 
```bash
root@fhm8h226240hifnufcbm:/home/ubuntu# apt install -y tftpd-hpa
Reading package lists... Done
Building dependency tree
Reading state information... Done
...
root@fhm8h226240hifnufcbm:/home/ubuntu# systemctl status tftpd-hpa.service
● tftpd-hpa.service - LSB: HPA's tftp server
     Loaded: loaded (/etc/init.d/tftpd-hpa; generated)
     Active: active (running) since Sat 2022-09-17 15:19:50 UTC; 33s ago
       Docs: man:systemd-sysv-generator(8)
      Tasks: 1 (limit: 1102)
     Memory: 984.0K
     CGroup: /system.slice/tftpd-hpa.service
             └─2100 /usr/sbin/in.tftpd --listen --user tftp --address :69 --secure /srv/tftp

Sep 17 15:19:50 fhm8h226240hifnufcbm systemd[1]: Starting LSB: HPA's tftp server...
Sep 17 15:19:50 fhm8h226240hifnufcbm tftpd-hpa[2088]:  * Starting HPA's tftpd in.tftpd
Sep 17 15:19:50 fhm8h226240hifnufcbm tftpd-hpa[2088]:    ...done.
Sep 17 15:19:50 fhm8h226240hifnufcbm systemd[1]: Started LSB: HPA's tftp server.


root@fhm8h226240hifnufcbm:/home/ubuntu# apt install tftp -y
Reading package lists... Done
Building dependency tree
Reading state information... Done

root@fhm8h226240hifnufcbm:/home/ubuntu# echo "test_file content" > test_file

root@fhm8h226240hifnufcbm:/home/ubuntu# ufw allow proto udp to any port 69
Rule added
Rule added (v6)

root@fhm8h226240hifnufcbm:/home/ubuntu# chown tftp:tftp /srv/tftp/
root@fhm8h226240hifnufcbm:/home/ubuntu# tftp 0.0.0.0 69
tftp> status
Connected to 0.0.0.0.
Mode: netascii Verbose: off Tracing: off
Rexmt-interval: 5 seconds, Max-timeout: 25 seconds
tftp> verbose
Verbose mode on.
tftp> put test_file transfered_file
putting test_file to 0.0.0.0:transfered_file [netascii]
Sent 19 bytes in 0.0 seconds [inf bits/sec]

root@fhm8h226240hifnufcbm:/home/ubuntu# ls -la /srv/tftp/
total 12
drwxr-xr-x 2 tftp tftp 4096 Sep 17 15:41 .
drwxr-xr-x 3 root root 4096 Sep 17 15:19 ..
-rw-rw-rw- 1 tftp tftp   18 Sep 17 15:42 transfered_file

tftp> get transfered_file back_transfered_file
getting from 0.0.0.0:transfered_file to back_transfered_file [netascii]
Received 19 bytes in 0.0 seconds [inf bits/sec]

root@fhm8h226240hifnufcbm:/home/ubuntu# ls -l
total 8
-rw-r--r-- 1 root root 18 Sep 17 15:43 back_transfered_file
-rw-r--r-- 1 root root 18 Sep 17 15:27 test_file
```
### 4. 
```bash
root@fhm8h226240hifnufcbm:/home/ubuntu# apt update && apt upgrade
...
root@fhm8h226240hifnufcbm:/home/ubuntu# apt install nginx -y
...
root@fhm8h226240hifnufcbm:/home/ubuntu# systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2022-09-17 15:49:07 UTC; 28s ago
       Docs: man:nginx(8)
   Main PID: 16950 (nginx)
      Tasks: 3 (limit: 1102)
     Memory: 7.3M
     CGroup: /system.slice/nginx.service
             ├─16950 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─16951 nginx: worker process
             └─16952 nginx: worker process

Sep 17 15:49:07 fhm8h226240hifnufcbm systemd[1]: Starting A high performance web server and a reverse proxy server...
Sep 17 15:49:07 fhm8h226240hifnufcbm systemd[1]: Started A high performance web server and a reverse proxy server.

root@fhm8h226240hifnufcbm:/etc/nginx/sites-available# cat default
...
location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}
	location ~* .cfg {
		root /srv/www/conf;
		index main.cfg;
		try_files $uri $uri/ /srv/www/conf/main.cfg;
	}
...
root@fhm8h226240hifnufcbm:/etc/nginx/conf.d# mkdir -p /srv/www/conf
root@fhm8h226240hifnufcbm:/etc/nginx/conf.d# cp /etc/rsyslog.conf /srv/www/conf/main.cfg
root@fhm8h226240hifnufcbm:/etc/nginx/sites-available# nginx -t || nginx -s reload
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful

root@fhm8h226240hifnufcbm:/etc/nginx/sites-available# curl 0:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

root@fhm8h226240hifnufcbm:/etc/nginx/sites-available# curl 0:80/main.cfg
# /etc/rsyslog.conf configuration file for rsyslog
#
# For more information install rsyslog-doc and see
# /usr/share/doc/rsyslog-doc/html/configuration/index.html
#
# Default logging rules can be found in /etc/rsyslog.d/50-default.conf
...

```