#!/bin/bash
host=$1
auth_key=
port=23333
scp -P $port -i $auth_key /root/.ssh/id_rsa.pub ops@$1:/home/ops/.ssh/
ssh -p $port ops@$1 -i $auth_key 'cat /home/ops/.ssh/id_rsa.pub >>/home/ops/.ssh/authorized_keys'
ssh -p $port ops@$1
