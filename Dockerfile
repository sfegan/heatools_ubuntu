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

# Build version : v1.1

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
        wget

ENV CC=gcc CXX=g++ FC=gfortran PERL=perl PYTHON=python

ADD heasoft-6.21src.tar.gz /usr/local/

RUN cd /usr/local/heasoft-6.21/BUILD_DIR &&                        \
    ./configure &&                                                 \
    make &&                                                        \
    make install

ENV HEADAS=/usr/local/heasoft-6.21/x86_64-unknown-linux-gnu-libc2.23

RUN echo '. $HEADAS/headas-init.sh' >> /root/.bashrc

RUN apt-get update -y && apt-get install -y                        \
        tcsh

CMD ["/bin/bash"]
