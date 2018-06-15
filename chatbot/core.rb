Bundler.require(:default)
APPDIR=File.dirname(__FILE__)
KEYS = JSON.parse(File.open("#{APPDIR}/keys.json").read)
CMDRSHEPARD=true;
begin
    con=PG.connect :dbname =>'CmdrShepard_development', :user=>'postgres'
    puts con.server_version
rescue => exception
    
end

