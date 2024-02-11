--
-- change "cookie_domain" to variable !
--
-- local cookie_domain = "83.166.240.102"
local cookie_domain = "127.0.0.1"
-- local db_username = "root"
-- local db_password = "1qaz2wsx3edc"
-- local db_username = "t2user"
-- local db_password = "8UgpboGjmRguEmvh"

-- *nix version
--local db_socket = "/run/mysqld/mysqld.sock"
-- *nix version - end of

-- local setup
local db_username = "root"
local db_password = ""


-- Windows version
local db_host = "127.0.0.1"
local db_port = "3306"
-- Windows version - end of
local db_name = "t2u"

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function splitKeys(str)
	local las = str
  local t = {}
	-- ngx.log(ngx.ERR, "las: ", las)
	-- filter out id=Gkey form
	if las ~= nil then
		local p1 = las:find('=')
		if p1 ~= nil then
			las = las:sub(p1 + 1)
		end
		
		i = 1
		t = split(las, ",")
	end
-- debug output
--		for k,v in pairs(t) do
--			ngx.log(ngx.ERR, "t[", k, "]=", v)
--		end
-- debug output - end of	
	return t
end

-- function authenticate(user, password, group)
function authenticate(user, password, largs)
		
	if user == "" then 
		ngx.status = 401
		ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize(u)'";
		ngx.exit(401)
	end

	local mysql = require "resty.mysql"
	local db, err, errno, sqlstate, res, ok
	
	db = mysql:new()
	if not db then
		ngx.log(ngx.ERR, "Failed to create mysql object")
		ngx.exit(500)
	end

	db:set_timeout(2000)
	ok, err, errno, sqlstate = db:connect{
-- *nix version
--        path = db_socket,
-- *nix version - end of
-- Windows version
			host = db_host,
			port = db_port,
-- Windows version - end of
			database = db_name,
			user = db_username,
			password = db_password
	}

	if not ok then
			ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
			ngx.exit(500)
	end
	
	local t_args = splitKeys(largs)
	local keyfnd = true
	
	local guhprk = ngx.shared.g_hlsprotkeys
		
	for i = 1, #t_args do
		local kval = t_args[i]
		if kval ~= nil and type(kval) ~= "userdata" then
			local lkey = user .. "=" .. kval
			local lg, lf = guhprk:get(lkey)
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
		
		local query = "SELECT hls_priv_keys FROM `users` WHERE login=%s AND pwd=PASSWORD(%s)"				
		query = string.format(query, dbuser, dbpassword);
		res, err, errno, sqlstate = db:query(query)
		if res and res[1] then
			-- update pwd cache
			-- local udbpwd = res[1]["user_password"]
			-- gup:set(user, udbpwd)
			
			local sdbkeys = res[1]["hls_priv_keys"]
			local t_dbkeys = splitKeys(sdbkeys)
			
			-- update global user-key pairs cache
			for k,v in pairs(t_dbkeys) do
				local lkey = user .. "=" .. v
				guhprk:set(lkey, 1)
			end
		
			-- ngx.log(ngx.ERR, "[2]=> cache size is ", table.getn(guhprk))
			keyfnd = true
			for i = 1, #t_args do
				local kval = t_args[i]
				if kval ~= nil and type(kval) ~= "userdata" then
					local lkey = user .. "=" .. kval
					-- ngx.log(ngx.ERR, "searching for ", lkey, " lkey")
					local lg, lf = guhprk:get(lkey)
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
local args = ngx.var.QUERY_STRING

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
		ngx.log(ngx.ERR, "=>(u) name yourself!")
-- else
    -- ngx.status = 401
    -- ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize'";
    -- ngx.exit(401)
end 

authenticate(username, password, args)
