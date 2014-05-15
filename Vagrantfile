# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "hashicorp/precise64"

    config.vm.define "db1" do "db"
        db.vm.provision "shell", path: "db1.sh"
        db.vm.network "private_network", ip: "192.168.50.101"
    end

    config.vm.define "db2" do "db"
        db.vm.provision "shell", path: "db2.sh"
        db.vm.network "private_network", ip: "192.168.50.102"
    end

    config.vm.define "db3" do "db"
        db.vm.provision "shell", path: "db3.sh"
        db.vm.network "private_network", ip: "192.168.50.103"
    end
end
