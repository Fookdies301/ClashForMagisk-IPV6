#!/system/bin/sh
#
# Script for clash setup
# - on-start.sh : On clash core started, setup proxy here
# - on-stop.sh : On clash core stoped, clean here
#
# Environments:
# - CLASH_HTTP_PORT: clash http proxy port
# - CLASH_SOCKS_PORT: clash socks proxy port
# - CLASH_REDIR_PORT: clash redir proxy port
# - CLASH_DNS_PORT: clash dns port
# - CLASH_UID: clash runing uid
# - CLASH_GID: clash running gid
#


if [[ "${CLASH_UID}" = "" ]];then
    echo "Clash uid not found"
    exit 1
fi

if [[ "${CLASH_REDIR_PORT}" = "" ]];then
    echo "Clash redir disabled"
    exit 1
fi

iptables -t nat -N CLASH_LOCAL
iptables -t nat -N CLASH_EXTERNAL

iptables -t nat -A CLASH_LOCAL -m owner --uid-owner ${CLASH_UID} -j RETURN
iptables -t nat -A CLASH_LOCAL -d 0.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_LOCAL -d 127.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_LOCAL -d 224.0.0.0/4 -j RETURN
iptables -t nat -A CLASH_LOCAL -d 172.16.0.0/12 -j RETURN
iptables -t nat -A CLASH_LOCAL -d 127.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_LOCAL -d 169.254.0.0/16 -j RETURN
iptables -t nat -A CLASH_LOCAL -d 240.0.0.0/4 -j RETURN
iptables -t nat -A CLASH_LOCAL -d 192.168.0.0/16 -j RETURN
iptables -t nat -A CLASH_LOCAL -d 10.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_LOCAL -p tcp -j REDIRECT --to-ports ${CLASH_REDIR_PORT}

iptables -t nat -A CLASH_EXTERNAL -d 0.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_EXTERNAL -d 127.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_EXTERNAL -d 224.0.0.0/4 -j RETURN
iptables -t nat -A CLASH_EXTERNAL -d 172.16.0.0/12 -j RETURN
iptables -t nat -A CLASH_EXTERNAL -d 127.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_EXTERNAL -d 169.254.0.0/16 -j RETURN
iptables -t nat -A CLASH_EXTERNAL -d 240.0.0.0/4 -j RETURN
iptables -t nat -A CLASH_EXTERNAL -d 192.168.0.0/16 -j RETURN
iptables -t nat -A CLASH_EXTERNAL -d 10.0.0.0/8 -j RETURN
iptables -t nat -A CLASH_EXTERNAL -p tcp -j REDIRECT --to-ports ${CLASH_REDIR_PORT}

iptables -t nat -I OUTPUT -p tcp -j CLASH_LOCAL
iptables -t nat -I PREROUTING -p tcp -j CLASH_EXTERNAL

ip6tables -t nat -N CLASH_LOCAL6
ip6tables -t nat -N CLASH_EXTERNAL6
ip6tables -t nat -A CLASH_LOCAL6 -m owner --uid-owner ${CLASH_UID} -j RETURN
ip6tables -t nat -A CLASH_LOCAL6 -d ::/128 -j RETURN
ip6tables -t nat -A CLASH_LOCAL6 -d ::1/128 -j RETURN
ip6tables -t nat -A CLASH_LOCAL6 -d ff00::/8 -j RETURN
ip6tables -t nat -A CLASH_LOCAL6 -d fe80::/10 -j RETURN
ip6tables -t nat -A CLASH_LOCAL6 -p tcp -j REDIRECT --to-ports ${CLASH_REDIR_PORT}

ip6tables -t nat -A CLASH_EXTERNAL6 -d ::/128 -j RETURN
ip6tables -t nat -A CLASH_EXTERNAL6 -d ::1/128 -j RETURN
ip6tables -t nat -A CLASH_EXTERNAL6 -d ff00::/8 -j RETURN
ip6tables -t nat -A CLASH_EXTERNAL6 -d fe80::/10 -j RETURN
ip6tables -t nat -A CLASH_EXTERNAL6 -p tcp -j REDIRECT --to-ports ${CLASH_REDIR_PORT}

ip6tables -t nat -I OUTPUT -p tcp -j CLASH_LOCAL6
ip6tables -t nat -I PREROUTING -p tcp -j CLASH_EXTERNAL6

if [[ "${CLASH_DNS_PORT}" = "" ]];then
    exit 0
fi

iptables -t nat -N CLASH_DNS_LOCAL
iptables -t nat -N CLASH_DNS_EXTERNAL

iptables -t nat -A CLASH_DNS_LOCAL -p udp ! --dport 53 -j RETURN
iptables -t nat -A CLASH_DNS_LOCAL -m owner --uid-owner ${CLASH_UID} -j RETURN
iptables -t nat -A CLASH_DNS_LOCAL -p udp -j REDIRECT --to-ports ${CLASH_DNS_PORT}

iptables -t nat -A CLASH_DNS_EXTERNAL -p udp ! --dport 53 -j RETURN
iptables -t nat -A CLASH_DNS_EXTERNAL -p udp -j REDIRECT --to-ports ${CLASH_DNS_PORT}

iptables -t nat -I OUTPUT -p udp -j CLASH_DNS_LOCAL
iptables -t nat -I PREROUTING -p udp -j CLASH_DNS_EXTERNAL

ip6tables -t nat -N CLASH_DNS_LOCAL6
ip6tables -t nat -N CLASH_DNS_EXTERNAL6

ip6tables -t nat -A CLASH_DNS_LOCAL6 -p udp ! --dport 53 -j RETURN
ip6tables -t nat -A CLASH_DNS_LOCAL6 -m owner --uid-owner ${CLASH_UID} -j RETURN
ip6tables -t nat -A CLASH_DNS_LOCAL6 -p udp -j REDIRECT --to-ports ${CLASH_DNS_PORT}

ip6tables -t nat -A CLASH_DNS_EXTERNAL6 -p udp ! --dport 53 -j RETURN
ip6tables -t nat -A CLASH_DNS_EXTERNAL6 -p udp -j REDIRECT --to-ports ${CLASH_DNS_PORT}

ip6tables -t nat -I OUTPUT -p udp -j CLASH_DNS_LOCAL6
ip6tables -t nat -I PREROUTING -p udp -j CLASH_DNS_EXTERNAL6
