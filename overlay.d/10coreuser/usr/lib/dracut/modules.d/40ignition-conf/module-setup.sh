#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

depends() {
    echo ignition
}

install() {
    inst "$moddir/base.ign" \
        "/usr/lib/ignition/base.ign"

    inst_multiple -o \
        ip \
        nmtui \
        nmcli \
        find \
        teamd teamdctl

    inst_multiple -o \
        busctl \
        dbus-broker \
        dbus-broker-launch \
        /usr/lib/systemd/system/dbus.socket \
        /usr/sbin/NetworkManager \
        $systemdsystemunitdir/dbus-org.freedesktop.nm-dispatcher.service \
        $systemdsystemunitdir/NetworkManager.service \
        $systemdsystemunitdir/dbus-broker.service \
        $systemdsystemunitdir/dbus.socket \
        /usr/libexec/nm-dhcp-helper \
        /usr/libexec/nm-dispatcher \
        /usr/libexec/nm-iface-helper \
        /usr/libexec/nm-ifdown \
        /usr/libexec/nm-ifup

    # Copy in dbus policies and NetworkManager supporting libs
    for x in /usr/lib/sysusers.d /usr/share/dbus-1 /usr/lib*/NetworkManager ; do
        for d in $(find $x -type d); do
            inst_dir $d
            inst_multiple -o $d/*
        done
    done
    install_unit dbus.socket            socket.target.wants
}
