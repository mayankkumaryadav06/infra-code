#!/usr/bin/sh

# In case old files are present
echo "Removing old codes"
rm -rf infra-problem

if [[ ! -e /usr/bin/lein ]]; then
  if [[ "$OSTYPE" == "linux-gnu" ]]; then  # We can add more OSTYPE values to keep this script generic for all OS
    echo "Installing lein"
    sudo wget https://raw.github.com/technomancy/leiningen/stable/bin/lein -P /usr/bin/
    sudo chmod +x /usr/bin/lein
  fi
fi

echo "Cloning repo where codes are stored"
git clone https://github.com/ThoughtWorksInc/infra-problem.git

echo "Making library and creating jar and tgz files"
cd infra-problem && make libs && make clean all

echo
echo "Copying jar and tar files in ansible to distribute"

# Copying the files in relevant ansible template folder to copy them in remote AMI 
cp front-end/public/serve.py ../front-end/templates/serve.py && cp build/front-end.jar ../front-end/templates/front-end.jar && cp build/static.tgz ../front-end/templates/static.tgz
cp build/newsfeed.jar ../news-feed/templates/ && cp build/quotes.jar ../quotes-feed/templates/
