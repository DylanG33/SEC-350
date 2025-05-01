# For this project I am going to be using a Split tunnel through Wireguard to configure remote access

## Firewall Config
### Creating FW rules allowing traffic from WAN to jump on DMZ
On edg02 run:
```
set firewall name WAN-to-DMZ rule 500 action accept
set firewall name WAN-to-DMZ rule 500 description "Allow WG from WAN to jump on DMZ"
set firewall name WAN-to-DMZ rule 500 destination port 51820
set firewall name WAN-to-DMZ rule 500 protocol udp 
```
