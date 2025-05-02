# For this project I am going to be using a Split tunnel through Wireguard to configure remote access (sources below)

## Firewall Config Stuff
### Creating firewall rules allowing traffic from WAN to jump on DMZ
On edg02 run:
```
set firewall name WAN-to-DMZ rule 500 action accept
set firewall name WAN-to-DMZ rule 500 description "Allow WG from WAN to jump on DMZ"
set firewall name WAN-to-DMZ rule 500 destination port 51820
set firewall name WAN-to-DMZ rule 500 protocol udp 
```
### Create NAT rule to forward traffic to jump
Also on edge02 run:
```
set nat destination rule 500 description 'WG to jump'
set nat destination rule 500 destination port '51820'
set nat destination rule 500 inbound-interface 'eth0'
set nat destination rule 500 protocol 'udp'
set nat destination rule 500 translation address '172.16.50.4'
set nat destination rule 500 translation port '51820'
```
### Create firewall rule to allow RDP traffic from jump on DMZ to mgmt02 over LAN
Also on edge02 run:
```
set firewall name DMZ-to-LAN rule 20 action 'accept'
set firewall name DMZ-to-LAN rule 20 description 'Allow RDP from DMZ to LAN'
set firewall name DMZ-to-LAN rule 20 destination address '172.16.200.11'
set firewall name DMZ-to-LAN rule 20 destination port '3389'
set firewall name DMZ-to-LAN rule 20 protocol 'tcp'
set firewall name DMZ-to-LAN rule 20 source address '172.16.50.4'
```
### Create firewall rule to allow RDP traffic from jump via LAN to mgmt02 on DMZ
This time on fw-mgmt run:
```
set firewall name LAN-to-MGMT rule 20 action 'accept'
set firewall name LAN-to-MGMT rule 20 description 'Allow RDP from LAN to MGMT02'
set firewall name LAN-to-MGMT rule 20 destination address '172.16.200.11'
set firewall name LAN-to-MGMT rule 20 destination port '3389'
set firewall name LAN-to-MGMT rule 20 protocol 'tcp'
set firewall name LAN-to-MGMT rule 20 source address '172.16.50.4'
```

## Server configuration steps
Note, it was here that my jump vm broke and could not connect to anything, and so I could not complete the following. This is what you would do, per my research, if you had working VMs!!

On jump:
### Install WireGuard, create key pairs, and enable IP forwarding
```
sudo apt update
sudo apt install wireguard -y

cd /etc/wireguard/
umask 077; wg genkey | tee privatekey | wg pubkey > publickey
sysctl -w net.ipv4.ip_forward=1
```
Note, you have to now copy your public key and get it to your client VM per whatever method you choose
## wg0.conf
You would add the following to this configuration file 
```
[Interface]
Address = 10.124.200.2/32
ListenPort = 51820
PrivateKey = <PASTE SERVER PRIVATE KEY>
SaveConfig = true
PreUp = iptables -t nat -A POSTROUTING -o ens160 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o ens160 -j MASQUERADE

[Peer]
PublicKey = <PASTE CLIENT PUBLIC KEY LATER>
AllowedIPs = x.x.x.x/x
Endpoint = x.x.x.x/x
```
## Client private key
1. go to wireguard.com/install
2. Go to GUI and select "Add empty tunnel", which automatically creates a keypair
3. The **public** key needs to go in the wg0.conf file on the server
4. Now add your public key into the specific slot on the config, and add your private key into its respective slot
5. Now run this on traveler:  systemctl enable --now wg-quick@wg0

## Activation
1. in the gui slesct activate for the tunnel that has been created
2. Open RDP and connect ot the IP 172.16.200.11
3. you should see data coming and going in the GUI

#Sources
- https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04
- https://documentation.ubuntu.com/server/explanation/intro-to/wireguard-vpn/index.html
- https://www.reddit.com/r/Ubiquiti/comments/1ewan95/wireguard_vpn_setup_on_ubuntu_2404/














