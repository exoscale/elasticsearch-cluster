# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Exoscale (cloudstack) settings
# Mandatory settings
CLUSTER_SIZE=(ENV['CLUSTER_SIZE'] || "3").to_i
CLUSTER_NAME= ENV['CLUSTER_NAME'] || "search_cluster"
EXOSCALE_API_KEY = ENV['EXOSCALE_API_KEY']
EXOSCALE_API_SECRET = ENV['EXOSCALE_API_SECRET']
# Optional
EXOSCALE_TEMPLATE = ENV['EXOSCALE_TEMPLATE'] || "6bcd8b76-b8c6-4627-a57f-967c116acd61" # Ubuntu 14.04, 50GB disk
EXOSCALE_INSTANCE_TYPE = ENV['EXOSCALE_INSTANCE_TYPE'] || "b6e9d1e8-89fc-4db3-aaa4-9b4c5b1d0844" # Medium - 4GB ram, 2 CPU
EXOSCALE_KEYPAIR = ENV['EXOSCALE_KEYPAIR'] || "default"
EXOSCALE_ZONE = ENV['EXOSCALE_ZONE'] || "1128bd56-b4d9-4ac6-a7b9-c715b187ce11"
EXOSCALE_HOST = ENV['EXOSCALE_HOST'] || "api.exoscale.ch"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.hostmanager.manage_host = true
  config.vm.box = "sincerely/trusty64"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provider "cloudstack" do |cloudstack, override|
    config.vm.box = "exoscale"
    cloudstack.user_data = "#cloud-config\nmanage_etc_hosts: true\nfqdn: search\n"
    cloudstack.display_name = "search"
    cloudstack.host = EXOSCALE_HOST
    cloudstack.path = "/compute"
    cloudstack.port = 443
    cloudstack.scheme = "https"
    cloudstack.network_id = "00304a04-c7ea-4e77-a786-18bc64347bf7"
    cloudstack.template_id = EXOSCALE_TEMPLATE
    cloudstack.zone_id = EXOSCALE_ZONE
    cloudstack.network_type = "Basic"
    cloudstack.api_key = EXOSCALE_API_KEY
    cloudstack.secret_key = EXOSCALE_API_SECRET
    cloudstack.service_offering_id = EXOSCALE_INSTANCE_TYPE
    cloudstack.keypair = EXOSCALE_KEYPAIR
    override.ssh.username = "root"
    override.ssh.private_key_path = "~/.ssh/id_rsa"
  end

  config.vm.provision :shell, inline: "test -x /usr/bin/puppet || (apt-get update && apt-get -qy install puppet)"
  config.vm.provision :hostmanager

  CLUSTER_SIZE.times do |i|

    config.vm.define "search#{i}" do |node|
      node.vm.hostname = "search#{i}"
      node.vm.provision :puppet do |puppet|
        puppet.manifest_file = "elasticsearch.pp"
        puppet.manifests_path = "manifests"
        puppet.module_path = "modules"
        puppet.facter = {
          "vagrant" => 1,
          "cluster_members" => CLUSTER_SIZE.times.map{ |i| "search#{i}"}.join(","),
          "cluster_quorum" => ((CLUSTER_SIZE / 2) + 1).to_i,
          "cluster_name" => CLUSTER_NAME
        }
      end
    end
  end

end
