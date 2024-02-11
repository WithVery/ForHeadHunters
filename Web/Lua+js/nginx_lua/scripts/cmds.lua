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
	if keyfnd ~= true then 
		ngx.log(ngx.ERR, "Some keys are not in cache! => querying the DB.")
		dbuser = ngx.quote_sql_str(user)
		dbpassword = ngx.quote_sql_str(password)
		local query = "SELECT phpbb_users.user_id, pf_tele_keys FROM `phpbb_profile_fields_data` LEFT JOIN phpbb_users ON phpbb_profile_fields_data.user_id = phpbb_users.user_id WHERE username = %s and user_password = password(%s)"
		query = string.format(query, dbuser, dbpassword);
		res, err, errno, sqlstate = db:query(query)
		if res and res[1] then
			local sdbkeys = res[1]["pf_tele_keys"]
			local t_dbkeys = splitKeys(sdbkeys)
			
			-- update global user-key pairs cache
			for k,v in pairs(t_dbkeys) do
				local lkey = user .. "=" .. v
				guk:set(lkey, 1)
			end
		
			ngx.log(ngx.ERR, "[2]=> cache size is ", table.getn(guk))
			keyfnd = true
			for i = 1, #t_args do
				local kval = t_args[i]
				if kval ~= nil and type(kval) ~= "userdata" then
					local lkey = user .. "=" .. kval
					ngx.log(ngx.ERR, "searching for ", lkey, " lkey")
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

local header = ngx.req.get_headers()['Authorization']
--ngx.log(ngx.ERR, "Header: ", header)

--ngx.log(ngx.ERR, "arg_id: ", ngx.var.QUERY_STRING)
--ngx.log(ngx.ERR, "arg_id: ", ngx.var.arg_id)
local args = ngx.var.QUERY_STRING

local username = ""
--ngx.var.cookie_login
local password = ""

if header ~= nil and  header:find(" ") ~= nil then
    --ngx.log(ngx.ERR, "Header: ", header)
    --return false

    local divider = header:find(' ')
    if header:sub(0, divider-1) ~= 'Basic' then
       return false
    end
    local auth = ngx.decode_base64(header:sub(divider+1))
    --ngx.log(ngx.ERR, "auth: ", auth)
    if auth == nil or auth:find(':') == nil then
        return false
    end

    divider = auth:find(':')
    username = auth:sub(0, divider-1)
    -- ngx.log(ngx.ERR, "header=>username: ", username)
    password = auth:sub(divider+1)
    -- ngx.log(ngx.ERR, "header=>pwd: ", password)
		
    --ngx.log(ngx.ERR, "uname: ", username)
    --ngx.log(ngx.ERR, "pwd: ", password)
    --ngx.header["WWW-Authenticate"] = ""
    --ngx.header["Authorization"] = ""
    --ngx.var.cookie_login = username
    --ngx.header['Set-Cookie'] = "login="..username.."; path=/"
    --ngx.header['Set-Cookie'] = "rc=0; path=/"
    --ngx.var.cookie_rc = 0
    ---ngx.status = 200
    --ngx.redirect("http://"..cookie_domain.."/q1/")
    --ngx.exit()
    ---return
else
    -- ngx.log(ngx.ERR, "Header is EMPTY")
end

-- ngx.log(ngx.ERR, "_username_: ", username)
if username == "" then
	ngx.status = 401
	--ngx.header.www_authenticate = 'Basic realm="Restricted"'
	ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize1'";
	-- ngx.log(ngx.ERR, "ref: ", ngx.var.http_referer)
	-- ngx.log(ngx.ERR, "Forcing to authenticate... ")			
	--ngx.redirect(ngx.var.http_referer)
	ngx.exit(401)
	return

	--local newurl = "http://"..cookie_domain.."/auth.php?G1518,G1519,G1520&port=8080"
	--if args ~= nil then
	--newurl = newurl.."?"..args
	--end
	--ngx.redirect("http://"..cookie_domain..":8080/?"..args)
	--return ngx.redirect(newurl)
	--ngx.redirect("http://"..cookie_domain)
	--ngx.exit(401)
	--return
end

local remote_password

--ngx.log(ngx.ERR, "user: ", username)
--ngx.log(ngx.ERR, "pwd: ", password)
-- !!
local las = args
-- ngx.log(ngx.ERR, "largs_1: ", las)
-- filter out id=Gkey form
if las ~= nil then
	local p1 = las:find('=')
	if p1 ~= nil then
		-- ngx.log(ngx.ERR, "largs1: ", las)
		las = las:sub(p1 + 1)
		-- ngx.log(ngx.ERR, "largs2: ", las)
	end
end

if username ~= nil then
		-- ngx.log(ngx.ERR, "=> call to authenticate")
		authenticate(username, password, las)
    return
else
    --ngx.header['Set-Cookie'] = 'ec=401; path=/'
    ngx.log(ngx.ERR, "errorcode=401")
    ----ngx.redirect("http://"..cookie_domain)
    --return

    ngx.header['Set-Cookie'] = 'rc=1; path=/'
    ngx.log(ngx.ERR, "Authorization needed")
    ngx.status = 401
    ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize'";
    --ngx.redirect("http://"..cookie_domain)
    ngx.exit(401)
end

 
if ngx.var.http_authorization then
ngx.log(ngx.ERR, "here3")

--    local tmp = ngx.var.http_authorization
--    tmp = tmp:sub(tmp:find(' ')+1)
--    tmp = ngx.decode_base64(tmp)
--    remote_password = tmp:sub(tmp:find(':')+1)
end
 
function authentication_prompt()
ngx.log(ngx.ERR, "here2")

--    session.data.valid_user = false
--    session.data.user_group = nil
--    session:save()
--    ngx.header.www_authenticate = 'Basic realm="Restricted"'
--    ngx.exit(401)
ngx.exec("/")
end
 