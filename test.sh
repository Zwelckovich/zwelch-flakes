#!/bin/bash
#
#


file_path="/home/nixos/zwelch-flakes/nixos/hardware-configuration.nix"
sudo rm $file_path
sudo cp /mnt/etc/nixos/hardware-configuration.nix /home/nixos/zwelch-flakes/nixos/
replacement_block='
fileSystems."/" =
    {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
    };

fileSystems."/boot" =
    {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
    };

swapDevices = [
    {
    device = "/.swapfile";
    }
];
'
sudo awk -v var="$replacement_block" 'NR==14{print var} NR<14 || NR>24' $file_path | sudo tee $file_path