# Create the variables for easier scripting
namespace1=east
namespace2=west
namespace3=central
command='python3 -m http.server'
ip_address1="10.10.10.10/24"
ip_address2='10.10.10.20/24'
ip_address3='10.10.10.30/24'
interface1=east
interface2=west
interface3=central

# we are going to create the network namespaces
ip netns add $namespace1
ip netns add $namespace2
ip netns add $namespace3

# we need to start openvswitch
systemctl start openvswitch

# we are going to create a bridge device for the virtual switch
ovs-vsctl add-br NAMESPACE-DEMO

# we are going to create our “ethernet pairs”
ip link add $interface1 type veth peer name ovs-$interface1
ip link add $interface2 type veth peer name ovs-$interface2
ip link add $interface3 type veth peer name ovs-$interface3

# Attach one end to the namespace
ip link set $interface1 netns $namespace1
ip link set $interface2 netns $namespace2
ip link set $interface3 netns $namespace3

# View the network interfaces in one of the namespaces
sudo ip netns exec $namespace2 ip ad

# attach the other end to the virtual switch
ovs-vsctl add-port NAMESPACE-DEMO ovs-$interface1
ovs-vsctl add-port NAMESPACE-DEMO ovs-$interface2
ovs-vsctl add-port NAMESPACE-DEMO ovs-$interface3

# give the namespaces their IPs
ip netns exec $namespace1 ip addr add $ip_address1 dev $interface1
ip netns exec $namespace2 ip addr add $ip_address2 dev $interface2
ip netns exec $namespace3 ip addr add $ip_address3 dev $interface3

# bring the interfaces up
ip netns exec $namespace1 ip link set dev $interface1 up
ip netns exec $namespace2 ip link set dev $interface2 up
ip netns exec $namespace3 ip link set dev $interface3 up

# View the network interfaces in one of the namespaces
sudo ip netns exec $namespace2 ip ad

# start the webserver
ip netns exec $namespace2 $command &

# bring up the interfaces on the virtual switch
ip link set dev ovs-$interface1 up
ip link set dev ovs-$interface2 up
ip link set dev ovs-$interface3 up

# Let’s ping some namespaces from inside other namespaces
ip netns exec $namespace3 ping -c 2 10.10.10.20
ip netns exec $namespace1 ping -c 2 10.10.10.20

# try pinging from the host
ping -c 2 10.10.10.20


# try and retrieve the webserver response from a container
ip netns exec $namespace3 curl `echo $ip_address2 |awk -F '/' '{print $1}'`:8000

# see if you can do the same from the host
curl `echo $ip_address2 |awk -F '/' '{print $1}'`:8000


# Let’s look at an arp table or two
ip netns exec $namespace1 arp
ip netns exec $namespace2 arp

# NAMESPACE-DEMO if exists?
ip link show

# add an IP to the host port and bring the interface up
ip addr add 10.10.10.40/24 dev  NAMESPACE-DEMO
ip link set dev  NAMESPACE-DEMO up

# run the curl to verify that the host can now access the webserver
curl `echo $ip_address2 |awk -F '/' '{print $1}'`:8000

