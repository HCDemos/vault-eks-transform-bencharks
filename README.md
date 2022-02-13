# Terraform Provision AWS EKS, Vault and Locust for Vault Benchmarking

This repo can be used to provision the following:

  - an EKS cluster on AWS which is based on the [Provision an EKS Cluster learn guide](https://learn.hashicorp.com/tutorials/terraform/eks) and the [companion repo](https://github.com/hashicorp/learn-terraform-provision-eks-cluster)  

  - A Vault Enterprise 3-pod cluster running on the EKS nodes

  - A set of EC2 nodes running Locust and pre-populated with Vault Transform test data

The intent is to instantiate each set of resources with individual "terraform apply" commands in the order listed above, which should result in a Vault Enterprise cluster running in EKS and a separate set of EC2 instances, running Locust (https://locust.io), that can be used to perform benchmarking tests against the Vault Enterprise cluster.  

*EKS Cluster*
The initial configuration uses t2.medium EC2 instances with GP2 root volumes; you can configure the EKS node EC2 types by editing the "eks-cluster.tf" file and updating the "instance_type" in the "worker_groups" resource and the "root_volume_type" in the "worker_group_defaults" section.  Once testing is completed with one instance type/disk configuration you can update the "eks-cluster.tf" with a new type & disk, then run "terraform apply" to update the resource configuration in AWS, then manually delete (I used the AWS UI), one at a time, each node where vault is running, starting with the "follower" nodes first and finishing with the leader node.  In this way you can quickly update the nodes hosting the pods where Vault is running so that you can obtain Vault benchmarks for different node configurations without having to reconfigure the Vault instances each time.  Once this cluster is deployed, run the following command (from the terraform code directory) to configure kubectl:

aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

*Vault Cluster*
The Terraform code in the ./vault-helm directory deploys Vault using the standard helm chart; currently the code does not configure the instances so this needs to be done manually.  (Note that for Vault 1.8 and higher you'll need to make sure the license file is in place or Vault will not start).  After running terraform apply you should be able to see your Vault instances running but not initialized:

>kubectl get pods
  NAME                                   READY   STATUS    RESTARTS   AGE
  vault-0                                0/1     Running   0          4m4s
  vault-1                                0/1     Running   0          4m4s
  vault-2                                0/1     Running   0          4m4s
  vault-agent-injector-57886cc96-49xsb   1/1     Running   0          4m4s

The directory ./vault-helm/vault-config-commands contains two files with commands for configuring the Vault cluster and the transform secrets engine. The cluster config commands are mostly from this learn guide:  https://learn.hashicorp.com/tutorials/vault/kubernetes-amazon-eks?in=vault/kubernetes

*Locust EC2 Nodes*
This Terraform code uses an AMI that was built using Packer to install Locust, Vault (to be used as a client if needed), and a zip file containing the Locust configuration files, data files to be used for Vault Transform benchmarking, and a script to run the tests.  The Packer HCL configuration file is located in the ./ec2-instances/images directory.  This also references a shell script (setup.sh) which is located in the ./ec2-instances/scripts directory.



