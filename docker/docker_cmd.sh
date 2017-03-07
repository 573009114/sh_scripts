#!/bin/bash
docker=$@
docker --tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/cert.pem --tlskey=/etc/docker/key.pem -H=127.0.0.1:2376  $docker
