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

function splitAgrs(str)
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

ngx.header.content_type = 'application/json';
if ngx.var.arg_c and ngx.var.arg_date then

	local cns = splitAgrs(ngx.var.arg_c)
	-- ngx.log(ngx.ERR, "channels =>", cjson.encode(cns))
	local dt = ngx.var.arg_date
	
	-- ngx.log(ngx.ERR, "channel =>", cn)
	-- ngx.log(ngx.ERR, "date =>", dt)
	
	-- ngx.shared.globalstatus:set('status'..ngx.var.arg_id, ngx.var.arg_p)
	-- local as = ngx.shared.globalanchors:get(ngx.var.arg_c)
	
-- SELECT * FROM `scheds` WHERE s_c=1 and s_day='2018-08-24' ORDER BY s_start
	-- local setup 
	local db_username = "root"
	local db_password = ""
	local db_name = "t2u"
	-- -- IP version
	local db_host = "127.0.0.1"
	local db_port = "3306"
	-- IP version - end of

	-- pull channel names from database
	local mysql = require "resty.mysql"
	local db, err, errno, sqlstate, res, ok

	db = mysql:new()
	if not db then
		ngx.log(ngx.ERR, "Failed to create mysql object")
		ngx.exit(500)
	end

	db:set_timeout(2000)

	ok, err, errno, sqlstate = db:connect{
	-- socket version
	--        path = db_socket,
	-- socket version - end of
	-- IP version
			host = db_host,
			port = db_port,
	-- IP version - end of
			database = db_name,
			user = db_username,
			password = db_password
	}

	if not ok then
		ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
		ngx.exit(500)
	end

	local query = "SET CHARSET utf8"
	res, err, errno, sqlstate = db:query(query)

	if not res then
			ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
			return
	end

	local re = {}
	
	for i = 1, #cns do
		local cn = cns[i]
		
		--ngx.log(ngx.ERR, "cns[", i, "] => ", cn)
		
		-- if kval ~= nil and type(kval) ~= "userdata" then
			-- local lkey = user .. "=" .. kval
			-- local lg, lf = guk:get(lkey)
			-- if lg == nil then
				-- keyfnd = false
				-- break
			-- end
		-- else
			-- ngx.log(ngx.ERR, "malformed request => ", kval)
			-- keyfnd = false
			-- break
		-- end
		-- end 	
		-- ngx.exit(200)
		
		-- local cn = ngx.var.arg_c
	
	
	--local query = "SELECT * FROM`scheds`WHERE`s_c`=%s and s_day=%s ORDER BY s_start,s_type DESC";
		query = "SELECT s_start, s_name FROM `scheds` WHERE s_c = %s AND s_day = %s AND s_type=2 ORDER BY s_start";	
		query = string.format(query, cn, ngx.quote_sql_str(dt));
		--ngx.log(ngx.ERR, "query! = ", query)
		res, err, errno, sqlstate = db:query(query)

		if not res then
				ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
				return
		end
	--gs:set("items:", cjson.encode(res));
-- ! --
--res, err, errno, sqlstate = db:query(query)
	--ngx.log(ngx.ERR, "items:", cjson.encode(res));
	
	--local cns = {};
	-- cns['"id_'..cn..'"'] = cjson.encode(res);
	
	--local ret = cjson.encode({cns = cjson.encode(cns)});
	--local ret = cjson.encode({c = cn, cjson.encode(cns)});
		re[cn] = cjson.encode(res);
	end
	-- local ret2 = null; --cjson.encode({c = 2, a = cjson.encode(res)});
	-- local ret3 = null;
	-- local ret = cjson.encode({ret1, ret2, ret3});
	--local ret = cjson.encode(res);
	-- ngx.log(ngx.ERR, "result:", cjson.encode(re));
	ngx.say(cjson.encode(re))
	

	--ngx.say(cjson.encode(res))
	-- ngx.log(ngx.ERR, "=>", as)
	--ngx.say(as)
else
		ngx.say("UNDEF")
end
-- ngx.update_time()
-- ngx.shared.globalstatus:set('statuslastupdate'..ngx.var.arg_id, ngx.now())
