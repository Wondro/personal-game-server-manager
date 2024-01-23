# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

sudo apt update && sudo apt upgrade -y 
sudo apt install unzip apt-transport-https ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg -y
sudo apt update

#install AWS CLI
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

#create random string for password
VHPW=$(echo $RANDOM | md5sum | head -c 20)

#get stackname created by user data script and update SSM parameter name with this to make it unique
STACKNAME=$(</tmp/mcParamName.txt)
PARAMNAME=mcPalworldPW-$STACKNAME

#put random string into parameter store as encrypted string value
aws ssm put-parameter --name $PARAMNAME --value $VHPW --type "SecureString" --overwrite


#install docker and palworld app on docker
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -aG docker $USER
sudo mkdir /usr/games/serverconfig
cd /usr/games/serverconfig
sudo bash -c 'echo
services:
   palworld:
      image: thijsvanloef/palworld-server-docker:latest
      restart: unless-stopped
      container_name: palworld-server
      ports:
        - 8211:8211/udp
        - 27015:27015/udp
      environment:
         - PORT=8211 # Optional but recommended
         - PLAYERS=16 # Optional but recommended
         - MULTITHREADING=true
         - ENABLE_RCON=true
         - RCON_PORT=25575
         - ADMIN_PASSWORD="4Lif3!!"
         - COMMUNITY=false  # Enable this if you want your server to show up in the community servers tab, USE WITH SERVER_PASSWORD!
         # Enable the environment variables below if you have COMMUNITY=true
         # - SERVER_PASSWORD="worldofpals"
         # - SERVER_NAME="World of Pals"
      volumes:
         - ./palworld:/palworld/
   rcon:
      image: outdead/rcon:latest
      entrypoint: ['/rcon', '-a', 'palworld:25575', '-p', '4Lif3!!']
      profiles: ['rcon']'
echo "@reboot root (cd /usr/games/serverconfig/ && docker-compose up)" > /etc/cron.d/awsgameserver
sudo docker-compose up