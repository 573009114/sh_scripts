#!/bin/bash
read -p "输入密码:" PASS
HOST=$(hostname)
read -p "输入本机IP" IP
cd /etc/docker
openssl genrsa -aes256 -passout pass:$PASS -out ca-key.pem 2048
openssl req -new -x509 -days 365 -key ca-key.pem -passin pass:$PASS -sha256 -out ca.pem -subj "/C=NL/ST=./L=./O=./CN=$HOST"
openssl genrsa -out server-key.pem 2048
openssl req -subj "/CN=$HOST" -new -key server-key.pem -out server.csr
echo subjectAltName = IP:$IP,IP:127.0.0.1 > extfile.cnf
openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem -passin "pass:$PASS" -CAcreateserial -out server-cert.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf
openssl genrsa -out key.pem 2048 
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
sh -c 'echo "extendedKeyUsage=clientAuth" >> extfile.cnf'
openssl x509 -req -days 365 -in client.csr -CA ca.pem -CAkey ca-key.pem -passin "pass:$PASS" -CAcreateserial -out cert.pem -extfile extfile.cnf
chmod 0400 ca-key.pem key.pem server-key.pem
chmod 0444 ca.pem server-cert.pem cert.pem
rm client.csr server.csr
