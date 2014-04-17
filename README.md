hiera-enc-http
==============

Description
-----------

This is a back end plugin for Hiera that allows lookup to be sourced from HTTP queries.  The intent is to make this backend adaptable to allow you to query any data stored in systems with a RESTful API such as CouchDB or even a custom store with a web front-end

Example Configuration
---------------------

The following is a quickstart guide of how to get up and running using this hiera backend with CouchDB

Get the CouchDB puppet module

    cd $(puppet master --configprint modulepath | cut -f 1 -d":")
    git clone https://github.com/camptocamp/puppet-couchdb.git

Now lets install CouchDB and hiera-ehttp

couch.pp
    
    # We will just install CouchDB with defualt parameters
    # Not the most secure thing ever but it will do for now
    class { '::couchdb': }
  
    package { 'hiera-ehttp':
      ensure   => 'installed',
      provider => 'gem',
    }

Then apply the manifest with `puppet apply couch.pp`

Then lets create a key/certificate

    mkdir -p /etc/puppet/keys && cd /etc/puppet/keys
    hiera-ehttp keys -n "CN=hiera-http/DC=neverland"
    
You probably want to copy the certificate to whatever machine you use for development
    
By default the certificate is good for one year, both the key and the certificate are needed for decryption,
however only the certificate is needed for encryption.

Then we need to add the backend to our hiera config

hiera.yaml

    ---
    :backends:
      - ehttp

    :ehttp:
      :host: 127.0.0.1
      :port: 5984
      :output: json
      :failure: graceful
      :keyfile: /etc/puppet/keys/key.pem
      :certfile: /etc/puppet/keys/cert.pem
      :paths:
        - /hiera/%{fqdn}
        - /hiera/defaults
        
Now all you need to is create the database and add the document.    


Configuration Parameters
------------------------

The following are optional configuration parameters

`:output:` Specify what handler to use for the output of the request.  Currently supported outputs are plain, which will just return the whole document, or YAML and JSON which parse the data and try to look up the key

`:http_connect_timeout:` Timeout in seconds for the HTTP connect (default 10)

`:http_read_timeout:` Timeout in seconds for waiting for a HTTP response (default 10)

`:failure:` When set to `graceful` will stop hiera-http from throwing an exception in the event of a connection error, timeout or invalid HTTP response and move on.  Without this option set hiera-http will throw an exception in such circumstances

The `:paths:` parameter can also parse the lookup key, eg:

    :paths:
      /configuraiton.php?lookup=%{key}

`:use_ssl:` When set to true, enable SSL (default: false)

`:ssl_ca_cert` Specify a CA cert for use with SSL

`:ssl_cert` Specify location of SSL certificate

`:ssl_key` Specify location of SSL key

`:keyfile:` The private key used when storing encrypted data

`:certfile:` The certificate used when storing encrypted data

If and only if both `:keyfile:` and `:certfile:` are specified then encryption will be enabled

Notes
-----

If you want/need features added and don't hesitate to send a pull request or ask me to add them
for you.

This backend loosely follows the scheme that hiera-eyaml use so there may be some compatibility
between these two projects, but I make no promises.

The encryption support is not very fetured yet, and some things that came from the original
hiera-http backend have not been tested in this backend yet. The moral is if you find a bug,
make an issue so I know, or create a fix and create a pull request.

Credits
-------

* Much of this code comes from the original hiera-http created by Craig Dunn <craig@craigdunn.org>
* SSL components contributed from Ben Ford <ben.ford@puppetlabs.com>
