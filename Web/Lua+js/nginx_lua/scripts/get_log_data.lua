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

if (ngx.var.arg_c == nil) or (ngx.var.arg_date == nil) then
	ngx.say("UNDEF")
	ngx.exit(200)
end

local id = 0
if (ngx.var.arg_lastid ~= nil) then
	id = tonumber(ngx.var.arg_lastid)
end

local query = "SELECT * FROM`log`WHERE channel=%d and DATE(log_time)=%s AND id>%d"
query = string.format(query, tonumber(ngx.var.arg_c), ngx.quote_sql_str(ngx.var.arg_date), id);
res, err, errno, sqlstate = db:query(query)
if res then
	ngx.header.content_type = 'application/json';
	ngx.say(cjson.encode(res))
else
	ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
	ngx.exit(500)
end
