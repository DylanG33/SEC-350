This week's technical work involved several key tasks related to configuring and managing VyOS firewalls. Here's a summary of the main activities:

## Updating VyOS

To update VyOS, I used the following commands in the CLI[3]:

```
sudo apt-get update
sudo apt-get upgrade
```

This downloaded and installed the latest updates and patches for the VyOS operating system.

## Configuring RIP

I configured RIP (Routing Information Protocol) on the VyOS routers to enable dynamic routing between network segments. This involved setting up RIP interfaces and defining networks to be advertised.

## Firewall Zones Creation

I created firewall zones for WAN, LAN, DMZ, and MGMT networks, associating them with the appropriate interfaces[1]:

```
set firewall zone WAN interface eth0
set firewall zone DMZ interface eth1
set firewall zone LAN interface eth2
set firewall zone MGMT interface eth1
```

## Firewall Rule Creation

I created various firewall rules to control traffic between zones[1]. Some key rules included:

- Allowing HTTP traffic from WAN to DMZ
- Permitting Wazuh agent communications (ports 1514 and 1515)
- Enabling LAN to WAN outbound traffic
- Configuring specific rules for LAN to DMZ and MGMT to LAN traffic

## Debugging Firewall Blocks

To troubleshoot firewall issues, I used the following command to monitor firewall logs[1]:

```
tail -f /var/log/messages | grep WAN
```

This helped identify dropped packets and adjust rules accordingly.

## Exporting VyOS Configurations

To export the VyOS configurations for fw01 and fw-mgmt, I used the `show configuration commands` command and saved the output to a file.

Throughout this process, I gained valuable hands-on experience in network security and firewall management. The lab exercises reinforced the importance of careful rule creation and the need for thorough testing when implementing firewall policies.

For more detailed information on VyOS configuration and best practices, I referred to the official VyOS documentation[5].

To create the LAN-to-MGMT and MGMT-to-LAN firewalls with the specified rules, use the following VyOS configuration commands:

## LAN-to-MGMT Firewall

```
set firewall name LAN-to-MGMT default-action drop
set firewall name LAN-to-MGMT rule 10 action accept
set firewall name LAN-to-MGMT rule 10 protocol tcp
set firewall name LAN-to-MGMT rule 10 destination port 1514,1515
set firewall name LAN-to-MGMT rule 10 destination address 

set firewall name LAN-to-MGMT rule 20 action accept
set firewall name LAN-to-MGMT rule 20 protocol tcp
set firewall name LAN-to-MGMT rule 20 destination port 443
set firewall name LAN-to-MGMT rule 20 source address 
set firewall name LAN-to-MGMT rule 20 destination address 

set firewall name LAN-to-MGMT rule 30 action accept
set firewall name LAN-to-MGMT rule 30 protocol tcp
set firewall name LAN-to-MGMT rule 30 destination port 22
set firewall name LAN-to-MGMT rule 30 source address 
set firewall name LAN-to-MGMT rule 30 destination address 

set firewall name LAN-to-MGMT rule 40 action accept
set firewall name LAN-to-MGMT rule 40 state established enable
set firewall name LAN-to-MGMT rule 40 state related enable
```

## MGMT-to-LAN Firewall

```
set firewall name MGMT-to-LAN default-action drop
set firewall name MGMT-to-LAN rule 10 action accept
set firewall name MGMT-to-LAN rule 10 destination address 

set firewall name MGMT-to-LAN rule 20 action accept
set firewall name MGMT-to-LAN rule 20 destination address 

set firewall name MGMT-to-LAN rule 30 action accept
set firewall name MGMT-to-LAN rule 30 state established enable
set firewall name MGMT-to-LAN rule 30 state related enable
```
