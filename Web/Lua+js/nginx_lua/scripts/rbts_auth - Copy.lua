--
-- change "cookie_domain" to variable !
--
-- local cookie_domain = "83.166.240.102"
local cookie_domain = "127.0.0.1"
-- local db_username = "root"
-- local db_password = "1qaz2wsx3edc"
local db_username = "phpBB_dbuser"
local db_password = "sVZcUIuKW6lqrN4U"

-- *nix version
--local db_socket = "/run/mysqld/mysqld.sock"
-- *nix version - end of

-- Windows version
local db_host = "127.0.0.1"
local db_port = "3306"
-- Windows version - end of
local db_name = "tele2u"

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
		
	-- ngx.log(ngx.ERR, "largs=>", largs)
	-- ngx.log(ngx.ERR, "user=>", user)
	-- ngx.log(ngx.ERR, "password=>", password)

	if user == "" then 
		ngx.status = 401
		ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize(u)'";
		ngx.exit(401)
	end
	
	local bit = require("bit");
	
	local original = user;
	local encrypted = "";
	local key = 'x';

	for i = 1, string.len(original) do
		local tmp = 
		encrypted.AppendFormat("%x", int(char(original[temp])) ^ (int(key) + temp) % 255);
		
		encrypted.AppendFormat("%x", int(char(original[temp])) ^ (int(key) + temp) % 255);
		-- local kval = t_args[i]
		-- if kval ~= nil and type(kval) ~= "userdata" then
			-- -- local lkey = user .. "=" .. kval
			-- -- local lg, lf = guk:get(lkey)
			-- -- local lg, lf = guk:get(lkey)
			-- if kval ~= user then
				-- keyfnd = false
				-- break
			-- end
		-- else
			-- ngx.log(ngx.ERR, "malformed request => ", kval)
			-- keyfnd = false
			-- break
		-- end
	end
	
	for (int temp = 0; temp < original.GetLength(); temp++){
		encrypted.AppendFormat("%x", int(char(original[temp])) ^ (int(key) + temp) % 255);
	}
	encrypted.MakeUpper();
	
	local resty_sha1 = require "resty.sha1"

   local sha1er = resty_sha1:new()
	if not sha1er then
		ngx.log(ngx.ERR, "failed to create the sha1 object")
		return
	end

	local ok = sha1er:update(password)
	if not ok then
		ngx.log(ngx.ERR, "failed to add data")
		return
	end
	
	local digest = sha1er:final();
	--ngx.log(ngx.ERR, "PWD0=>", digest)

  local sha1er2 = resty_sha1:new()
	if not sha1er2 then
		ngx.log(ngx.ERR, "failed to create the sha1 object (2)")
		return
	end

	local ok2 = sha1er2:update(digest)
	
	if not ok2 then
		ngx.log(ngx.ERR, "failed to add data (2)")
		return
	end
	
	digest = sha1er2:final();
	--ngx.log(ngx.ERR, "PWD1=>", digest)
	
  local strdumper = require "resty.string"
	
	local upwdh = "*"..string.upper(strdumper.to_hex(digest))
	
	--ngx.log(ngx.ERR, "PWD2=>", strdumper.to_hex(digest))
	--ngx.log(ngx.ERR, "PWD2=>", upwdh)
	-- ngx.log(ngx.ERR, "=>", string.len(upwdh))
	-- local authneeded = false
	
	-- -- user passwords cache
	-- local gur = ngx.shared.g_robotspwds
	-- local lgp, lfp = gur:get(user)
	-- --ngx.log(ngx.ERR, "lgp=>", lgp)
	-- -- ngx.log(ngx.ERR, "=>", string.len(lgp))
	-- updwh = lgp
	
	-- if lgp == nil then
		-- authneeded = true
		-- --break
	-- else
		-- local hlgp = lgp
		-- if updwh ~= hlgp then
			-- --ngx.log(ngx.ERR, "updwh == lgp")
		-- --else
			-- -- ngx.log(ngx.ERR, "updwh != lgp")
			-- --Authentication failed
			-- ngx.status = 401
			-- ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize(u)'";
			-- ngx.exit(401)
		-- end
	-- end
	
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
	
	--local guk = ngx.shared.g_userkeys
		
	for i = 1, #t_args do
		local kval = t_args[i]
		if kval ~= nil and type(kval) ~= "userdata" then
			-- local lkey = user .. "=" .. kval
			-- local lg, lf = guk:get(lkey)
			-- local lg, lf = guk:get(lkey)
			if kval ~= user then
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
		--local query = "SELECT phpbb_users.user_id, pf_tele_keys, user_password FROM `phpbb_profile_fields_data` LEFT JOIN phpbb_users ON phpbb_profile_fields_data.user_id = phpbb_users.user_id WHERE username = %s and user_password = password(%s)"		
		
--SELECT  phpbb_groups.group_id,user_password FROM phpbb_groups JOIN
		local query = "SELECT 1 AS robotok FROM phpbb_groups JOIN(SELECT phpbb_user_group.group_id AS group_id,user_password from phpbb_user_group LEFT JOIN phpbb_users ON phpbb_user_group.user_id = phpbb_users.user_id 	WHERE username = %s and user_password=password(%s)) AS T2 ON phpbb_groups.group_id = T2.group_id WHERE group_name='robots'"
	
		query = string.format(query, dbuser, dbpassword);
		res, err, errno, sqlstate = db:query(query)
		if res and res[1] then
			-- -- update pwd cache
			-- local udbpwd = res[1]["user_password"]
			-- gur:set(user, udbpwd)
			
			-- ngx.log(ngx.ERR, "[2]=> cache size is ", table.getn(guk))
			keyfnd = true
			for i = 1, #t_args do
				local kval = t_args[i]
				if kval ~= nil and type(kval) ~= "userdata" then
					-- local lkey = user .. "=" .. kval
					-- local lg, lf = guk:get(lkey)
					-- local lg, lf = guk:get(lkey)
					if kval ~= user then
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

-- ngx.log(ngx.ERR, "=> ngx.var.remote_user=", ngx.var.remote_user)

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

ngx.log(ngx.ERR, "=>(r) ngx.var.remote_user=", ngx.var.remote_user)
--if username ~= nil then
if ngx.var.remote_user == nil then
		-- ngx.log(ngx.ERR, "=> call to authenticate")
		authenticate(username, password, args)
end 