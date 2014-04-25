exec = require('child_process').exec

child = exec "ec2-describe-instances | grep -E 'INSTANCE(.*)ec2|TAG(.*)Name' | grep -A 1 INSTANCE", (error, stdout, stderr) ->
  hosts = []
  instances = stdout.split "--"
  instances.forEach (instance) ->
    [empty, info, tag, rest...] = instance.split '\n'
    host = info.split('\t')[3]
    name = tag.split('\t')[-1..][0].replace ///\s\((.*)\)$///, ""
    hosts.push """
      Host #{name.toLowerCase()}
           HostName #{host}
           Port 22
           User ubuntu
           IdentityFile ~/.ssh/innometrics.pem
    """ if host and name

  configFile = """
    IdentityFile ~/.ssh/id_rsa
    IdentityFile ~/.ssh/dcguiprod.pem
    IdentityFile ~/.ssh/innometrics.pem

    Host *
      ServerAliveInterval 60

  """

  configFile += hosts.sort().join '\n\n'

  console.log configFile
