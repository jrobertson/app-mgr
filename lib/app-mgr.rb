#!/usr/bin/ruby

# file: app-mgr.rb

require 'rscript'

class Runner
  def run(s)
    eval(s)
  end
end


class AppMgr

  def initialize(rsf: nil, type: 'app', debug: false)

    @rsf, @type, @debug = rsf, type, debug
    @rscript = RScript.new(type: type, cache: nil, debug: debug)
    @app = {}

    load_all(rsf)

  end

  def [](name)

    app = @app[name.to_sym]

    return app[:running] if app and app[:running]

  end

  def available()
    @app.keys
  end

  def restart(name)
    load_app(name)
    run(name)
    name.to_s + ' restarted'
  end

  def run(name)

    app = @app[name.to_sym]

    #app[:running] = eval(app[:code])
    app[:running] = Runner.new.run(app[:code])

  end

  def running()
    @app.select {|k,v| v[:running]}.keys
  end

  def running?(name)
    @app[name.to_sym][:running] ? true : false
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

    app = @app[name.to_sym]

    if class_name then

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

      @app[app_name] = {}
      codeblock, _, attr = @rscript.read(["//#{@type}:" + app_name.to_s, @rsf])

      next if attr[:disabled] == 'true'

      puts 'codeblock: ' + codeblock.inspect if @debug
      @app[app_name][:code] = codeblock
      app = @app[app_name]

      puts 'app: ' + app.inspect
      next unless app

      app[:running] = Runner.new.run(app[:code])

    end

    def load_app(name)

      codeblock, _, attr = @rscript.read(["//#{@type}:" + name.to_s, @rsf])

      return if attr[:disabled] == 'true'

      puts 'codeblock: ' + codeblock.inspect if @debug
      @app[name][:code] = codeblock
      return @app[name]
    end

  end

end
