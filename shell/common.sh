#!/bin/bash

function initialize {
    # initialize br-int
    ovs-vsctl --if-exists del-br br-int
    ovs-vsctl --may-exist add-br br-int
    # create VTEP port
    ovs-vsctl add-port br-int vxlan-port \
	-- set Interface vxlan-port type=vxlan options:remote_ip=flow options:key=flow ofport_request=100

    # add flow table 0->1
    ovs-ofctl add-flow br-int \
	cookie=0x0,table=0,priority=10 actions=resubmit(,1)
    #add flow table 1->2
    ovs-ofctl add-flow br-int \
	cookie=0x0,table=1,priority=11,arp actions=resubmit(,2)
    # add flow table 2->drop
    ovs-ofctl add-flow br-int \
	cookie=0x0,table=2,priority=10 actions=drop
}

function addLocalPort {
    local vni=$1
    local intfname=$2
    local intfmac=$3
    local intfip=$4

    # create a port
    ovs-vsctl add-port br-int ${intfname} \
	-- set Interface ${intfname} type=internal
    ip link set ${intfname} address ${intfmac} up
    ip addr add ${intfip} dev ${intfname}

    # retrieve port ID
    ?????

    # ingress rule (packets coming through the new port)
    # attach VNI and resubmit to table 1
    ovs-ofctl add-flow br-int "table=0,in_port=${portid},actions=load:${vni}=>NXM_NX_TUN_ID[],resubmit(,1)"

    # egress rule (packets coming destined for new port)
    ovs-ofctl add-flow br-int "table=2,tun_id=${vnid},dl_dst=${intfmac} action=output:${portid}"
}

func addRemotePort (vni, intfname, intfmac, intip) {
}