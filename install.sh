#!/bin/bash
#
#


function ext4_format ()
{
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                                 Disk Partitions                                                  "
    echo "------------------------------------------------------------------------------------------------------------------"
    sudo fdisk -l
    echo " "
    echo "Enter disk name for installation: "
    read disk
    sudo umount /dev/${disk}?*
    sudo umount -l /mnt
    sudo sgdisk --zap-all /dev/$disk
    sudo sgdisk -n 1:0:+300M -n 2:0:0 -t 1:ef00 /dev/$disk -p
    dn=${disk}1
    sudo mkfs.fat -F 32 /dev/$dn
    sudo fatlabel /dev/$dn NIXBOOT
    dn=${disk}2
    sudo mkfs.ext4 /dev/$dn -L NIXROOT
    sudo mount /dev/disk/by-label/NIXROOT /mnt
    sudo mkdir -p /mnt/boot
    sudo mount /dev/disk/by-label/NIXBOOT /mnt/boot
    sudo fallocate -l 2G /mnt/.swapfile
    sudo chmod 600 /mnt/.swapfile
    sudo mkswap /mnt/.swapfile
    sudo swapon /mnt/.swapfile
}

function base_install()
{
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                                 Base Installation                                                  "
    echo "------------------------------------------------------------------------------------------------------------------"
    sudo nixos-generate-config --root /mnt
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
    sudo awk -v var="$replacement_block" 'NR==14{print var} NR<14 || NR>24' $file_path | sudo tee /home/nixos/zwelch-flakes/nixos/hardware-configuration_changed.nix
    sudo cp -r /home/nixos/zwelch-flakes /mnt/.
    sudo nix develop --extra-experimental-features nix-command --extra-experimental-features flakes
    sudo rm -rf /mnt/zwelch-flakes/.git
    pushd /mnt/zwelch-flakes/
    sudo nixos-install --no-root-passwd --flake .#zwelchnix
    popd
}

sudo loadkeys de-latin1-nodeadkeys
clear
echo -ne "
------------------------------------------------------------------------------------------------------------------
███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝                                                                                                          
------------------------------------------------------------------------------------------------------------------                                                         
"
sleep 2
ext4_format
