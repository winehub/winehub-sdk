#!/bin/sh

# remember: WineHub Platform/Sdk shoud be qual with the org.freedsktop version

WINEHUB_VERSION=1.6

# clear everything "beware of this" - 
flatpak list |  grep -e 'winehub.' |  awk '{ print $1}' | xargs flatpak remove -y
###################################
# add flatpak repo flathub        #
###################################
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

###################################
# install org.freedesktop base    #
###################################
flatpak install -y flathub org.freedesktop.Sdk/i386/$WINEHUB_VERSION \
	org.freedesktop.Sdk/x86_64/$WINEHUB_VERSION \
	org.freedesktop.Platform/i386/$WINEHUB_VERSION \
	org.freedesktop.Platform/x86_64/$WINEHUB_VERSION

###################################
# create local repository         #
###################################
flatpak --user remote-add --no-gpg-verify --if-not-exists winehub winehub-repo

###################################
# build the winhub sdk stack      #
###################################
flatpak-builder --arch=i386 --ccache --keep-build-dirs --force-clean \
	--repo=winehub-repo builds/winehub-sdk-i386  winehub-sdk/winehub.Sdk.json
flatpak-builder --arch=x86_64 --ccache --keep-build-dirs --force-clean \
	--repo=winehub-repo builds/winehub-sdk-x86_64  winehub-sdk/winehub.Sdk.json

flatpak build-commit-from --verbose --src-ref=runtime/online.winehub.Sdk/i386/$WINEHUB_VERSION \
	winehub-repo runtime/online.winehub.Sdk.Compat32/x86_64/$WINEHUB_VERSION
flatpak build-commit-from --verbose --src-ref=runtime/online.winehub.Platform/i386/$WINEHUB_VERSION \
	winehub-repo runtime/online.winehub.Platform.Compat32/x86_64/$WINEHUB_VERSION
