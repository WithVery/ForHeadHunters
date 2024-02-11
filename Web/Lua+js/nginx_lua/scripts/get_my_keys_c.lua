local header = ngx.req.get_headers()['Authorization']

local username = ""

if header ~= nil and  header:find(" ") ~= nil then
    local divider = header:find(' ')
    if header:sub(0, divider-1) ~= 'Basic' then
       return
    end
    local auth = ngx.decode_base64(header:sub(divider+1))

    if auth == nil or auth:find(':') == nil then
        return 
    end

    divider = auth:find(':')
    username = auth:sub(0, divider-1)
end

if username == "" then 
	ngx.say("UNDEF")
	ngx.exit(200)
end
	
local dbsettings = require("scripts.t2settings");
local mysql = require "resty.mysql"
local db, err, errno, sqlstate, res, ok

db = mysql:new()
if not db then
	ngx.log(ngx.ERR, "Failed to create mysql object")
	ngx.exit(500)
end

db:set_timeout(2000)
ok, err, errno, sqlstate = db:connect{
	host     = dbsettings.MysqlHost,
	port     = dbsettings.MysqlPort,
	database = dbsettings.MysqlDBName,
	user     = dbsettings.MysqlLogin,
	password = dbsettings.MysqlPassword
}

if not ok then
	ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
	ngx.exit(500)
end
	
local query = "SELECT hls_priv_keys AS keysc FROM`users`WHERE login=%s"
query = string.format(query, ngx.quote_sql_str(username));
res, err, errno, sqlstate = db:query(query)
if res then
	ngx.header.content_type = 'application/json';
	ngx.say(cjson.encode(res))
else
	ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
	ngx.exit(500)
end
