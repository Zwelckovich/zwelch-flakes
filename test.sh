#!/bin/bash
#
#


file_path="/home/nixos/zwelch-flakes/nixos/hardware-configuration.nix"
sudo rm $file_path
sudo cp /mnt/etc/nixos/hardware-configuration.nix /home/nixos/zwelch-flakes/nixos/