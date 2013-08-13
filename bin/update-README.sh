#!/bin/sh
cd ~
sudo chattr -i README
cp README_buffer README
sudo chattr +i README
