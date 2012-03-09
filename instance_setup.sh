sed -e 's|$name|amzn|g' -e 's|$mirror|repo.us-east-1.amazonaws.com|g' /etc/cloud/templates/amzn-main.repo.tmpl >/etc/yum.repos.d/amzn-main.repo
wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
rpm -i rpmforge-release-0.5.2-2.el6.rf.*.rpm
umount /media/ephemeral10
mkfs.ext4 /dev/xvdb
mkfs.ext4 /dev/xvdc
mkfs.ext4 /dev/xvdd
mkfs.ext4 /dev/xvde
mkdir /benchmark
mkdir /benchmark-plain2
mkdir /benchmark-encrypted
mkdir /benchmark-encrypted2
mount /dev/xvdb /benchmark
mount /dev/xvdc /benchmark-plain2
mount /dev/xvdd /benchmark-encrypted
mount /dev/xvde /benchmark-encrypted2
dd if=/dev/urandom of=/benchmark/test bs=1M count=1024
dd if=/dev/urandom of=/benchmark-plain2/test bs=1M count=1024
dd if=/dev/urandom of=/benchmark-encrypted/test bs=1M count=1024
dd if=/dev/urandom of=/benchmark-encrypted2/test bs=1M count=1024
yum install fio
yum install sysstat
yum install git
cd /home/ec2-user
git clone https://terryma@github.com/terryma/aesni-benchmark.git benchmark
cd benchmark


