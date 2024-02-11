function authenticate(user, password, largs)
	
	if user == "" then 
		ngx.status = 401
		ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize(u)'";
		ngx.exit(401)
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
	
	dbuser = ngx.quote_sql_str(user)
	dbpassword = ngx.quote_sql_str(password)
	
	local query = "SELECT 1 AS Ok FROM`users`WHERE login=%s AND pwd=PASSWORD(%s)"				
	query = string.format(query, dbuser, dbpassword);
	res, err, errno, sqlstate = db:query(query)
	if res and res[1] then
		
	else
		ngx.log(ngx.ERR, "=> query failed")
		ngx.status = 401
		ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize(usa)'";
		ngx.exit(401)
	end
end

local header = ngx.req.get_headers()['Authorization']
local args = ""
if(ngx.var.arg_id ~= nil) then
	args = ngx.var.arg_id
else
	args = ngx.var.QUERY_STRING
end

local username = ""
local password = ""

if header ~= nil and  header:find(" ") ~= nil then
    local divider = header:find(' ')
    if header:sub(0, divider-1) ~= 'Basic' then
       return false
    end
    local auth = ngx.decode_base64(header:sub(divider+1))

    if auth == nil or auth:find(':') == nil then
        return false
    end

    divider = auth:find(':')
    username = auth:sub(0, divider-1)

    password = auth:sub(divider+1)
end

authenticate(username, password, args)
