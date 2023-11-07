#!/bin/bash
# scp alessandro@192.168.1.60:/home/alessandro/Dev/experiment/install*sh .

RELEASE_VERSIONS=3.6.15,3.8.16
clear

echo "Check current python version..."
#pyv="$(python3 -V 2>&1)"
curr_pyv="$(python3 -V | awk '{print $2}' | awk -F'.' '{printf "%s.%s", $1,$2}' 2>&1)"
echo "Python $curr_pyv"

cd /tmp
#sudo apt -y install build-essential checkinstall virtualenv
sudo apt -y install build-essential checkinstall git
sudo apt -y install libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

sudo apt -y install python${curr_pyv}{-distutils,-venv}
sudo update-alternatives --install /usr/bin/python python /usr/bin/python${curr_pyv} 1
#curl https://bootstrap.pypa.io/get-pip.py --output /tmp/get-pip.py
#sudo -H python /tmp/get-pip.py 
#sudo ln -s /usr/local/bin/pip3 /usr/bin/pip3
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${curr_pyv} 1


sudo apt-get install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

curl https://pyenv.run | bash

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

bash -c "echo -e 'export PATH=\"\$HOME/.pyenv/bin:\$PATH\"\neval \"\$(pyenv init --path)\"\neval \"\$(pyenv virtualenv-init -)\"\n' >> $HOME/.bash_aliases"

CURRENT_RELEASE_INDEX=1
for CURRENT_VER in ${RELEASE_VERSIONS//,/ }; do 
    CURRENT_RELEASE_INDEX=$((CURRENT_RELEASE_INDEX+1))

    echo "Installing Python ${CURRENT_VER} from site"
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        CURRENT_MAJ_VER=$(echo $CURRENT_VER | awk -F'.' '{printf "%s.%s", $1,$2}')

        cd /tmp
        sudo wget https://www.python.org/ftp/python/${CURRENT_VER}/Python-${CURRENT_VER}.tgz
        sudo tar xzf Python-${CURRENT_VER}.tgz
        cd Python-${CURRENT_VER}
        sudo ./configure --enable-optimizations --disable-test-suite	
        sudo make altinstall
        sudo update-alternatives --install /usr/bin/python${CURRENT_MAJ_VER} python${CURRENT_MAJ_VER} /usr/local/bin/python${CURRENT_MAJ_VER} ${CURRENT_RELEASE_INDEX}
        pyenv install ${CURRENT_VER}
    fi

done

#cd /tmp
#sudo wget https://www.python.org/ftp/python/3.6.15/Python-3.6.15.tgz
#sudo tar xzf Python-3.6.15.tgz
#cd Python-3.6.15
#sudo ./configure --enable-optimizations
#sudo make altinstall
#sudo update-alternatives --install /usr/bin/python3.6 python3.6 /usr/local/bin/python3.6 2

#cd /tmp
#sudo wget https://www.python.org/ftp/python/3.8.16/Python-3.8.16.tgz
#sudo tar xzf Python-3.8.16.tgz
#cd Python-3.8.16
#sudo ./configure --enable-optimizations
#sudo make altinstall
#sudo update-alternatives --install /usr/bin/python3.8 python3.8 /usr/local/bin/python3.8 3


