FROM tacc/tacc-ubuntu18-impi19.0.7-common:latest

LABEL maintainer <rene.gassmoeller@mailbox.org>

# we need a newer version of cmake to support unity builds:
RUN apt-get update && apt-get -yq upgrade && apt-get -yq install \
    libblas-dev \
    liblapack-dev \
    git \
    wget \
    python \
    numdiff \
    bc \
    ninja-build

RUN cd /opt && \
    git clone https://github.com/dealii/candi.git && \
    cd candi && \
    echo "NATIVE_OPTIMIZATIONS=ON" >> local.cfg && \
    echo "DEAL_II_VERSION=v9.4.2" >> local.cfg && \
    echo "BUILD_EXAMPLES=OFF" >> local.cfg && \
    echo "USE_64_BIT_INDICES=ON" >> local.cfg && \
    echo "DEAL_CONFOPTS='-DDEAL_II_WITH_COMPLEX_VALUES=OFF -DDEAL_II_WITH_LAPACK=ON'" >> local.cfg && \
    ./candi.sh -j 2 --packages="once:cmake once:p4est once:trilinos once:hdf5 once:netcdf once:sundials dealii" -p /opt && \
    rm -rf /opt/tmp

# Build aspect, replace git checkout command to create image for release
ENV Aspect_DIR /opt/aspect
RUN source /opt/configuration/enable.sh && \
    git clone https://github.com/geodynamics/aspect.git $Aspect_DIR && \
    mkdir ${Aspect_DIR}/build && \
    cd ${Aspect_DIR}/build && \
    cmake -DCMAKE_BUILD_TYPE=DebugRelease -DCMAKE_INSTALL_PREFIX=$Aspect_DIR \
    -DASPECT_INSTALL_EXAMPLES=ON .. && \
    make -j2 && make install && make clean

ENV PATH ${Aspect_DIR}/bin:${PATH}
