## Learn Chef by doing.

This Lab will help you understand the whole concept of Chef/Chef Server/Chef DK/Knife and all Chef utilities 
that revolve around provisioning boxes.

The end goal of this project is be able to setup the following:
* Run Chef Server locally on a Vagrant virtual machine.
* Provision 1 load balancer and 2 Web applications through Chef
* Write your own cookbooks and deploy them to Chef Server.
* Write tests for Chef

## Pre-requisities

* Decent command line -> I'm using [cmder](http://cmder.net/)
* Git -> Install [cmder](http://cmder.net/) and you will get Git
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/)


## Step One - Setting up Chef Server

First you have to clone this repository, open up [cmder](http://cmder.net/) and clone it.

__NOTE: MAKE SURE YOUR SHELL HAS ADMINISTRATOR PRIVILEGES__
```
λ cd C:\
λ mkdir git-repos
λ cd git-repos
λ git clone https://github.com/hyeomans/chef-lab
λ cd chef-lab
```

### Files explanation

Go ahead and inspect the Vagrant file. This file contains Ruby which is pretty straightforward,
in this section you need to take a look at `config.vm.define :chef_server do |chef_server_config|`.

If you haven't work with Vagrant, the following lines mean:
* Vagrant will provision an ubuntu box in Virtual box. 
  * This box is downloaded from https://atlas.hashicorp.com/ubuntu/boxes/trusty64
  * If this is the first time you provision, it will take a while to download.
* The following lines explain themselves, we set the hostname, ip address, a 
forwarded port (8080 is ubuntu, 80 is your machine), and we set the RAM for this box.
* The last line before the `end` block is a way to provision boxes for Vagrant. In this case is a bash file.

Now open up `provision/bootstrap-chef-server.sh`. Ubuntu need some basic packages for Chef Server, this is the `apt-get` portion.

Then your provision script downloads Chef Server deb package and installs it.

All those steps, after installing Chef Server, can be found at [their Website](https://docs.chef.io/release/server_12-8/install_server.html), this is what they do:

* Create a first user to be able to log in into Chef Server
* Create an Org and associate the user to this Org.
* Install Chef Manage, this is the Web interface for Chef Server.
* Install Chef Reporting.

The lines modifying the hosts file allow chef-server box to talk to all other nodes without knowing the IP's.

Go back to [cmder](http://cmder.net/) and type the following:

```
C:\roblox-chef\chef-lab
λ vagrant up chef_server
```

This will take a while, if you're in Linux/macOS you might get asked for your password. This is OK.

Once that's done you can open up your browser and go to: `https://chef-server/`

You will get a certificate exception, that's OK you can skip it and continue.

Login with `testlabdev` and password `password`

## Step 2 - Configure ChefDK

Download starter package

```
C:\roblox-chef\chef-repo
λ knife ssl fetch
```

```
C:\roblox-chef\chef-repo
λ knife ssl check
```

```
C:\roblox-chef\chef-repo
λ chef verify
```

## Step 3 - Bootstraping nodes

```
C:\roblox-chef\chef-repo
λ vagrant up lb web2 web3
```

```
C:\roblox-chef\chef-repo
λ knife bootstrap web3 -x vagrant -P vagrant --sudo --verbose -N web3-node
```


### Step 4 - Adding roles


```
knife node run_list add web3-node "role[lab-linux]"
```

