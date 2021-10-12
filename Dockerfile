# heatools_ubuntu - Build HEASARC tools on Docker
#
# Stephen Fegan - sfegan@gmail.com - 2017-05-16
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Build version : v1.4

FROM ubuntu:20.04

MAINTAINER sfegan@llr.in2p3.fr

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive  apt-get install -y \
        gcc                                                        \
        g++                                                        \
        gfortran                                                   \
        libreadline6-dev                                           \
        libncurses5-dev                                            \
        xorg-dev                                                   \
        perl-modules                                               \
        python-dev                                                 \
        make                                                       \
        wget                                                       \
        tcsh                                                       \
        python3-fitsio

ENV CC=gcc CXX=g++ FC=gfortran PERL=perl PYTHON=python

# ADD https://heasarc.gsfc.nasa.gov/FTP/software/lheasoft/lheasoft6.29/heasoft-6.29src.tar.gz /usr/local
ADD heasoft-6.29src.tar.gz /usr/local

RUN cd /usr/local/heasoft-6.29/BUILD_DIR &&                        \
    ./configure &&                                                 \
    make &&                                                        \
    make install &&                                                \
    cd .. &&                                                       \
    rm -rf BUILD_DIR

ENV HEADAS=/usr/local/heasoft-6.29/x86_64-pc-linux-gnu-libc2.31

RUN echo '. $HEADAS/headas-init.sh' >> /root/.bashrc

ENV CALDB=/usr/local/caldb

RUN mkdir $CALDB &&                                                \
    cd $CALDB &&                                                   \
    wget http://heasarc.gsfc.nasa.gov/FTP/caldb/software/tools/caldb_setup_files.tar.Z && \
    tar -zxf caldb_setup_files.tar.Z &&                            \
    rm -f caldb_setup_files.tar.Z

RUN echo '. $CALDB/software/tools/caldbinit.sh' >> /root/.bashrc

RUN cd $CALDB &&                                                   \
    wget https://heasarc.gsfc.nasa.gov/FTP/caldb/data/swift/uvota/goodfiles_swift_uvota_20201215.tar.Z && \
    tar -zxf goodfiles_swift_uvota_20201215.tar.Z &&               \
    rm -f goodfiles_swift_uvota_20201215.tar.Z

RUN cd $CALDB &&                                                   \
    wget https://heasarc.gsfc.nasa.gov/FTP/caldb/data/swift/bat/goodfiles_swift_bat_20171016.tar.Z && \
    tar -zxf goodfiles_swift_bat_20171016.tar.Z &&                 \
    rm -f goodfiles_swift_bat_20171016.tar.Z

CMD ["/bin/bash"]
