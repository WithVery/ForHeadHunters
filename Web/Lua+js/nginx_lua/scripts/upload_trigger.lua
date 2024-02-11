if ngx.var.arg_c == nil then
	ngx.say("ERROR")
	ngx.exit(200)
end

local t2s = require("scripts.t2settings");
local t2u = require("scripts.t2utils");

local str = require "resty.string"
local upload = require "resty.upload"

-- ngx.log(ngx.ERR, cjson.encode(ngx.req.get_headers()))

-- for later use
-- local resty_md5 = require "resty.md5"
-- local md5 = resty_md5:new()

--ngx.log(ngx.ERR, upload)
local chunk_size = 8192 -- should be set to 4096 or 8192
local file
local short_name = "";

-- for later use
-- local file_md5

local form, err = upload:new(chunk_size)
if not form then
		ngx.log(ngx.ERR, "failed to new upload: ", err)
		ngx.exit(500)
end
--ngx.log(ngx.ERR, err)

while true do
	local typ, res, err = form:read()
	if not typ then
		ngx.log(ngx.ERR, "failed to read: ", err)
		return
	end
	-- ngx.log(ngx.ERR, cjson.encode({typ, res}))

	if typ == "header" then
		local file_name = "";
		-- for later use
		-- local file_name_md5 = ""
		for key,value in pairs(res) do 
			local vars = t2u.split(value, "; ")
			for key1,value1 in pairs(vars) do 
				local params = t2u.split(value1, "=")
				local isname = false;
				for key2,value2 in pairs(params) do 
					if value2 == "filename" then
						isname = true;
					elseif isname == true then
						local st = t2u.split(value2, "%.")
						
						short_name = ngx.var.arg_c.."_"..os.date("%Y%m%d").."_"..os.date("%H%M%S").."."..string.gsub(st[#st], "\"", "")
						ngx.log(ngx.ERR, ">> ", short_name)
						
						--ngx.log(ngx.ERR, ">> ", file_name)
						--file_name = t2s.RootDataFolder.."\\1\\"..t2s.VideoTriggersFolder.."\\"..string.gsub(value2, "\"", "")
						file_name = t2s.RootDataFolder.."\\1\\"..t2s.VideoTriggersFolder.."\\"..short_name
						
						-- for later use
						-- file_name_md5 = file_name ..".md5"
					end
				end
			end
		end

		if file_name ~= "" then
			-- ngx.log(ngx.ERR, "file_name: ", file_name)
			file = io.open(file_name, "wb+")
			if not file then
				ngx.say("ERROR")
				return
			end
		end
		
		-- for later use
		-- if file_name_md5 ~= "" then
			-- ngx.log(ngx.ERR, "file_name_md5: ", file_name_md5)
			-- file_md5 = io.open(file_name_md5, "w+")
			-- if not file_md5 then
				-- --ngx.say("failed to open file ", file_name)
				-- ngx.say("ERROR")
				-- return
			-- end
		-- end

	elseif typ == "body" then
		if file then
			file:write(res)
		  -- for later use
			-- md5:update(res)
		end
	elseif typ == "part_end" then
		file:close()
		file = nil
		
		-- for later use
		-- local md5_sum = md5:final()
		-- ngx.log(ngx.ERR, "md5_sum: ", str.to_hex(md5_sum))
		-- md5:reset()
		-- file_md5:write(str.to_hex(md5_sum))
		-- file_md5:close()
		-- file_md5 = nil
		
		-- add default data to the DB
		-- ngx.log(ngx.ERR, ">> ", short_name)
		--if short_name ~= "" then
		if false then
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

				if not ok then
						ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
						ngx.exit(500)
				end
				
				if vals ~= "" then
					local sq = 'INSERT INTO`triggers`(`channel`,`name`)VALUES(%d,"%s")'
					sq = string.format(sq, ngx.var.arg_c, short_name);
					-- ngx.log(ngx.ERR, sq)
					res, err, errno, sqlstate = db:query(sq)
					--ngx.log(ngx.ERR, res)
				end
			end
		end
	elseif typ == "eof" then
		break
	end
end

ngx.say("OK")


