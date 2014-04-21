# This is probably outside of the scope that the gem should
# be doing, but I want this feture so I am putting it in here
# anyways
#
# It will probably be very hacky and barely work but I don't
# expect anyone but me to use it so no loss there

require 'optparse'
require 'ostruct'
require 'json'

require_relative 'couchrub.rb'

module HieraEhttp
    class HieraEhttpCouch
        
        @banner = "Usage: hiera-ehhtp couch [options]"
        
        def self.parse args
            options = OpenStruct.new
            
            # The default host and port
            options.host = '127.0.0.1'
            options.port = '5984'
            
            # The default database and document
            options.database = 'hiera'
            options.document = 'defaults'
            
            options.items = []
            
            opt_parser = OptionParser.new do |opts|
                opts.banner = @banner
                
                opts.on("-i", "--item <\"key\":\"value\">", "Key/value to add") { |item| options.items    << item }
                opts.on("-h", "--host <host>", "Host (defualt 127.0.0.1)")      { |host| options.host     =  host }
                opts.on("-p", "--port <port>", "Port (defualt 5984)")           { |port| options.port     =  port }
                opts.on("-c", "--cert <certificat>", "Encryption certificate")  { |cert| options.cert     =  cert }
                opts.on("-b", "--database <database>", "Database to use")       { |db|   options.database =  db   }
                opts.on("-d", "--document <document>", "Document to use")       { |doc|  options.document =  doc  }
            end
        
            opt_parser.parse! args
            options
        end
    
        def self.go options
            # Read in the certificate
            cert = OpenSSL::X509::Certificate.new File.read options.cert
            
            # create an encrypter to use
            encrypter = Encrypt.new cert
            
            couch = Couch.new :host => options.host, :port => options.port
            
            # We can ensure the db exist by creating it
            # If it alread exist nothing happens
            couch.create_db options.database
            doc = couch.get_doc options.database, options.document

            # Now we update the document
            options.items.each do |item|
                a = /^\"(([^\"]|\\\")+)\":\"(([^\"]|\\\")+)\"$/.match item
                doc[a[1]] = encrypter.encryptPKCS7 a[3]
            end
            
            couch.put_doc options.database, options.document, doc
        end
        
    end # class HieraEhttpCouch
end # module HieraEhttp

