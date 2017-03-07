#!/bin/bash
host=$1
scp -i ops_key /root/.ssh/id_rsa.pub ops@$1:/home/ops/.ssh/
ssh ops@$1 -i ops_key 'cat /home/ops/.ssh/id_rsa.pub >>/home/ops/.ssh/authorized_keys'
ssh ops@$1
