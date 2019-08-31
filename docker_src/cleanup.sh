#!/bin/bash

delete_list="/home/hep/LHAPDF-6.2.3.tar.gz
/home/hep/install_lhapdf.sh
/home/hep/requirements_apt_build.sh
/home/hep/requirements_apt_run.sh
/home/hep/requirements_pip.sh
/var/tmp/install-tl-*
/var/tmp/install_texlive.sh
/var/tmp/texlive.profile"

for element in $delete_list
do
	rm -rf $element
done