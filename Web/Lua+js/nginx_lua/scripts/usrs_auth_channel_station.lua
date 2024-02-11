function authenticate(user, password, lchannels, lkeys)
		
	if user == "" then 
		ngx.status = 401
		ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize'";
		ngx.exit(401)
	end

	
	local 
	
	local dbsettings = require("scripts.t2settings");
	local t2u = require("scripts.t2utils");
	local mysql = require "resty.mysql"
	local db, err, errno, sqlstate, res, ok
	
	db = mysql:new()
	if not db then
		ngx.log(ngx.ERR, "Failed to create mysql object")
		ngx.exit(500)
	end

	-- dbsettings.logIt("largs:" .. largs);
	
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
	
	--local t_args = t2u.splitKeys(largs)
	local t_channels = t2u.splitKeys(lchannels)
	local t_keys     = t2u.splitKeys(lkeys)
	--local t_args = t2u.split(largs, ",")
	local keyfnd = true
	
	-- pull keys assigned to user 
	local u_keys = t2u.pullKeysForUser(user)
	
	ngx.log(ngx.ERR, "ukeys: ", cjson.encode(u_keys))
 	
	local guc = ngx.shared.g_userchannels
		
	for i = 1, #t_channels do
		local kval = t_channels[i]
		if kval ~= nil and type(kval) ~= "userdata" then
			local lkey = user .. "=" .. kval
			local lg, lf = guc:get(lkey)
			if lg == nil then
				keyfnd = false
				break
			end
		else
			ngx.log(ngx.ERR, "malformed request => ", kval)
			keyfnd = false
			break
		end
	end
	
	-- key not found? => update cache from DB!
	-- pwd is not in the cache? => update cache from DB!
	--if keyfnd ~= true or authneeded == true then 
	if keyfnd ~= true then 	
		-- ngx.log(ngx.ERR, "Some keys are not in cache! => querying the DB.")
		dbuser = ngx.quote_sql_str(user)
		dbpassword = ngx.quote_sql_str(password)
		-- ngx.log(ngx.ERR, "dbuser=>", dbuser)
		-- ngx.log(ngx.ERR, "dbpassword=>", dbpassword)
		
		local query = "SELECT channels FROM `users` WHERE login=%s AND pwd=PASSWORD(%s)"				
		query = string.format(query, dbuser, dbpassword);
		res, err, errno, sqlstate = db:query(query)
		if res and res[1] then
		
			-- update pwd cache
			-- local udbpwd = res[1]["user_password"]
			-- gup:set(user, udbpwd)
			
			-- phpBB setup - end of
			--	local sdbkeys = res[1]["pf_tele_keys"]
			-- custom setup
			local sdbkeys = res[1]["channels"]
			--ngx.log(ngx.ERR, "keys=>", sdbkeys)

			local t_dbkeys = t2u.splitKeys(sdbkeys)
			--local t_dbkeys = t2u.split(sdbkeys, ",")
			-- ngx.log(ngx.ERR, "targs=>", cjson.encode(t_args))
			-- ngx.log(ngx.ERR, "keys=>", cjson.encode(t_dbkeys))
		
			-- update global user-key pairs cache
			for k,v in pairs(t_dbkeys) do
				local lkey = user .. "=" .. v
				guc:set(lkey, 1)
			end
		
			-- ngx.log(ngx.ERR, "[2]=> cache size is ", table.getn(guc))
			keyfnd = true
			for i = 1, #t_args do
				local kval = t_args[i]
				if kval ~= nil and type(kval) ~= "userdata" then
					local lkey = user .. "=" .. kval
					-- ngx.log(ngx.ERR, "searching for ", lkey, " lkey")
					local lg, lf = guc:get(lkey)
					if lg == nil then
						keyfnd = false
						break
					end
				else
					ngx.log(ngx.ERR, "malformed request => ", kval)
					keyfnd = false
					break
				end
			end
			
			if keyfnd ~= true then
				ngx.status = 401
				ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize(u)'";
				ngx.exit(401)
			end
		else
			ngx.log(ngx.ERR, "=> query failed")
			ngx.status = 401
			ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize(u)'";
			ngx.exit(401)
		end
	end
	
	
	
end

local header = ngx.req.get_headers()['Authorization']
--local args = ""
local channels = ngx.var.arg_c
local keys = ngx.var.arg_id

ngx.log(ngx.ERR, "vars")
ngx.log(ngx.ERR, ngx.var.arg_id)
ngx.log(ngx.ERR, ngx.var.arg_c)

if (channels ~= nil) and (keys ~= nil) then
	-- ngx.log(ngx.ERR, "ngx.var.arg_c=", ngx.var.arg_c)
	args = ngx.var.arg_c
else
	ngx.log(ngx.ERR, "=> Auth data not found")
	ngx.status = 401
	ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize'";
	ngx.exit(401)
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

authenticate(username, password, channels, keys)
