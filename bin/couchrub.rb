#!/usr/bin/env ruby

# TODO: ssl, better error handling, option parsing, improve everything

require 'json'
require 'net/http'
require 'ostruct'

# I am creating a database class
# The idea is to grab the database from
# couch, preform whatever manipulation
# that you want on it and then sync it back
# up to couch with a new revision number

# the goal here is to abstract out the revisioning
# the merge strategy is to go with the most recent
# version. This introduce races, but I don't care
# right now in this case


# TODO: it would be realy cool to have this
#       inherit a ruby hash

class CouchDocument
    # all documents will be created by json
    # either from the database or internaly

    attr_reader :id, :data
    
    def initialize json
    
        @data = json
        
        @rev = @data['_rev']
        @id  = @data['_id']
        
    end

    # If I inherite Hash then I get these for free
    def [] key
        @data[key]
    end
    
    def []= key, value
        @data[key] = value
    end
    
end

class Couch
        
    def initialize args
        
        # set default host and port
        @host = '127.0.0.1'
        @port = '5984'
        
        # set all the parameters
        args.each do |key, val|
            (instance_variable_set "@#{key}", val) unless val.nil?
        end
        
        @http = Net::HTTP.new @host, @port
        
    end

    # The things that I want right here are:
    #  x create a db
    #  x delete a db
    #  - put new a document
    #  - get a document
    #  - put an updated document
    
    
    # database manipulation
    
    def create_db name
        
        req = Net::HTTP::Put.new "/#{name}"
        ret = @http.request req
        
        puts "Creating Database #{name} => #{ret.msg}\n"
        
    end
    
    def delete_db name
        
        req = Net::HTTP::Delete.new "/#{name}"
        ret = @http.request req
        
        puts "Deleting Database #{name} => #{ret.msg}\n"
        
    end
    
    def get_doc db_name, doc_name
        
        req = Net::HTTP::Get.new "/#{db_name}/#{doc_name}"
        ret = @http.request req
        
        if ret.code == '200'
            puts "Successfuly Got Document #{db_name}/#{doc_name} => #{ret.msg} (#{ret.code})\n"
            doc = CouchDocument.new JSON.parse ret.body
        else
            puts "Error Getting Document #{db_name}/#{doc_name} => #{ret.msg} (#{ret.code})\n"
            doc = CouchDocument.new JSON.parse "{}"
        end
        
        doc
    end
    
    def put_doc db_name, doc_name, doc
        
        req = Net::HTTP::Put.new "/#{db_name}/#{doc_name}"
        req.add_field 'Content-Type', 'application/json'
        req.body = JSON.dump doc.data
        ret = @http.request req
        
        puts "Putting Document #{db_name}/#{doc_name} => #{ret.msg}\n"
        
    end

end


#couch = Couch.new :host => '127.0.0.1', :port => '5984'


#couch.delete_db 'blahness'
#couch.create_db 'blahness'

#test = CouchDocument.new JSON.parse File.read 'blah.json'

#couch.new_doc 'blahness', 'doc', test

#test = couch.get_doc 'testdb', 'dne'

#test['test'] = 'changed value'
#puts test.data

#couch.put_doc 'blahness', 'doc', test
