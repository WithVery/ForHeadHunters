if (ngx.var.arg_id == nil) or (ngx.var.arg_id == "") then
	ngx.log(ngx.ERR, arg_id)
	ngx.say("ERROR")
	ngx.exit(200)
end

--ngx.log(ngx.ERR, "ext>")
--ngx.log(ngx.ERR, ngx.client_max_body_size)

local sid = ngx.var.arg_id

local t2s = require("scripts.t2settings");
local t2u = require("scripts.t2utils");
local t2s8 = require("scripts.t2utf8");

local str = require "resty.string"
local upload = require "resty.upload"

function isfilemd5(file)
	local ext = string.sub(file, -4)
	-- ngx.log(ngx.ERR, "ext>", string.upper(ext))
	return string.upper(ext) == ".MD5"
	--ngx.log(ngx.ERR, "calc>", md5calc)
end

-- for later use
local resty_md5 = require "resty.md5"
local md5 = resty_md5:new()
local md5calc
local name_to_log = ""
local name_to_send = ""

--ngx.log(ngx.ERR, upload)
local chunk_size = 8192 -- should be set to 4096 or 8192
local file
--local short_name = "";

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
	--ngx.log(ngx.ERR, cjson.encode({typ, res}))

	if typ == "header" then
		local file_name = ""
		local short_name = ""
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
						
						--short_name = ngx.var.arg_c.."_"..os.date("%Y%m%d").."_"..os.date("%H%M%S").."."..string.gsub(st[#st], "\"", "")
						--ngx.log(ngx.ERR, ">> ", short_name)
						
						-- ngx.log(ngx.ERR, ">> ", string.gsub(value2, "\"", ""))
						short_name = string.gsub(value2, "\"", "")
						--file_name = t2s.RootDataFolder.."\\1\\"..t2s.VideoClipsFolder.."\\"..string.gsub(value2, "\"", "")
						--file_name = t2s.RootDataFolder.."\\Stations\\"..sid.."\\"..t2s.VideoClipsFolder.."\\"..string.gsub(value2, "\"", "")
						file_name = t2s.RootDataFolder.."\\Stations\\"..sid.."\\"..t2s.VideoClipsFolder.."\\"..short_name
						ngx.log(ngx.ERR, "0>> ", file_name)
						-- file_name = file_name.encode('cp1251')
						ngx.log(ngx.ERR, "1>> ", t2s8.fromutf8(file_name))
						--file_name = t2s.RootDataFolder.."\\1\\"..t2s.VideoTriggersFolder.."\\"..short_name
						
						-- for later use
						-- file_name_md5 = file_name ..".md5"
					end
				end
			end
		end

		if file_name ~= "" then
			name_to_log  = t2s8.fromutf8(file_name)
			name_to_send = short_name
			
			file = io.open(t2s8.fromutf8(file_name), "wb+")
			
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
			if not isfilemd5(name_to_log) then
				md5:update(res)
			end
		end
	elseif typ == "part_end" then
		-- ngx.log(ngx.ERR, "end: ", t2s8.fromutf8(file_name))
		-- ngx.log(ngx.ERR, "nametolog: ", name_to_log)
		file:close()
		file = nil
		
		-- put MD5 sum to the DB if needed
		-- ngx.log(ngx.ERR, "end:", name_to_log)
		-- ngx.log(ngx.ERR, "?>", md5calc)
		ngx.log(ngx.ERR, "?>", isfilemd5(name_to_log))
		if not isfilemd5(name_to_log) then 
			local md5_sum = md5:final()
			-- ngx.log(ngx.ERR, "md5_sum: ", str.to_hex(md5_sum))
			md5:reset()
			-- file_md5:write(str.to_hex(md5_sum))
			-- file_md5:close()
			-- file_md5 = nil
			
			-- add default data to the DB
			ngx.log(ngx.ERR, ">> ", name_to_log)
			if file_name ~= "" then
			--if false then
				local dbsettings = require("scripts.t2settings");
				local mysql = require "resty.mysql"
				local db, err, errno, sqlstate, res, ok
				
				local sresr = "FAILED"
		
				db = mysql:new()
				--ngx.log(ngx.ERR, res)
				if db then
					-- ngx.log(ngx.ERR, "ta2=>")
					db:set_timeout(20000)
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

					-- ngx.log(ngx.ERR, vals)
					--if vals ~= "" then
					
						local query = "SET CHARSET cp1251"
						-- local query = "SET CHARSET utf8"
						res, err, errno, sqlstate = db:query(query)

						if not res then
								ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
								return
						end
					
						--ngx.log(ngx.ERR, "md5_h: ", md5_sum)
						local md5_db = string.upper(str.to_hex(md5_sum))
						local sq = 'INSERT INTO`clips`(`idx`,`path`,`md5`)VALUES(UNHEX(REPLACE(uuid(),"-","")),%s,"%s") ON DUPLICATE KEY UPDATE md5="%s"'
						--sq = string.format(sq, ngx.quote_sql_str(name_to_log), string.upper(str.to_hex(md5_sum)), md5_db);
						sq = string.format(sq, ngx.quote_sql_str(name_to_log), md5_db, md5_db);
						-- ngx.log(ngx.ERR, sq)
						res, err, errno, sqlstate = db:query(sq)
						if not res then
							ngx.exit(200)
							return
						end
						
						local ffname_md5 = name_to_log..".md5"
						if t2u.file_exists(ffname_md5) then
								-- pull md5 from file
							local md5_f = t2u.read_file(ffname_md5)
							md5_f = string.sub(md5_f, 1, 32)
							--ngx.log(ngx.ERR, "md5_d: ", md5_db)
							--ngx.log(ngx.ERR, "md5_f: ", md5_f)
							if md5_f == md5_db then
								sresr = "OK"
							else
								sresr = "MD5FAILED"
							end
						else
								sresr = "NOMD5"
						end
						--ngx.log(ngx.ERR, res)
					--end
				end
				ngx.say(name_to_send..":"..sresr)
			end
		else
				ngx.say(name_to_send..":")
		end
	elseif typ == "eof" then
		break
	end
end

-- ngx.say("OK")


