#!/bin/bash

if [[ -x `command -v yum` ]]; then
    yum -y install python34-pip
    yum -y install npm
elif [[ -x `command -v brew`]]; then
    brew install python3
    brew install npm
else
    echo "Platform not supported"
    exit
fi

pip3 install virtualenv

virtualenv env --python=python3
source env/bin/activate

pip install -r requirements.txt
npm install
npm run build

export FLASK_APP=./autoapp.py

flask db init
flask db migrate
flask db upgrade

gunicorn myflaskapp.app:create_app\(\) -b 0.0.0.0:80 -w 4

