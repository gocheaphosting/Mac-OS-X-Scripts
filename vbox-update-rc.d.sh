#!/bin/bash

sudo update-rc.d -f vboxdrv remove
sudo update-rc.d -f virtualbox remove
sudo update-rc.d -f vboxautostart-service remove
sudo update-rc.d -f vboxweb-service remove
sudo update-rc.d -f vboxballoonctrl-service remove

sudo update-rc.d -f vboxdrv defaults 21 79
sudo update-rc.d -f virtualbox defaults 22 78
sudo update-rc.d -f vboxautostart-service defaults 91 09
sudo update-rc.d -f vboxweb-service defaults 23 77
sudo update-rc.d -f vboxballoonctrl-service defaults 23 77
