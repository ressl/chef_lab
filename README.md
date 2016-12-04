## Learn Chef by doing.

This Lab will help you understand the whole concept of Chef/Chef Server/Chef DK/Knife and all Chef utilities 
that revolve around provisioning boxes.

The end goal of this project is be able to setup the following:
* Run Chef Server locally on a Vagrant virtual machine.
* Provision 1 load balancer and 2 Web applications through Chef
* Write your own cookbooks and deploy them to Chef Server.
* Write tests for Chef

## Prerequisites

* Decent command line -> I'm using [cmder](http://cmder.net/)
* Git -> Install [cmder](http://cmder.net/) and you will get Git
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/)
* [Chef Development Kit - ChefDK](https://downloads.chef.io/chef-dk/)


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
  * This vagrant box is downloaded from https://atlas.hashicorp.com/ubuntu/boxes/trusty64
  * If this is the first time you provision, it will take a while to download.
* The following lines explain themselves, you set the hostname, ip address, a 
forwarded port (8080 is ubuntu, 80 is your machine), and the RAM for this box.
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
C:\chef\chef-lab
λ vagrant up chef_server
```

This will take a while, if you're in Linux/macOS you might get asked for your password. This is OK.

Once that's done you can open up your browser and go to: `https://chef-server/`

You will get a certificate exception, that's OK you can skip it and continue.

Login with `testlabdev` and password `password`

## Step 2 - Configure ChefDK

Make sure that __ChefDK__ is installed and part of you PATH:

```
C:\chef\chef-lab
λ chef --version
//You should see ChefDK version
```

Your next step is to download Chef Starter Package from you current Chef Server installation:

* Go to [https://chef-server/organizations](https://chef-server/organizations)
* Click __testcheflab__
* On the left menu search for __Starter Kit__ and click on it.
* Click on "Download Starter Kit"
* Click on "Proceed"

This will download a `.zip` file, the objective is two have the `chef-starter-repo` next to `chef-lab` directory.

Unzip the file and you should have something like this:

```
C:\chef\
λ dir
//chef-lab
//chefrepo
```

__Chef repo__ directory is where most of the work would happen. 
Here you will create cookbook, recipes, assign roles to nodes and make tests for you recipes.

The first step is to make contact with Chef server.

```
C:\chef\chef-repo
λ knife ssl fetch
λ knife ssl check
λ chef verify
//This last command will take a while
```

Now you're ready to start creating cookbooks.

## Step 3 - Making your first cookbook.

### Cookbooks
Cookbooks are the fundamental unit of configuration for our Chef infrastructure. Cookbooks are created on the workstation and then uploaded to a Chef server. Cookbooks serve as a logical foundation of directories rather than something concrete. Recipes is where you would do most of the coding.

### Recipes
A recipe is a Ruby file that contains Chef specific domain language to setup you environment. A **cookbook has many recipes**, is a one to many association.

Recipes can be self-contained, using only [Chef Recipes DSL](https://docs.chef.io/dsl_recipe.html) , or they could have external dependencies to other internal/external recipes.

Each recipe is composed by __resources__. Recipes are a list of resources.

### Resources

Chef uses the term __resource__ to describe a part of the system and what state should be in. A __resource__ is, for Chef, a call to their specific API. 

When a recipe runs on a desired node (node are whatever you want to provision with Chef), Chef checks the current state per resource and acts upon the desired state of the recipe.

One of the common __resources__ you will constantly work with is called __templates__.

### Templates

Templates are files that have placeholders for string interpolation, just as Razor templates. The difference between Razor and templates is that templates are written in _erb_ language.

Templates have their own folder structure inside a cookbook. From within the templates you can access [__attributes__](https://docs.chef.io/attributes.html). 

### Leveraging ChefDK to create cookbooks and recipes

By the end of this section you will:

* Create a new nginx cookbook inside the starter folder.
* Create two recipes, one for nginx installation and one for epel packages.
* Create a new template for the index of you nginx installation.

Start by deleting files from starter cookbook you won't need

```
C:\chef\chef-repo
λ rm -rf cookbooks/starter roles/starter.rb
```

Next step is to generate a new cookbook.

```
C:\chef\chef-repo
λ chef generate cookbook nginx
```

A new directory will be created under cookbooks folder. Inside this cookbook folder we will use ChefDK to create two new recipes.

```
C:\chef\chef-repo
λ chef generate recipe cookbooks/nginx epel

C:\chef\chef-repo
λ chef generate recipe cookbooks/nginx nginx
```

Before installing nginx you have to update YUM packages and also install [Epel packages](https://fedoraproject.org/wiki/EPEL/FAQ#What_is_EPEL.3F).

You paste the following __resource statements__ into the new `epel.rb` file:

```
#cookbooks/nginx/recipes/epel.b
execute "yum update" do
  command "yum update"
end

#https://fedoraproject.org/wiki/EPEL/FAQ#What_is_EPEL.3F
yum_package 'epel' do
  action :install
end

```

Add the following __resource statements__ `nginx.rb`:
```
#cookbooks/nginx/recipes/nginx.rb
yum_package 'nginx' do
  action :install
end

template '/usr/share/nginx/www/index.html' do
  source 'index.erb'
  mode '0644'
end

service 'nginx' do
  action :start
end
```

Create a new template with knife:
```
C:\chef\chef-repo
λ chef generate template cookbooks/nginx index.html.erb
```

Paste the following template to `index.html.erb`:

```
<!-- cookbooks/nginx/templates/index.html.erb -->
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Hello world</title>
  <link rel="stylesheet" href="">
</head>
<body>
  <h1>Hi</h1>
  <h2>This is webserver <%= node[:fqdn] %></h2>
</body>
</html>
```

Now you can upload your recipes to Chef server:

```
C:\chef\chef-repo
λ knife cookbook upload --all
```

## Step 4 - Bootstrapping nodes

```
C:\chef\chef-repo
λ vagrant up lb web2 web3
```

```
C:\chef\chef-repo
λ knife bootstrap web3 -x vagrant -P vagrant --sudo --verbose -N web3-node
```


### Step 5 - Adding roles


```
knife node run_list add web3-node "role[lab-linux]"
```


## Step 6 Exercise - Create HA Proxy cookbook.

With the knowledge you have right, you can create another cookbook for your HA Proxy box. What you have to do can be break down like this:

* Create a new cookbook inside `cookbooks` folder.
* Search Google how to install `HAProxy`, once you figure the steps out, translate them to Chef recipe(s).
* `HAProxy` should sit between the two web-servers and your clients, for this you will need to modify `HAProxy` configuration, make sure you create the required templates.  