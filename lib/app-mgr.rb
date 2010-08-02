#!/usr/bin/ruby

# file: app-mgr.rb

class AppMgr
  def initialize()
    super()
    @available = {}
    @running = {}
    @variables = {}
  end

  def load(app_name, handler_name)
    @available[app_name] = handler_name
    "'%s' loaded" % app_name
  end

  def run(app_name)
    if self.available? app_name then
      @variables[app_name] = {}
      @running[app_name] = @available[app_name].new(variables: @variables[app_name])

      return "'%s' running ..." % app_name
    else
      return "app %s not available" % app_name
    end      
  end
  
  def connect(app_name)
    if running? app_name 
      yield(@variables[app_name])
    else
      return "app %s not running" % app_name
    end
  end
  
  def execute(app_name, method, params='')
    [@running[app_name].method('call_' + method.gsub(/-/,'_').to_sym).call(params), 'text/xml']
  end

  def running?(app_name)
    @running.has_key? app_name
  end

  def available?(app_name)
    @available.has_key? app_name
  end

  def stop(app_name)
    if @running.delete(app_name) then
      return "app %s stopped" % app_name
    else
      return "couldn't find app %s" % app_name
    end
  end

  def running()
    @running.keys
  end

  def available()
    @available.keys
  end

  def unload(app_name)
    handler_name = @available[app_name].name
    @available.delete(app_name)
    if handler_name then
      Object.send(:remove_const, handler_name)
      return "app %s unloaded" % app_name
    else
      return "couldn't find app %s" % app_name
    end
  end

  def show_public_methods(app_name)
    if running? app_name 
      return @running[app_name].public_methods.map(&:to_s).grep(/call_/).map {|x| x.gsub(/call_/,'').gsub(/_/,'-')}.sort.join(', ')
    else
      return "app %s not running" % app_name
    end
  end
end
