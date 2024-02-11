if (ngx.var.arg_p) then
	--ngx.log(ngx.ERR, "arg_p =>1")
	ngx.shared.globalstatus:set('status'..ngx.var.arg_id, ngx.var.arg_p)
else
	--ngx.log(ngx.ERR, "arg_p =>0")
	ngx.req.read_body()
	-- ngx.log(ngx.ERR, "=>", ngx.req.get_body_data())
	local sdata = cjson.decode(ngx.req.get_body_data())
	-- anchors field has been removed from setstatus JSON from client !!! 
	-- adata field is TO BE REMOVED!!!
	-- local adata = sdata["anchors"]
	sdata["anchors"] = nil
	local le = sdata["le"]
	sdata["le"] = nil
	
	if le ~= nil and #le > 0 then
		-- ngx.log(ngx.ERR, "ta1=>", cjson.encode(ta))

		local dbsettings = require("scripts.t2settings");
		local mysql = require "resty.mysql"
		local db, err, errno, sqlstate, res, ok
		
		db = mysql:new()
		if db then
			-- ngx.log(ngx.ERR, "ta2=>")
			db:set_timeout(2000)
			ok, err, errno, sqlstate = db:connect{
				host     = dbsettings.MysqlHost,
				port     = dbsettings.MysqlPort,
				database = dbsettings.MysqlDBName,
				user     = dbsettings.MysqlLogin,
				password = dbsettings.MysqlPassword
			}

			if ok then
				--ngx.log(ngx.ERR, "ta3=>")
				--for i = 1, #ta do 
				local query = "SET CHARSET utf8"
				res, err, errno, sqlstate = db:query(query)

				if not res then
						ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
						return
				end
 				
				for i = 1, #le do 
					local val = le[i]
					-- ngx.log(ngx.ERR, "channel=>", val.c)
					-- ngx.log(ngx.ERR, "title=>", val.n)
					--ngx.shared.globalanchors:set(k, cjson.encode(v))
					
					--ngx.log(ngx.ERR, ">> " cjson.encode({id = ngx.var.arg_id, p = "timeout", timeout=(ngx.now()-lastupd), cht = lcht})))
					--ngx.log(ngx.ERR, cjson.encode({n = val.c, t = val.sy}))
					
					--ngx.log(ngx.ERR, ngx.var.arg_id .. val.c .. val.st)
					--ngx.log(ngx.ERR, cjson.encode({n = val.c, t = val.sy}))
					ngx.shared.globaltriggered:set(ngx.var.arg_id .. val.c .. val.d .. val.st, cjson.encode({n = val.c, t = val.sy}))
					
					
					aname = ngx.quote_sql_str(val.n)
					--dbpassword = ngx.quote_sql_str(password)
					-- ngx.log(ngx.ERR, "dbuser=>", dbuser)
					-- ngx.log(ngx.ERR, "dbpassword=>", dbpassword)
					
					--local query = "INSERT INTO anchorstriggered(station,channel,title,systemtime,sday,schedtime)values(%s,%s,%s,%s,%s,%s)"
					local query = "INSERT INTO log(station,channel,title,systemtime,sday,schedtime,action_code,action_type,info)values(%s,%s,%s,%s,%s,%s,%s,%s,%s)"
					query = string.format(query, ngx.quote_sql_str(ngx.var.arg_id), val.c, aname, ngx.quote_sql_str(val.sy), ngx.quote_sql_str(val.d), ngx.quote_sql_str(val.st), ngx.quote_sql_str(val.cd), ngx.quote_sql_str(val.tp), ngx.quote_sql_str(val.i));
					-- ngx.log(ngx.ERR, "query=>", query)
					
					res, err, errno, sqlstate = db:query(query)
				end
			end
		end
	end
	-- ngx.log(ngx.ERR, "body=>", cjson.encode(sdata))
	ngx.shared.globalstatus:set('status'..ngx.var.arg_id, ngx.req.get_body_data())
	
	-- for k,v in pairs(adata) do 
		-- -- print(k,v)
		-- -- ngx.log(ngx.ERR, k, "=>", cjson.encode(v))
		-- ngx.shared.globalanchors:set(k, cjson.encode(v))
	-- end
end
ngx.update_time()
ngx.shared.globalstatus:set('statuslastupdate'..ngx.var.arg_id, ngx.now())
