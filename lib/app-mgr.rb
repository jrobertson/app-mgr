#!/usr/bin/ruby

# file: app-mgr.rb

require 'rscript'


class AppMgr

  attr_reader :app

  def initialize(rsf: nil, reg: nil, rsc: nil, debug: true)
    
    @rsf, @reg, @rsc, @debug = rsf, reg, rsc, debug
    @rscript = RScript.new(type: 'app', debug: debug)    
    @app = {}

    load_all(rsf)
    
  end

  def available()
    @app.keys
  end
  
  def call(app_name)
    
    run(app_name) unless running? app_name
    @app[app_name.to_sym][:running].call
    
  end

  def execute(name, method, params='')
    @app[name.to_sym][:running].method(method.to_sym).call(params)
  end

  def run(name)

    app = @app[name.to_sym]
    class_name = app[:code][/(?<=class )\w+/]    
    app[:running] = eval(class_name + '.new')

  end

  def running()
    @app.select {|k,v| v[:running]}.keys
  end

  def running?(name)
    @app[name.to_sym][:running] ? true : false
  end  

  def connect(name)

    app = @app[name.to_sym]
    
    if app and app[:running] then 
      yield(app[:running])
    else
      return "app %s not running" % name
    end
    
  end

  def stop(name)

    app = @app[name.to_sym]

    if app.delete(:running) then
      return "app %s stopped" % name
    else
      return "couldn't find app %s" % name
    end
    
  end

  def unload(name)

    class_name = @app[name.to_sym][:running].class.name
    
    if class_name then
      Object.send(:remove_const, class_name)
      @app.delete name.to_sym
      return "app %s unloaded" % name
    else
      return "couldn't find app %s" % name
    end
    
  end

  private

  def load_all(rsf_package)

    @rscript.jobs(rsf_package).each do |app_name|

      puts 'app_name: ' + app_name.inspect if @debug
      app = @app[app_name] = {}

      codeblock = @rscript.read(['//app:' + app_name.to_s, @rsf]).first      
      puts 'codeblock: ' + codeblock.inspect if @debug
      app[:code] = codeblock
      
      reg, rsc = @reg, @rsc      
      eval codeblock
      
    end

  end

end
