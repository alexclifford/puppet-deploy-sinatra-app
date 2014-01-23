# Deploy a Ruby Rack app through Puppet

This Puppet configuration was built on Puppet 2.7 for a Ubuntu 12.04 master/agent environment.

To test this puppetmaster configuration from an agent that is configured in /etc/puppet/manifests/nodes.pp you run:

```
root@ubuntu:~# puppet agent --test
```

The Ruby Rack app will be deployed from a github repository and run on Apache with modpassenger.
