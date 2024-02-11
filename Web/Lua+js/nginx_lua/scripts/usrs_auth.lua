-- function authenticate(user, password, group)
function authenticate(user, password, largs)
		
	if user == "" then 
		ngx.status = 401
		ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize(u)'";
		ngx.exit(401)
	end
	
	local dbsettings = require("scripts.t2settings");
	local t2u = require("scripts.t2utils");
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
	
	local t_args = t2u.splitKeys(largs)
	-- local t_args = t2u.split(largs, ",")
	
	local keyfnd = true
	
	local guk = ngx.shared.g_userkeys
		
	for i = 1, #t_args do
		local kval = t_args[i]
		if kval ~= nil and type(kval) ~= "userdata" then
			local lkey = user .. "=" .. kval
			local lg, lf = guk:get(lkey)
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
		
		local query = "SELECT tele_keys FROM `users` WHERE login=%s AND pwd=PASSWORD(%s)"				
		query = string.format(query, dbuser, dbpassword);
		res, err, errno, sqlstate = db:query(query)
		if res and res[1] then
		
			-- update pwd cache
			-- local udbpwd = res[1]["user_password"]
			-- gup:set(user, udbpwd)
			
			-- phpBB setup - end of
			--	local sdbkeys = res[1]["pf_tele_keys"]
			-- custom setup
			local sdbkeys = res[1]["tele_keys"]

			local t_dbkeys = t2u.splitKeys(sdbkeys)
			--local t_dbkeys = t2u.split(sdbkeys, ",")
		
			-- update global user-key pairs cache
			for k,v in pairs(t_dbkeys) do
				local lkey = user .. "=" .. v
				guk:set(lkey, 1)
			end
		
			-- ngx.log(ngx.ERR, "[2]=> cache size is ", table.getn(guk))
			keyfnd = true
			for i = 1, #t_args do
				local kval = t_args[i]
				if kval ~= nil and type(kval) ~= "userdata" then
					local lkey = user .. "=" .. kval
					-- ngx.log(ngx.ERR, "searching for ", lkey, " lkey")
					local lg, lf = guk:get(lkey)
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

-- ngx.log(ngx.ERR, "")

-- for k1, v1 in pairs(ngx.shared) do
	-- --ngx.log(ngx.ERR, k1, "=>", tostring(v1))
	-- if (k1 == "g_uservskeyslist1") then
		-- ngx.log(ngx.ERR, k1, "=>")
		-- local tbl = ngx.shared[k1]
		-- --ngx.log(ngx.ERR, cjson.encode(tbl))
		-- local keys = tbl:get_keys(1024)
		-- ngx.log(ngx.ERR, cjson.encode(keys))
		
		-- for k2, v2 in pairs(keys) do
			-- ngx.log(ngx.ERR, ">", v2)
			-- local lg, lf = tbl:get(v2)
				-- ngx.log(ngx.ERR, "keys: ", lg)
		-- end
	-- end
-- end

local header = ngx.req.get_headers()['Authorization']
local args = ""

--ngx.log(ngx.ERR, "ngx.var.arg_id=", ngx.var.arg_id)
if(ngx.var.arg_id ~= nil) then
	args = ngx.var.arg_id
else
	--ngx.log(ngx.ERR, "QUERY_STRING=", ngx.var.QUERY_STRING)
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

--if username ~= nil then
-- ngx.log(ngx.ERR, "=>(u) ngx.var.remote_user=", ngx.var.remote_user)
if ngx.var.remote_user == nil then
		--ngx.log(ngx.ERR, "=> ngx.var.remote_user=", ngx.var.remote_user)
		-- ngx.log(ngx.ERR, "=>(u) name yourself!")
-- else
    -- ngx.status = 401
    -- ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize'";
    -- ngx.exit(401)
end 

authenticate(username, password, args)
