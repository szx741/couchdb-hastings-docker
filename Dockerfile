FROM debian:9
# Debian dependencies
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get --no-install-recommends -y install \
build-essential \
ca-certificates \
curl \
git \
libicu-dev \
libmozjs185-dev \
libcurl4-openssl-dev \
lsb-release \
pkg-config \
python-pip \
ssh \
vim \
vim-gui-common \
wget

RUN git config --global url."https://github.com.cnpmjs.org/".insteadOf "https://github.com/"
RUN apt-get install -y gnupg2

# Erlang
RUN curl -o erlang-solutions.1.0_all.deb https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions.1.0_all.deb
RUN apt-get update
RUN apt-get install -y esl-erlang=1:19.3.6

# Node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update
RUN apt-get install -y --force-yes nodejs

# Rebar
RUN git clone https://github.com/rebar/rebar
RUN cd rebar && make

# Geospatial
RUN curl -sL http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.5.tar.gz | tar xvz
RUN cd spatialindex-src-1.8.5 && ./configure && make && make install
RUN curl -sL http://download.osgeo.org/geos/geos-3.5.1.tar.bz2 | tar vxj
RUN cd geos-3.5.1 && ./configure && make && make install
RUN apt install -y libleveldb-dev
# RUN git clone https://github.com/google/leveldb.git
# RUN cd leveldb && make && cp out-static/lib* out-shared/lib* /usr/local/lib/ && cd include/ && cp -r leveldb /usr/local/include/ && ldconfig
# RUN apt-get -y install subversion
# RUN wget \
#   --retry-connrefused \
#   --waitretry=1 \
#   --read-timeout=20 \
#   --timeout=15 \
#   -t 10 \
#   -nH \
#   -P CsMapDev \
#   --cut-dirs=5 \
#   -m \
#   -np \
#   https://svn.osgeo.org/metacrs/csmap/branches/14.01/CsMapDev
COPY CsMapDev-14.01.zip .
RUN apt install -y zip
RUN unzip CsMapDev-14.01.zip

RUN cd CsMapDev/Source && make -fLibrary.mak
RUN cd CsMapDev/Dictionaries && make -fCompiler.mak && ./CS_Comp . .
RUN cd CsMapDev/Test && make -fTest.mak && ./CS_Test -d../Dictionaries
RUN mkdir -p /usr/share/CsMap/dict
RUN cp -r CsMapDev/Include /usr/local/include/CsMap && cp CsMapDev/Source/CsMap.a /usr/local/lib/libCsMap.a && cp -r CsMapDev/Dictionaries/* /usr/share/CsMap/dict && ldconfig

# CouchDB
RUN pip install requests -i https://pypi.tuna.tsinghua.edu.cn/simple
RUN git clone https://github.com/apache/couchdb
WORKDIR /couchdb
# RUN git checkout f350d5f5de8413ffaa6c5fac6bfb19f090fbd8ec
RUN git checkout 2.3.1
COPY hastings-fixer.sh .
RUN ./hastings-fixer.sh before-configure
RUN ./configure --disable-docs 
RUN ./hastings-fixer.sh
RUN make release

# Single Node setup
# COPY data rel/couchdb/data

# Docker config adjustments
RUN sed -e 's/^bind_address = .*$/bind_address = 0.0.0.0/' -i rel/couchdb/etc/default.ini
RUN sed -e 's!/usr/local/var/log/couchdb/couch.log$!/dev/null!' -i rel/couchdb/etc/default.ini

# Prepare sample tests
# RUN pip install requests -i https://pypi.tuna.tsinghua.edu.cn/simple
WORKDIR src/hastings/sample
RUN ls *.py | xargs sed -i 's/15984/5984/'

WORKDIR /couchdb
# Start server
CMD rel/couchdb/bin/couchdb
EXPOSE 5984
