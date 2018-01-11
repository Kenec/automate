#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# This script sets up the VPC network and creates two subnets in the network.
# One is private subnet and the second is public subnet.
# Firewall rule will be created to allow access (tcp,udp,icmp ports) internally within the VPC
# Firewall rule will also be created to allow ssh access
# NAT gateway instance will be created in the public subnet so that instances running in private subnet can access the internet
# Two private instances will be created in the private subnet and will house the postgres database and a node app respectively
# Route table will be created to allow all instances running in private subnet to access the internet
# LoadBalancer instance will be created in public subnet for internet facing of the private instances


# set up the vpc network
create_vpc_network() {
  echo "setting up the GCP VPC network ...."
  gcloud compute networks create gcp-devops-vpc --subnet-mode custom
  echo "VPC network created successfully!"
}

# creat two subnets
create_subnets() {
  echo "creating subnets ....."
  gcloud compute networks subnets create gcp-devops-private-subnet \
   --network gcp-devops-vpc \
   --region us-central1 \
   --range 10.0.1.0/24 \
   --enable-private-ip-google-access
   
   gcloud compute networks subnets create gcp-devops-public-subnet \
   --network gcp-devops-vpc \
   --region us-central1 \
   --range 10.0.2.0/24 \
   --no-enable-private-ip-google-access

   echo "Subnets created!!"
}

# create a firewall rule to allow (tcp,udp,icmp ports)
create_firewall_rule() {
  echo "Creating tcp, udp, icmp ports firewall rules ......"
  gcloud compute firewall-rules create gcp-devops-firewall-allow \
  --allow tcp:1-65535,udp:1-65535,icmp \
  --source-ranges 10.0.0.0/16 \
  --network gcp-devops-vpc

  gcloud compute firewall-rules create gcp-devops-allow-ssh \
  --allow tcp:22 \
  --network gcp-devops-vpc

  echo "Firewall rule created successfully!!"
}

# create a NAT gateway in the public subnet
create_nat_gateway() {
  echo "Setting up the NAT gateway ...."
  gcloud compute instances create gcp-devops-nat-gateway \
  --network gcp-devops-vpc \
  --can-ip-forward \
  --zone us-central1-a \
  --image-family debian-8 \
  --image-project debian-cloud \
  --tags nat-instance

  echo "NAT gateway created!!!"
}

# create two private instance
create_private_instances() {
  echo "Creating private instances ...."
  gcloud compute instances create gcp-devops-postgres-private-instance \
  --network gcp-devops-vpc \
  --no-address \
  --zone us-central1-a \
  --image-family debian-8 \
  --subnet gcp-devops-private-subnet \
  --image-project debian-cloud \
  --tags private-instance

  gcloud compute instances create gcp-devops-postit-private-instance \
  --network gcp-devops-vpc \
  --no-address \
  --zone us-central1-a \
  --image-family debian-8 \
  --subnet gcp-devops-private-subnet \
  --image-project debian-cloud \
  --tags private-instance

  echo "Private instances created successfully!!!"
}

# create a route table to allow instance on private subnet to access the internet
create_route_table() {
  echo "Creating the route ...."
  gcloud compute routes create gcp-devops-no-ip-internet-route \
  --network gcp-devops-vpc \
  --destination-range 0.0.0.0/0 \
  --next-hop-instance gcp-devops-nat-gateway \
  --next-hop-instance-zone us-central1-a \
  --tags private-instance \
  --priority 800

  echo "Configuring the route ...."
  gcloud compute ssh gcp-devops-nat-gateway --zone us-central1-a
  echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
  sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

  exit

  eval `ssh-agent`
  ssh-add ~/.ssh/google_compute_engine

  echo "Route table created and configured successfully!!"
}

# create a public facing load balancer
create_load_balancer() {
  echo "Creating a Load Balancer ....."

  

}