# Using the App-mgr gem


## Usage

    require 'rsc'
    require 'app-mgr'
    require 'remote_dwsregistry'

    reg = RemoteDwsRegistry.new(domain: 'reg')
    rsc = RSC.new 'rse', 'http://a0.jamesrobertson.eu/qbx/r/dandelion_a3'

    apps = AppMgr.new(rsf: '/home/james/app-mgr/default.rsf', rsc: rsc, reg: reg)    

    apps.run 'bintimes'
    apps.running
    apps.running? 'bintimes'
    #apps.stop 'bintimes'
    #apps.running? 'bintimes'
    apps.connect('bintimes') {|x| x.call }

## Resources

* app-mgr https://rubygems.org/gems/app-mgr

appmgr app apps manager gem
