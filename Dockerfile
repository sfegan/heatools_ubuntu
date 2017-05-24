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

# Build version : v1.2

FROM ubuntu:16.04

MAINTAINER sfegan@llr.in2p3.fr

RUN apt-get update -y && apt-get install -y                        \
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
        python-pyfits                                              \
        python3-pyfits

ENV CC=gcc CXX=g++ FC=gfortran PERL=perl PYTHON=python

RUN cd /usr/local &&                                               \
    wget http://heasarc.gsfc.nasa.gov/FTP/software/lheasoft/release/heasoft-6.21src.tar.gz && \
    tar zxvf heasoft-6.21src.tar.gz &&                             \
    rm -f heasoft-6.21src.tar.gz &&                                \
    cd heasoft-6.21/BUILD_DIR &&                                   \
    ./configure &&                                                 \
    make &&                                                        \
    make install

ENV HEADAS=/usr/local/heasoft-6.21/x86_64-unknown-linux-gnu-libc2.23

RUN echo '. $HEADAS/headas-init.sh' >> /root/.bashrc

ENV CALDB=/usr/local/caldb

RUN mkdir $CALDB &&                                                \
    cd $CALDB &&                                                   \
    wget http://heasarc.gsfc.nasa.gov/FTP/caldb/software/tools/caldb_setup_files.tar.Z && \
    tar -zxf caldb_setup_files.tar.Z &&                            \
    rm -f caldb_setup_files.tar.Z

RUN echo '. $CALDB/software/tools/caldbinit.sh' >> /root/.bashrc

RUN cd $CALDB &&                                                   \
    wget https://heasarc.gsfc.nasa.gov/FTP/caldb/data/swift/uvota/goodfiles_swift_uvota_20170130.tar.Z && \
    tar -zxf goodfiles_swift_uvota_20170130.tar.Z &&               \
    rm -f goodfiles_swift_uvota_20170130.tar.Z

CMD ["/bin/bash"]
