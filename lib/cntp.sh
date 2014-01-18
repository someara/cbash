
# test
rpm -qa | grep ntp
if [ $? -ne 0 ]; then
    # action
    yum -y install ntp
fi

# test
test -f /etc/ntp.conf
if [ $? -ne 0 ]; then
    # action
    cp /mnt/dist/ntp/ntp.conf    
fi

# test
service ntpd status
if [ $? -ne 0 ]; then
    # action
    service ntp start
fi

