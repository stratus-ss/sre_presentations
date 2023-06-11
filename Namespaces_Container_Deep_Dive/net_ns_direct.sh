# create the variables file

cat << EOF >> vars
namespace1=client
namespace2=server
command='python3 -m http.server'
ip_address1="10.10.10.10/24"
ip_address2='10.10.10.20/24'
interface1=veth-client
interface2=veth-server
EOF

#source the variable file
. vars


ip netns add $namespace1
ip netns add $namespace2

# ensure the namespaces now exist
ip netns list

# View the network interfaces in one of the namespaces
sudo ip netns exec $namespace2 ip ad

# create the veth devices on the host
ip link add ptp-$interface1 type veth peer name ptp-$interface2

# view the ends of the “ethernet cable” on the host
ip link


# assign the ends of the “cable” to their respective ns
ip link set ptp-$interface1 netns $namespace1
ip link set ptp-$interface2 netns $namespace2

# look inside the namespace at the nics
ip netns exec $namespace2 ip ad

# assign all the nics IPs and bring the nics up
ip netns exec $namespace1 ip addr add $ip_address1 dev ptp-$interface1
ip netns exec $namespace2 ip addr add $ip_address2 dev ptp-$interface2
ip netns exec $namespace1 ip link set dev ptp-$interface1 up
ip netns exec $namespace2 ip link set dev ptp-$interface2 up

# verify that the link is up with an IP
ip netns exec $namespace2 ip ad

# start the webserver
ip netns exec $namespace2 $command &

# try and retrieve the webserver response
ip netns exec $namespace1 curl `echo $ip_address2 |awk -F '/' '{print $1}'`:8000


### Begin DHCP section
# assign variables for DHCP

ip_range_start='10.10.10.100'
ip_range_end='10.10.10.150'
netmask='255.255.255.0'

# dnsmasq requires the loopback interface to be functional so we need to bring it up
ip netns exec $namespace2 ip addr add 127.0.0.1/8 dev lo
ip netns exec $namespace2 ip link set lo up

# verify that the link is up with an IP
ip netns exec $namespace2 ip ad

# start dnsmasq
ip netns exec $namespace2 dnsmasq --interface=ptp-$interface2 --dhcp-range=$ip_range_start,$ip_range_end,$netmask

### REMINDER files can be overwritten from the container
# DHCP will overwrite resolv.conf so create a blank one for the namespace
# if you create a directory for each namespace and create a blank resolv.conf the container will use this instead of the host’s
mkdir -p /etc/netns/{$namespace1,$namespace2}
touch /etc/netns/$namespace1/resolv.conf

# we need to delete the IP address to make way for DHCP lease
ip netns exec $namespace1 ip addr del $ip_address1 dev ptp-$interface1
ip netns exec $namespace1 dhclient ptp-$interface1

# verify that the link is up with an IP
ip netns exec $namespace1 ip ad

# try to add IP to host for communication
ip addr add 10.10.10.30/24 dev enp1s0

# try to ping namespace2… this will fail because we created a ptp link between ns
ping 10.10.10.20

# reboot the host to clear the NS
reboot
