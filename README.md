# iptables_config
Simple iptables script to secure *nix box. Accepts params for ports to open.

#How to Use

* clone this repo
* navigate to this repo
* make file executable:
```
chmod +x iptables_config.sh
```
* run the script
```
./iptables_config
```

#PFM

To prevent yourself being locked out of a box you're ssh'd in to, the shell script temporarily accepts all incoming requests. It then flushes the current iptables rules. It will then open up port 22 by default. It will then ask you if this machine is being used as a router. This may be the case if you're using this machine as a switch to your network. This script then drops all incoming packets and accepts any outputs. Look below on line arguments.

#Parameters
this script accepts line arguments. These arguments should be ports that you wish to keep open ie. 80 for http, 25 smtp etc. It will loop through these and open the indicated ports.

#Logging
By default, two unbound logs are managed in *var/log/messages* . One logs all dropped packets. The other logs any UDP flooding attempts. It is set by default to have a flood limit of 50/s
