--
-- change "cookie_domain" to variable !
--
-- local cookie_domain = "83.166.240.102"
-- local cookie_domain = "127.0.0.1"
-- phpBB setup
-- local db_username = "phpBB_dbuser"
-- local db_password = "sVZcUIuKW6lqrN4U"

-- *nix version
--local db_socket = "/run/mysqld/mysqld.sock"
-- *nix version - end of

-- phpBB setup
-- local db_username = "phpBB_dbuser"
-- local db_password = "sVZcUIuKW6lqrN4U"
-- local db_name = "tele2u"

-- linux setup
--local db_username = "t2user"
--local db_password = "8UgpboGjmRguEmvh"

-- local setup
local db_username = "root"
local db_password = ""

local db_name = "t2u"

-- Windows version
local db_host = "127.0.0.1"
local db_port = "3306"
-- Windows version - end of

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
		-- for k,v in pairs(t) do
			-- ngx.log(ngx.ERR, "t[", k, "]=", v)
		-- end
-- debug output - end of	
	return t
end

-- function authenticate(user, password, group)
function authenticate(user, password, largs)
		
	if user ~= "admin" then 
		ngx.status = 401
		ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize yourself'";
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
	
	if keyfnd ~= true then
		dbuser = ngx.quote_sql_str(user)
		dbpassword = ngx.quote_sql_str(password)
		
		local query = "SELECT '1' FROM `users` WHERE login=%s and pwd=password(%s)"				
		query = string.format(query, dbuser, dbpassword);
		res, err, errno, sqlstate = db:query(query)
		if res and res[1] then
		
		else
			ngx.log(ngx.ERR, "=> query failed")
			ngx.status = 401
			ngx.header["WWW-Authenticate"] = "Basic realm='Wrong login/password. Pease authorize.'";
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

--if ngx.var.remote_user == nil then
--		ngx.log(ngx.ERR, "=>(u) name yourself!")
--end 

authenticate(username, password, args)
