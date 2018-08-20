func Init() {
	// initialize br-int
	// ovs-vsctl --if-exists del-br br-int
	// ovs-vsctl --may-exist add-br br-int
	// create vtep port
	// ovs-vsctl add-port br-int vxlan-port -- set Interface vxlan-port type=vxlan options:remote_ip=flow options:key=flow ofport_request=100

	// add flow table 0->1
	// ovs-ofctl add-flow <bridge> cookie=0x0,table=0,priority=10 actions=resubmit(,1)
	// add flow table 1->2
	// ovs-ofctl add-flow <bridge> cookie=0x0,table=1,priority=11,arp actions=resubmit(,2)
	// add flow table 2->drop
	// ovs-ofctl add-flow <bridge> cookie=0x0,table=2,priority=10 actions=drop
}

func addLocalPort (vni, intfname, intfmac, intip) {
	// create an ovs port
	// ovs-vsctl add-port <bridge> <intfname> -- set Interface <intfname> type=internal
	// set mac
	// ip link set <intfname> address <intfmac> up
	// set IP
	// ip addr ....
	// retrieve port number
	//...
	// ingress rule (packets coming through the new port)
	// attach VNI and resubmit to table 1
	// ovs-ofctl add-flow <bridge> table=0,in_port=<port>,actions=load:<vni>=>NXM_NX_TUN_ID[],resubmit(,1)
	// egree rule (packets coming destined for new port)
	// ovs-ofctl add-flow <bridge> table=2,tun_id=<vni>,dl_dst=<mac> action=output:<port>
}

func addRemotePort (vni, intfname, intfmac, intip) {
