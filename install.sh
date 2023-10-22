#!/bin/bash
#
#


function ext4_format ()
{
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                                 Disk Partitions                                                  "
    echo "------------------------------------------------------------------------------------------------------------------"
    fdisk -l
    echo " "
    echo "Enter disk name for installation: "
    read disk
    sudo umount /dev/${disk}?*
    sudo umount -l /mnt
    sudo sgdisk --zap-all /dev/$disk
    sudo sgdisk -n 1:0:+300M -n 2:0:0 -t 1:ef00 -t /dev/$disk -p
    dn=${disk}1
    sudo mkfs.fat -F32 /dev/$dn
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

function base_installl()
{
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                                 Base Installation                                                  "
    echo "------------------------------------------------------------------------------------------------------------------"
    sudo nixos-generate-config --root /mnt


    echo "#################"
    echo "#SCRIPT FINISHED#"
    echo "#################"
    echo "Select Action:"
    echo "  1)Shutdown"
    echo "  2)Reboot"
    read n
    case $n in
        1) shutdown now;;
        2) reboot;;
        *) echo "invalid option";;
    esac
}

function hyprland_install ()
{
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
    base_config
}