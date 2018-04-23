# Vagrant Chef lab

This Lab is to understand and learn Chef Server with 2 nodes.

## Getting Started

Run start.sh and use chef directory for knife commands.

### Prerequisites

What things you need to install the software and how to install them

* [Git](https://git-scm.com/downloads)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Chef Development Kit - ChefDK](https://downloads.chef.io/chefdk/)

### Running Lab

To start the lab use the start.sh sript:

```
./start.sh
```

To stop the lab use the stop.sh script:

```
./stop.sh
```

#### Test

Test chef connection to chef server:

```
cd chef
knife node list
```

Should be return nothing, without error.

#### Boostrap

To begin the lab, you should add the two nodes to chef server with bootraping the nodes.

```
knife bootstrap web1 -N web1 --sudo -x vagrant -P vagrant
knife bootstrap web2 -N web2 --sudo -x vagrant -P vagrant
```

#### Upload cookbooks

Load first cookbooks to the chef server with berks.

```
berks install
berks upload
```

To test if the cookbooks are on the chef server:

```
knife cookbooks list
```

#### Role

Create the first chef role:

```
knife role create default
kinfe role create chef_client
```

Edit the role and add recipes:

* knife role edit chef_client

```
{
  "name": "chef_client",
  "description": "",
  "json_class": "Chef::Role",
  "default_attributes": {

  },
  "override_attributes": {

  },
  "chef_type": "role",
  "run_list": [
    "recipe[chef-client]"
  ],
  "env_run_lists": {

  }
}
```

* knife role edit default

```
{
  "name": "default",
  "description": "",
  "json_class": "Chef::Role",
  "default_attributes": {

  },
  "override_attributes": {

  },
  "chef_type": "role",
  "run_list": [
    "role[chef_client]"
  ],
  "env_run_lists": {

  }
}
```

Add role to nodes:

* knife node edit web1

```
{
  "name": "web1",
  "chef_environment": "_default",
  "run_list": [
  "role[default]"
]
,
  "normal": {
    "tags": [

    ]
  }
}
```

* knife node edit web2

```
{
  "name": "web2",
  "chef_environment": "_default",
  "run_list": [
  "role[default]"
]
,
  "normal": {
    "tags": [

    ]
  }
}
```

#### chef-client run

Run chef-cient ssh to the node with user vagrant and password vagrant. After the run the chef-client will run every 30 minutes.

```
ssh vagrant@web1
Host key fingerprint is SHA256:85N4OTSgYAuiJ0adXNlkcLcFZRc/nMrmvjuySgmHGpM
+---[RSA 2048]----+
|     o=+ oo+ o.  |
|  o o.o.. + . o .|
|...+o   ..     = |
|o. o o....  . . .|
|o.. .E.oS.o  +   |
|.o    + o=.+o    |
|     .  .oB  .   |
|        .. +..   |
|         ...o++  |
+----[SHA256]-----+
vagrant@web1's password:
Last login: Sun Apr 22 07:54:02 2018 from 10.0.15.1
[vagrant@web1 ~]$ sudo chef-client
```

####

## Built With

* [chef](https://www.chef.io) - Chef Software, Inc
* [Vagrant](https://www.vagrantup.com) - HashiCorp, Inc.
* [VirtualBox](https://www.virtualbox.org) - Oracle

## Contributing

Please read [CONTRIBUTING](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/safematix/chef_lab/tags). 

## Authors

* **Robert Ressl** - *Initial work* - [Robert Ressl](https://github.com/safematix)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the GNU Affero General Public License v3.0 License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

## Thanks to…

* [Hector Yeomans](https://github.com/hyeomans) and his [chef-lab](https://github.com/hyeomans/chef-lab)
