#create a simulator object
set ns [new Simulator]
#open a output file 
set nf [open out.nam w]
$ns namtrace-all $nf

# add a function closes output flie 
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exit 0
}

#create 4 node

set s1 [$ns node]

set g1 [$ns node]

set g2 [$ns node]

set r1 [$ns node]

#set variable

set accBw 2Mb

set accDelay 10ms

set conBw 1Mb

set conDelay 10ms

set qLenLimit 100

set pktSize 1000bytes

set advWndUpbnd 100

#set link
#create a duplex link connent s1 and g1 with bandwidth $accBw ,a delay $accDelay and a DropTail queue 

$ns duplex-link $s1 $g1 $accBw $accDelay DropTail

$ns duplex-link $g2 $r1 $accBw $accDelay DropTail 

$ns duplex-link $g1 $g2 $conBw $conDelay DropTail

#set queue limit

$ns queue-limit $g1 $g2 $qLenLimit

$ns queue-limit $g2 $g1 $qLenLimit

#create a tcp vegas agent  
#set packetsize and window
#attach to s1

set vegas1 [new Agent/TCP/Vegas]
$vegas1 set packetSize_ $pktSize
$vegas1 set window_ $advWndUpbnd
$ns attach-agent $s1 $vegas1

#create a TCPSink attach to $r1

set sink1 [new Agent/TCPSink]
$ns attach-agent $r1 $sink1

#create a Application 

set ftp1 [new Application/FTP]
$ftp1 attach-agent $vegas1

#connent two agent
#"In ns, data is always being sent from one 'agent' to another."

$ns connect $vegas1 $sink1

#set start and finish time 

$ns at 0.5 "$ftp1 start"
$ns at 4.5 "$ftp1 stop"

$ns at 5.0 "finish"

#run

$ns run

