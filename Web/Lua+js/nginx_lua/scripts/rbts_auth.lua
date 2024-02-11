--
-- change "cookie_domain" to variable !
--
-- local cookie_domain = "83.166.240.102"
-- local cookie_domain = "127.0.0.1"
-- local db_username = "root"
-- local db_password = "1qaz2wsx3edc"
-- local db_username = "phpBB_dbuser"
-- local db_password = "sVZcUIuKW6lqrN4U"

-- *nix version
--local db_socket = "/run/mysqld/mysqld.sock"
-- *nix version - end of

-- Windows version
-- local db_host = "127.0.0.1"
-- local db_port = "3306"
-- Windows version - end of
-- local db_name = "tele2u"

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
	
	local bit = require("bit")
	
	local original = user
	local key = "x"
	local phash = "";
	
	for i = 1, string.len(original) do
		local tmp = bit.bxor(string.byte(original, i), (string.byte(key) + i - 1))
		phash = phash..string.format("%X", tmp)
	end
	if password ~= phash or string.sub(user, 1, 1) ~= "G"  then
		ngx.status = 401
		ngx.header["WWW-Authenticate"] = "Basic realm='Pease authorize(u)'";
		ngx.exit(401)
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

-- ngx.log(ngx.ERR, "=>(r) ngx.var.remote_user=", ngx.var.remote_user)
--if username ~= nil then
--if ngx.var.remote_user == nil then
		-- ngx.log(ngx.ERR, "=> call to authenticate")
authenticate(username, password, args)
--end 