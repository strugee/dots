#!/bin/sh
sudo chattr -i /etc/README
cp /root/README_buffer /etc/README
sudo chattr +i /etc/README
