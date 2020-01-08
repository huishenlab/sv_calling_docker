
#!/bin/bash

set -euo pipefail
basedir=$(pwd)

wget -qO /usr/local/bin/mosdepth https://github.com/brentp/mosdepth/releases/download/v0.2.7/mosdepth
chmod +x /usr/local/bin/mosdepth

wget -qO /usr/local/bin/duphold https://github.com/brentp/duphold/releases/download/v0.2.1/duphold
chmod +x /usr/local/bin/duphold

wget -qO /usr/bin/smoove https://github.com/brentp/smoove/releases/download/v0.2.5/smoove
chmod +x /usr/bin/smoove

git clone --recursive https://github.com/arq5x/lumpy-sv
cd lumpy-sv
make -j 3
cp ./bin/* /usr/local/bin/

cd $basedir

# install delly
wget -qO /usr/local/bin/delly https://github.com/dellytools/delly/releases/download/v0.8.1/delly_v0.8.1_linux_x86_64bit
chmod +x /usr/local/bin/delly

# install manta
wget -qO manta.tar.bz2 https://github.com/Illumina/manta/releases/download/v1.6.0/manta-1.6.0.release_src.tar.bz2
tar xjvf manta.tar.bz2
cd manta*_src
mkdir build && cd build
../configure --prefix=/usr/local/bin/manta
make -j4 install

cd $basedir

# install GRIDSS
mkdir gridss && cd gridss
wget -q https://github.com/PapenfussLab/gridss/releases/download/v2.7.3/gridss-2.7.3-gridss-jar-with-dependencies.jar
ln -s gridss-2.7.3-gridss-jar-with-dependencies.jar /usr/local/bin/gridss.jar

cd $basedir

# install SURVIVOR
git clone https://github.com/fritzsedlazeck/SURVIVOR.git
cd SURVIVOR/Debug
make
cp ./SURVIVOR /usr/local/bin

cd $basedir

# install biscuit
wget -qO /usr/bin/biscuit https://github.com/zwdzwd/biscuit/releases/download/v0.3.14.20200104/biscuit_0_3_14_linux_amd64
chmod +x /usr/bin/biscuit

# install bwa
wget -qO bwa.tar.bz2 https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2
tar xjvf bwa.tar.bz2
cd bwa-0.7.17
make
cp ./bwa /usr/bin/bwa
chmod +x /usr/bin/bwa

cd $basedir

rm -rf lumpy-sv
rm manta.tar.bz2
rm bwa.tar.bz2
rm -rf /var/lib/apt/lists/*

echo "done"
