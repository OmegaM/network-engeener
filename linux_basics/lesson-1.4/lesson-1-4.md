# Урок 4. Пользователи и группы. Права доступа

### 1.
#### a.
```bash
[centos@fhmvk0kv3ue1v8ummf8l ~]$ sudo useradd lesson14 && cat /etc/passwd | grep lesson14
lesson14:x:1001:1001::/home/lesson14:/bin/bash
```
#### b.
```bash
[centos@fhmvk0kv3ue1v8ummf8l ~]$ sudo userdel lesson14 && cat /etc/passwd | grep lesson14
[centos@fhmvk0kv3ue1v8ummf8l ~]$
```
### 2.
#### a.
```bash
[centos@fhmvk0kv3ue1v8ummf8l ~]$ sudo groupadd gb && cat /etc/group | grep gb
gb:x:1001:
```
#### b.
```bash
[centos@fhmvk0kv3ue1v8ummf8l ~]$ groups && sudo usermod -aG gb $USER && groups centos
centos adm systemd-journal
centos : centos adm systemd-journal gb
```
#### c.
```bash
[centos@fhmvk0kv3ue1v8ummf8l ~]$ sudo gpasswd -d centos gb && groups centos
Removing user centos from group gb
centos : centos adm systemd-journal
```
### 3.
```bash
[centos@fhmvk0kv3ue1v8ummf8l ~]$ sudo useradd -G wheel --password the_strongest_password sudo_user && sudo groups sudo_user
sudo_user : sudo_user wheel
[centos@fhmvk0kv3ue1v8ummf8l ~]$ sudo su sudo_user
[sudo_user@fhmvk0kv3ue1v8ummf8l centos]$ sudo echo "SUDO"

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for sudo_user:
SUDO
```
### 4.
```bash
[centos@fhmvk0kv3ue1v8ummf8l ~]$ touch test_file-{1,2} && sudo chmod 664 test_file-1 && sudo chmod u+rw,og-rwx test_file-2 && ls -la | grep test_file
-rw-rw-r--. 1 centos centos   0 Sep  3 13:02 test_file-1
-rw-------. 1 centos centos   0 Sep  3 13:02 test_file-2
```

### 5.
```bash
[centos@fhmvk0kv3ue1v8ummf8l ~]$ sudo groupadd developer && \
                                for NUMBER in 1 2; do sudo useradd -G developer user-$NUMBER; done && \
                                mkdir /tmp/shared_dir && \
                                sudo chmod g+s /tmp/shared_dir && \
                                sudo chown centos:developer /tmp/shared_dir && \
                                ls -la /tmp | grep shared
drwxrwsr-x.  2 centos developer   6 Sep  3 13:07 shared_dir

[centos@fhmvk0kv3ue1v8ummf8l ~]$ sudo su user-2
[user-2@fhmvk0kv3ue1v8ummf8l centos]$ mkdir -p /tmp/shared_dir/folder{1..5}/file{1..10} | ls -laR /tmp/shared_dir/
/tmp/shared_dir/:
total 0
drwxrwsr-x.  4 centos developer  36 Sep  3 13:14 .
drwxrwxrwt.  9 root   root      190 Sep  3 13:10 ..
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 folder1
drwxrwsr-x.  6 user-2 developer  58 Sep  3 13:14 folder2

/tmp/shared_dir/folder1:
total 0
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 .
drwxrwsr-x.  5 centos developer  51 Sep  3 13:14 ..
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file1
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file10
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file2
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file3
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file4
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file5
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file6
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file7
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file8
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file9

/tmp/shared_dir/folder1/file1:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder1/file10:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder1/file2:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder1/file3:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder1/file4:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder1/file5:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder1/file6:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder1/file7:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder1/file8:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder1/file9:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder2:
total 0
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 .
drwxrwsr-x.  7 centos developer  81 Sep  3 13:14 ..
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file1
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file10
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file2
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file3
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file4
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file5
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file6
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file7
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file8
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 file9

/tmp/shared_dir/folder2/file1:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder2/file10:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder2/file2:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder2/file3:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder2/file4:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder2/file5:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder2/file6:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder2/file7:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder2/file8:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..

/tmp/shared_dir/folder2/file9:
total 0
drwxrwsr-x.  2 user-2 developer   6 Sep  3 13:14 .
drwxrwsr-x. 12 user-2 developer 137 Sep  3 13:14 ..
```