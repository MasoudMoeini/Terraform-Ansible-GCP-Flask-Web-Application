# Terraform Ansible GCP Flask Web Application
[Reference 1](https://cloud.google.com/docs/terraform/get-started-with-terraform) <br/>
[Reference 2](https://github.com/antonputra/tutorials/tree/main/lessons/101)<br/>
Milestones:<br/>
- Configuration of Google Cloud Platform<br/>
- Set up terraform infrastructure <br/>
- Set up Ansible PlayBook <br/>
## GCP Configuration
To enable terraform to access GCP you need pair ssh key configuration between your local machine and GCP<br/>
GCP Consule-> Your Project Dashboard-> Compute Engine-> METADATA--> SSH keys <br/>
Copy public key from folowing commands into GCP <br/>
```
ssh-keygen -t ed25519 -f ~/.ssh/ansbile_17bae99b3a0c -C ansible-flask-app
```
```
cat ~/.ssh/ansbile_17bae99b3a0c.pub
```
## Set up terraform 
```
terraform init
```
```
terraform plan 
```
```
terraform apply 
```
In case of error handelling
``` 
terraform plan -refresh-only
terraform apply -refresh-only
```
Terraform prints the VM's external IP address and port 5000 has been set in firewall configuration to access vm<br/>
Web-server-URL(flask_ip:5000):<br/>
```
http://IP_ADDRESS:5000
```
At any time to acces ip address by:
```
terraform output
```
You should see something similar in browser:<br/>
```
```
To remove resources:
```
terraform destroy
```
```
rm ~/.ssh/ansbile*
```
Delete SSH public key from GCP project


