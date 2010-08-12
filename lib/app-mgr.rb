#!/usr/bin/ruby

# file: app-mgr.rb
class AppMgr
  def initialize(content_type)
    @app = {}
    @content_type = content_type
    super()
  end

  def load(opt={})        
    o = {name: '', object: nil, config: {}, public: {}}.merge!(opt)

    key, name = o.shift
    @app[name] = o
    "'%s' loaded" % name
  end

  def run(app_name)
    app = @app[app_name]
    if app then
      options = {public: app[:public]}
      options[:config] = app[:config] unless app[:config].empty?
      app[:running] = app[:object].new(options)

      return "'%s' running ..." % app_name
    else
      return "app %s not available" % app_name
      end      
  end
  
  def connect(app_name)
    app = @app[app_name]
    if app and app[:running] then 
      yield(app[:public])
    else
      return "app %s not running" % app_name
    end
  end
  
  def execute(app_name, method, params='')
    @app[app_name][:running].method('call_' + method.gsub(/-/,'_').to_sym).call(params)
  end

  def stop(app_name)
    if @app[app_name].delete(:running) then
      return "app %s stopped" % app_name
    else
      return "couldn't find app %s" % app_name
    end
  end

  def running()
    @app.select {|k,v| v[:running]}.keys
  end

  def running?(app_name)
    @app[app_name][:running]
  end  
  
  def available()
    @app.select {|k,v| v[:available] == true}.keys
  end

  def unload(app_name)

    handler_name = @app[app_name][:running].name
    
    if handler_name then
      Object.send(:remove_const, handler_name)
      @app.delete app_name
      return "app %s unloaded" % app_name
    else
      return "couldn't find app %s" % app_name
    end
  end

  def show_public_methods(app_name)
    app = @app[app_name]
    if app and app[:running] then
      return app[:running].public_methods.map(&:to_s).grep(/call_/).map {|x| x.gsub(/call_/,'').gsub(/_/,'-')}.sort.join(', ')
    else
      return "app %s not running" % app_name
    end
  end

  
  def run_projectx(project_name, method_name, qparams=[])

    params = "<params>%s</params>" % qparams.map{|k,v| "<param var='%s'>%s</param>" % [k,v]}.join
    xml_project = project = "<project name='%s'><methods><method name='%s'>%s</method></methods></project>" % [project_name, method_name, params]
    projectx_handler(xml_project)
  end
  
  private
  
  def projectx_handler(xml_project)
    out = ''
    doc = Document.new(xml_project)
    project_name = doc.root.attribute('name').to_s

    if self.running? project_name then

      out = XPath.match(doc.root, 'methods/method').map  do |node_method|
        method = node_method.attributes.get_attribute('name').to_s
        params = node_method.elements['params'].to_s

        method_out, @content_type = @@app.execute(project_name, method, params)
        method_out
      end

      out = out.first if out.length == 1
    else
      out = "that project doesn't exist"
    end
    @content_type ||= 'text/xml'
  
    out
  end


  
end

