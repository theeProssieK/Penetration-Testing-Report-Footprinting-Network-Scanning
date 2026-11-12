┌──(kali㉿kali)-[~]
└─$ dnsrecon -d networkwalks.com
2026-11-10T17:14:08.794475-0500 INFO Starting enumeration for domain: networkwalks.com
2026-11-10T17:14:08.794971-0500 INFO std: Performing General Enumeration against: networkwalks.com...
2026-11-10T17:14:09.780266-0500 ERROR No answer for DNSSEC query for networkwalks.com
2026-11-10T17:14:10.148690-0500 INFO     SOA ns6135.hostgator.com 50.87.144.87
2026-11-10T17:14:11.530142-0500 INFO     NS ns6136.hostgator.com 192.232.216.131
2026-11-10T17:14:12.211009-0500 INFO     Bind Version for 192.232.216.131 "9.16.23-RH"
2026-11-10T17:14:12.211785-0500 INFO     NS ns6135.hostgator.com 50.87.144.87
2026-11-10T17:14:16.746974-0500 INFO     MX mail.networkwalks.com 192.232.216.135
2026-11-10T17:14:16.781668-0500 INFO     A networkwalks.com 192.232.216.135
2026-11-10T17:14:22.894667-0500 INFO Enumerating SRV Records
2026-11-10T17:14:31.706117-0500 INFO     SRV _autodiscover._tcp.networkwalks.com cpanelemaildiscovery.cpanel.net 184.94.203.11 443
2026-11-10T17:14:31.706706-0500 INFO     SRV _autodiscover._tcp.networkwalks.com cpanelemaildiscovery.cpanel.net 184.94.204.11 443
2026-11-10T17:14:31.707021-0500 INFO     SRV _autodiscover._tcp.networkwalks.com cpanelemaildiscovery.cpanel.net 184.94.204.14 443
2026-11-10T17:14:31.707243-0500 INFO     SRV _autodiscover._tcp.networkwalks.com cpanelemaildiscovery.cpanel.net 184.94.203.14 443
2026-11-10T17:14:31.707427-0500 INFO     SRV _autodiscover._tcp.networkwalks.com cpanelemaildiscovery.cpanel.net 184.94.204.9 443
2026-11-10T17:14:31.709343-0500 INFO     SRV _autodiscover._tcp.networkwalks.com cpanelemaildiscovery.cpanel.net 184.94.203.9 443
2026-11-10T17:14:31.709611-0500 INFO     SRV _autodiscover._tcp.networkwalks.com cpanelemaildiscovery.cpanel.net 184.94.203.15 443
2026-11-10T17:14:31.710020-0500 INFO     SRV _autodiscover._tcp.networkwalks.com cpanelemaildiscovery.cpanel.net 184.94.204.15 443
2026-11-10T17:14:31.713635-0500 INFO 8 Records Found
2026-11-10T17:14:31.714122-0500 INFO Completed enumeration for domain: networkwalks.com

                                                                             
┌──(kali㉿kali)-[~]
└─$ 
