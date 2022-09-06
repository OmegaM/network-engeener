# Урок 5. Работа с дисками. Разделы, LVM, точки монтирования

### 1. 
![new virtual disk](../imgs/instance_with_custom_disk.png)
```bash
[root@fhm2tdnsd3m33f2723pr centos]# lsblk
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
vda    253:0    0  10G  0 disk
|-vda1 253:1    0   1M  0 part
`-vda2 253:2    0  10G  0 part /
vdb    253:16   0  10G  0 disk
```
#### a.
```bash
[root@fhm2tdnsd3m33f2723pr centos]# parted
GNU Parted 3.1
Using /dev/vda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) select /dev/vdb
Using /dev/vdb
(parted) print
Error: /dev/vdb: unrecognised disk label
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 10.7GB
Sector size (logical/physical): 512B/4096B
Partition Table: unknown
Disk Flags:
(parted) mklabel
New disk label type? gpt
(parted) mkpart
Partition name?  []? FIRS_HALF
File system type?  [ext2]? ext4
Start? 0
End? 5000
Warning: The resulting partition is not properly aligned for best performance.
Ignore/Cancel? ignore
(parted) print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 10.7GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name       Flags
 1      17.4kB  5000MB  5000MB               FIRS_HALF

(parted) mkpart
Partition name?  []? SECOND_HALF
File system type?  [ext2]? xfs
Start? 5001
End? 10000
(parted) print
Model: Virtio Block Device (virtblk)
Disk /dev/vdb: 10.7GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name         Flags
 1      17.4kB  5000MB  5000MB  ext4         FIRS_HALF
 2      5001MB  10.0GB  5000MB               SECOND_HALF
```
#### b.
```bash
[root@fhm2tdnsd3m33f2723pr centos]# mkfs.ext4 /dev/vdb1
mke2fs 1.42.9 (28-Dec-2013)
/dev/vdb1 alignment is offset by 3072 bytes.
This may result in very poor performance, (re)-partitioning suggested.
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
305216 inodes, 1220699 blocks
61034 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=1251999744
38 block groups
32768 blocks per group, 32768 fragments per group
8032 inodes per group
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

[root@fhm2tdnsd3m33f2723pr centos]# mkdir -p /mnt/ext4
[root@fhm2tdnsd3m33f2723pr centos]# mount /dev/vdb1 /mnt/ext4/
[root@fhm2tdnsd3m33f2723pr centos]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vda    253:0    0   10G  0 disk
|-vda1 253:1    0    1M  0 part
`-vda2 253:2    0   10G  0 part /
vdb    253:16   0   10G  0 disk
|-vdb1 253:17   0  4.7G  0 part /mnt/ext4
`-vdb2 253:18   0  4.7G  0 part
```
#### c.
```bash
[root@fhm2tdnsd3m33f2723pr centos]# echo "/dev/vdb1 /mnt/ext4 ext4 rw,noatime 1 1" >> /etc/fstab && mount -a
[root@fhm2tdnsd3m33f2723pr centos]# cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Tue Feb  2 13:35:48 2021
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=73c7a5bb-d81e-4815-8bef-f7b261426bab /                       xfs     defaults        0 0
/dev/vdb1 /mnt/ext4 ext4 rw,noatime 1 1
```
### 2.
```bash
[root@fhm2tdnsd3m33f2723pr centos]# yum install -y lvm2
...
Installed:
  lvm2.x86_64 7:2.02.187-6.el7_9.5
...
Complete!
[root@fhm2tdnsd3m33f2723pr centos]# pvcreate /dev/vdb2
  Physical volume "/dev/vdb2" successfully created.
[root@fhm2tdnsd3m33f2723pr centos]# pvs
  PV         VG Fmt  Attr PSize  PFree
  /dev/vdb2     lvm2 ---  <4.66g <4.66g
[root@fhm2tdnsd3m33f2723pr centos]# vgcreate data /dev/vdb2
  Volume group "data" successfully created
[root@fhm2tdnsd3m33f2723pr centos]# vgs
  VG   #PV #LV #SN Attr   VSize VFree
  data   1   0   0 wz--n- 4.65g 4.65g
[root@fhm2tdnsd3m33f2723pr centos]# mkdir /mnt/xfs
[root@fhm2tdnsd3m33f2723pr centos]# lvcreate -n xfs --size 2.5Gb data
  Logical volume "xfs" created.
[root@fhm2tdnsd3m33f2723pr centos]# lvs
  LV   VG   Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  xfs  data -wi-a----- 2.50g
[root@fhm2tdnsd3m33f2723pr centos]# mkfs.xfs /dev/mapper/data-xfs
meta-data=/dev/mapper/data-xfs   isize=512    agcount=4, agsize=163840 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=0, sparse=0
data     =                       bsize=4096   blocks=655360, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@fhm2tdnsd3m33f2723pr centos]# echo "/dev/mapper/data-xfs /mnt/xfs xfs defaults 0 0" >> /etc/fstab && mount -a
[root@fhm2tdnsd3m33f2723pr centos]# lsblk
NAME         MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
vda          253:0    0   10G  0 disk
|-vda1       253:1    0    1M  0 part
`-vda2       253:2    0   10G  0 part /
vdb          253:16   0   10G  0 disk
|-vdb1       253:17   0  4.7G  0 part /mnt/ext4
`-vdb2       253:18   0  4.7G  0 part
  `-data-xfs 252:0    0  2.5G  0 lvm  /mnt/xfs
```
### 3.
```bash
[root@fhm2tdnsd3m33f2723pr centos]# curl -Lv google.com > /home/centos/file1
[root@fhm2tdnsd3m33f2723pr centos]# cp file1 file2
[root@fhm2tdnsd3m33f2723pr centos]# ln -s file1 file3
[root@fhm2tdnsd3m33f2723pr centos]# ls -ila
total 52
 8390846 drwx------. 3 centos centos   113 Sep  6 08:32 .
25165946 drwxr-xr-x. 3 root   root      20 Sep  6 07:59 ..
 8415264 -rw-r--r--. 1 centos centos    18 Nov 24  2021 .bash_logout
 8415456 -rw-r--r--. 1 centos centos   193 Nov 24  2021 .bash_profile
 8611844 -rw-r--r--. 1 centos centos   231 Nov 24  2021 .bashrc
16803549 drwx------. 2 centos centos    29 Sep  6 07:59 .ssh
 8415215 -rw-r--r--. 1 root   root   16724 Sep  6 08:30 file1
 8415216 -rw-r--r--. 1 root   root   16724 Sep  6 08:31 file2
 8415217 lrwxrwxrwx. 1 root   root       5 Sep  6 08:32 file3 -> file1
[root@fhm2tdnsd3m33f2723pr centos]# ln file1 file4
[root@fhm2tdnsd3m33f2723pr centos]# ls -ila
total 72
 8390846 drwx------. 3 centos centos   126 Sep  6 08:33 .
25165946 drwxr-xr-x. 3 root   root      20 Sep  6 07:59 ..
 8415264 -rw-r--r--. 1 centos centos    18 Nov 24  2021 .bash_logout
 8415456 -rw-r--r--. 1 centos centos   193 Nov 24  2021 .bash_profile
 8611844 -rw-r--r--. 1 centos centos   231 Nov 24  2021 .bashrc
16803549 drwx------. 2 centos centos    29 Sep  6 07:59 .ssh
 8415215 -rw-r--r--. 2 root   root   16724 Sep  6 08:30 file1
 8415216 -rw-r--r--. 1 root   root   16724 Sep  6 08:31 file2
 8415217 lrwxrwxrwx. 1 root   root       5 Sep  6 08:32 file3 -> file1
 8415215 -rw-r--r--. 2 root   root   16724 Sep  6 08:30 file4
 [root@fhm2tdnsd3m33f2723pr centos]# rm -rf file1 && cat file{3,4}
cat: file3: No such file or directory
<!doctype html><html itemscope="" itemtype="http://schema.org/WebPage" lang="ru"> 
...
</body></html>
```
