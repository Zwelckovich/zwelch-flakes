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
    sudo cp -r ~/zwelch-flakes/ /mnt/.
    sudo cp  /mnt/etc/nixos/hardware-configuration.nix /mnt/zwelch-flakes/nixos/hardware-configuration.nix
    # Die Datei, in der die Änderungen vorgenommen werden sollen
    datei="/mnt/zwelch-flakes/nixos/hardware-configuration.nix"

    # Der neue Block, den du einfügen möchtest
    neuerBlock='
    fileSystems."/" =
    {
        device = "/dev/disk/by-label/NIXROOT";
        fsType = "ext4";
    };
    '

    # Suchen nach dem alten Block und ersetzen durch den neuen Block
    sudo awk -v neuerBlock="$neuerBlock" "/$muster/{print neuerBlock; f=1} !/$muster{print} f{f=0}" "$datei" > temp && mv temp "$datei"

    echo "Block ersetzt."
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
base_install
