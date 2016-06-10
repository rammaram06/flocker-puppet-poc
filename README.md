# Flocker Puppet POC
```
Prerequisites:
- Vagrant
- Ruby
```


## The architecture
This Vagrant repo will build two nodes. The first will be the Flocker controller/api node, the second will be a node with Docker and Flocker installed.
It will automate a deployment of Jenkins with a local Flocker volume. 

# Run the environment
```
git clone https://github.com/scotty-c/flocker-puppet-poc.git && cd flocker-puppet-poc
vagrant up
```

## Let's prove it works
Once the environment is up you can access the jenkins console on the following url: 
```
http://172.17.7.102:8080/
```
The login details are :
```
username: admin
password: admin
```

So now make changes in jenkins and do what ever you like. Make sure the changes are all saved. To make sure our data persisted we will login to the box and kill the container.
To do this make sure you are in the root directory of the Vagrant repo and issue:
```
vagrant ssh flocker-02
```
then change to root
```
sudo -i
```
Then issue the command to kill the container
```
docker rm -f jenkins
```
log out of the box completely back to your host machines terminal and run Puppet again.
```
vagrant provision flocker-02
```
Once the Puppet run has completed the container will be back with all your changes.  
