
# test
rpm -qa | grep httpd
if [ $? -ne 0 ]; then
    # action
    yum -y install httpd
fi

# test
test -f /etc/http/conf/httpd.conf
if [ $? -ne 0 ]; then
    # action
    cp /mnt/dist/http/httpd.conf    
fi

# test
service httpd status
if [ $? -ne 0 ]; then
    # action
    service httpd start
fi

