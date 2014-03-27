# Introducing the app-mgr gem

    require 'app-mgr'

    app = AppMgr.new

    class Fun_handler
      def initialize(opt={})
        opt[:variables][:evening] = true    
      end

      def call_level8(params='')
        '&lt;result&gt;we are here&lt;/result&gt;'
      end
    end

    app.load 'fun', Fun_handler
    #=&gt; "'fun' loaded"

    app.run 'fun'
    #=&gt; "'fun' running ..."

    app.execute 'fun', 'level8',''
    #=&gt; ["&lt;result&gt;we are here&lt;/result&gt;", "text/xml"]

    puts app.connect('fun') {|h| h.inspect}
    {:evening=&gt;true}

    app.connect('fun') do |h|
      h[:start] = Time.now
    end

    puts app.connect('fun') {|h| h.inspect}
    #=&gt; {:evening=&gt;true, :start=&gt;2010-08-02 18:49:40 +0100}
    
The app-mgr gem is used to load, run, and execute ProjectX applications.

