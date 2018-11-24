#!/bin/sh
flatpak install  winehub \
	online.winehub.Platform.Compat32/x86_64/1.6 \
	online.winehub.Platform/x86_64/1.6 \
	online.winehub.Sdk.Compat32/x86_64/1.6 \
	online.winehub.Sdk/x86_64/1.6

flatpak remove -y online.winehub.test.shell32

flatpak-builder -v --user --install -y \
        --arch=x86_64 --ccache --keep-build-dirs --force-clean \
        --repo=winehub-repo builds/winehub-test-shell32  \
        winehub-sdk/tests/winehub.test.shell32.yml

flatpak run -v online.winehub.test.shell32
