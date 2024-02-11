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

-- Windows version
local db_host = "127.0.0.1"
local db_port = "3306"
-- Windows version - end of
local db_name = "t2u"

-- local setup
local db_username = "root"
local db_password = ""


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

function checkkey(akey)

	--local t_args = splitKeys(largs)
	local keyfnd = true
	
	local guhpubk = ngx.shared.g_hlspubkeys
		
	local lg, lf = guhpubk:get(akey)
	if lg == nil then
		keyfnd = false
	end
	
	if keyfnd == true then
		return
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
	
	-- key not found? => update cache from DB!
	-- pwd is not in the cache? => update cache from DB!
	if keyfnd ~= true then 	
		local query = "SELECT group_desc FROM `key_groups` WHERE group_name = 'hls_public_keys'"
		res, err, errno, sqlstate = db:query(query)
		if res and res[1] then
			
			local sdbkeys = res[1]["group_desc"]
			sdbkeys = string.gsub(sdbkeys, "<t>", "");
			sdbkeys = string.gsub(sdbkeys, "</t>", "");
			
			local t_dbkeys = splitKeys(sdbkeys)
			
			-- update global public access keys
			keyfnd = false
			for k,v in pairs(t_dbkeys) do
				--local lkey = user .. "=" .. v
				local curkey = v
				if akey == curkey then
					keyfnd = true
					-- ngx.log(ngx.ERR, "[2]=> found!")
				end
				-- ngx.log(ngx.ERR, "=>(p) key()=", v)
				guhpubk:set(v, 1)
			end
		
			-- ngx.log(ngx.ERR, "[2]=> keyfnd is ", keyfnd)
			if keyfnd ~= true then
				ngx.status = 404
				-- ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize(u)'";
				ngx.exit(404)
			end
			
		else
			ngx.log(ngx.ERR, "=> query failed")
			ngx.status = 500
			--ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize(u)'";
			ngx.exit(500)
		end
	end
end

local key0=string.gsub(ngx.var.uri,"/hls_get/","")
local p = string.find(key0, "/")
local key = string.sub(key0, 1, p - 1)

checkkey(key)
