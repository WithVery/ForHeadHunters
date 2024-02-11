if (ngx.var.arg_id == nil) or (ngx.var.arg_id == "") then
	ngx.say("ERROR")
	ngx.exit(200)
end

local sid = ngx.var.arg_id
local cn = 0 -- is parsed from file name
local c, y, m, d -- channel, year, month, day

local t2s = require("scripts.t2settings");
local t2u = require("scripts.t2utils");
local t2s8 = require("scripts.t2utf8");

local str = require "resty.string"
local upload = require "resty.upload"

local ads_mark = "ads"
local txt_mark = "txt"
local tvb_mark = "tvb"

local ads_pattern = ads_mark.."_?_????_??_??.txt"
local txt_pattern = txt_mark.."_?_????_??_??.txt"
local tvb_pattern = tvb_mark.."_?_????_??_??.txt"

local ads_parse_pattern = ads_mark.."_%01d_%04d_%02d_%02d.txt"
local txt_parse_pattern = txt_mark.."_%01d_%04d_%02d_%02d.txt"
local tvb_parse_pattern = tvb_mark.."_%01d_%04d_%02d_%02d.txt"

function isfilemd5(file)
	local ext = string.sub(file, -4)
	--ngx.log(ngx.ERR, "ext>", string.upper(ext))
	return string.upper(ext) == ".MD5"
	--ngx.log(ngx.ERR, "calc>", md5calc)
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
	host     = t2s.MysqlHost,
	port     = t2s.MysqlPort,
	database = t2s.MysqlDBName,
	user     = t2s.MysqlLogin,
	password = t2s.MysqlPassword
}

if not ok then
	ngx.log(ngx.ERR, "Unable to connect to database: ", err, ": ", errno, " ", sqlstate)
	ngx.exit(500)
end

-- set up encode for connection
--local query = "SET CHARSET cp1251"
local query = "SET CHARSET utf8"
res, err, errno, sqlstate = db:query(query)
if not res then
		ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
		return
end


-- for later use
local resty_md5 = require "resty.md5"
local md5 = resty_md5:new()
local md5calc
local name_to_log = ""
local file_cont = ""

--ngx.log(ngx.ERR, upload)
local chunk_size = 8192 -- should be set to 4096 or 8192
local file
local filetype
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
	-- ngx.log(ngx.ERR, cjson.encode({typ, res}))

	if typ == "header" then
		local file_name = ""
		local short_name = ""
		file_cont = ""
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
						-- ngx.log(ngx.ERR, ">> ", short_name)
						
						-- ngx.log(ngx.ERR, ">> ", string.gsub(value2, "\"", ""))
						
						short_name = string.lower(string.gsub(value2, "\"", ""))
						--ngx.log(ngx.ERR, ">> ", short_name)
						
						filetype = string.sub(short_name, 1, 3)
						
						if (filetype ~= ads_mark) and (filetype ~= tvb_mark) and (filetype ~= txt_mark)then 
							filetype = ""
						end

						if filetype == "" then
							ngx.say("FILE TYPE ENDEFINED")
							ngx.log(ngx.ERR, "> ", "FILE TYPE ENDEFINED")
							ngx.exit(200)
						end
						
						if filetype == txt_mark then
						  -- just check that the file name matches the correct date format 
							--local c, y, m, d = short_name:match(txt_parse_pattern)
							c, y, m, d = short_name:match("txt_(%d+)_(%d+)_(%d+)_(%d+).txt")
							cn = tonumber(c)
							--ngx.log(ngx.ERR, "c> ", c)
							-- ngx.log(ngx.ERR, cn)
							if (cn == nil) or (cn < 1) or (cn > 4) then 
								filetype = ""
							else
								if (y == nil) or (m == nil) or (d == nil) then 
									filetype = ""
								else 
									local xt = os.time{year=y, month=m, day=d}
									--ngx.log(ngx.ERR, os.date("%c", xt))
									--ngx.log(ngx.ERR, xt)
									if xt == nil then 
										filetype = ""
									end
								end
							end
						elseif filetype == tvb_mark or filetype == ads_mark then
							-- if filetype == tvb_mark then
								-- ngx.log(ngx.ERR, "banner checking...")
							-- else 
								-- ngx.log(ngx.ERR, "clips checking...")
							-- end
							
							--c, y, m, d = short_name:match(tvb_mark.."_(%d+)_(%d+)_(%d+)_(%d+).txt")
							c, y, m, d = short_name:match(filetype.."_(%d+)_(%d+)_(%d+)_(%d+).txt")
							cn = tonumber(c)
							-- ngx.log(ngx.ERR, "c> ", c,y,m,d)
							-- ngx.log(ngx.ERR, cn)
							if (cn == nil) or (cn < 1) or (cn > 4) then 
								filetype = ""
							else
								if (y == nil) or (m == nil) or (d == nil) then 
									filetype = ""
								else 
									local xt = os.time{year=y, month=m, day=d}
									--ngx.log(ngx.ERR, os.date("%c", xt))
									--ngx.log(ngx.ERR, xt)
									if xt == nil then 
										filetype = ""
									end
								end
							end
						else 
							ngx.log(ngx.ERR, "failed file checking...")
							filetype = ""
						end
						
						if filetype == "" then
							ngx.say("FILE TYPE ENDEFINED")
							ngx.log(ngx.ERR, "> ", "FILE TYPE ENDEFINED")
							ngx.exit(200)
						end
						
						file_name = t2s.RootDataFolder.."\\Stations\\"..sid.."\\"..filetype.."\\"..short_name
						-- ngx.log(ngx.ERR, "0>> ", file_name)
						--file_name = file_name.encode('cp1251')
						-- ngx.log(ngx.ERR, "1>> ", t2s8.fromutf8(file_name))
						--file_name = t2s.RootDataFolder.."\\1\\"..t2s.VideoTriggersFolder.."\\"..short_name
						
						-- for later use
						-- file_name_md5 = file_name ..".md5"
					end
				end
			end
		end

		if file_name ~= "" then
			name_to_log = t2s8.fromutf8(file_name)
			
			-- file = io.open(t2s8.fromutf8(file_name), "wb+")
			
			-- if not file then
				-- ngx.say("ERROR")
				-- return
			-- end
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
		-- if file then
			-- file:write(res)
			file_cont = file_cont..res
		  -- for later use
			-- if not isfilemd5(name_to_log) then
				-- md5:update(res)
			-- end
		-- end
	elseif typ == "part_end" then
		-- ngx.log(ngx.ERR, "end: ", t2s8.fromutf8(file_name))
		-- ngx.log(ngx.ERR, "nametolog: ", name_to_log)
		if res ~= nil then
			file_cont = file_cont..res
		end
		-- ngx.log(ngx.ERR, "file_cont: ", file_cont)
		
		if (file_cont == "") then
			ngx.say("EMPTY_FILE")
			ngx.exit(200)
			return
		end
		
		-- process uploaded file
		flines = {}
		for s in file_cont:gmatch("[^\r\n]+") do
			table.insert(flines, s)
		end
		
		-- ngx.log(ngx.ERR, ":->", #flines)
		
		local noErrors = true
		local sErrorMsg  = ""
		if filetype ~= txt_mark then
			logos = {}
			for k = 1, #flines do
				--local cline = flines[i]:sub(61)
				local cline = flines[k]:sub(61)
				-- cline = cline:sub(61)
				--ngx.log(ngx.ERR, ">>", cline)
				cline = cline:match "^%s*(.-)%s*$"
				if cline ~= "" then
					-- ngx.log(ngx.ERR, ":->", cline)
					--local dir, file = fullpath:match'(.*/)(.*)'
					local dir, sfile = cline:match'(.*\\)(.*)'
					--ngx.log(ngx.ERR, ":-->", dir)
					-- ngx.log(ngx.ERR, ":-->", file)
					if sfile ~= nil and sfile ~= "" then
						local md5ok = false
						local ffname = t2s.RootDataFolder.."\\Stations\\"..sid.."\\clips\\"..sfile
						local ffname_md5 = ffname..".md5"
						-- ngx.log(ngx.ERR, ":-->", ffname)
						-- ngx.log(ngx.ERR, ":-->", ffname_md5)
						if t2u.file_exists(ffname) ~= true then
							noErrors = false
							--sErrorMsg  = "File "..ngx.quote_sql_str(ffname).." not found"
							--sErrorMsg  = t2s8.toutf8(ngx.quote_sql_str(sfile).. t2s8.fromutf8(" не найден"))
							--sErrorMsg  = t2s8.toutf8(sfile.. t2s8.fromutf8(" не найден"))
							sErrorMsg  = sfile.. t2s8.fromutf8(" не найден")
							--ngx.log(ngx.ERR, ":-->", sErrorMsg)
						else
							if t2u.file_exists(ffname_md5) then
								
								-- pull md5 from file
								local md5f = t2u.read_file(ffname_md5)
								md5f = string.sub(md5f, 1, 32)
								-- ngx.log(ngx.ERR, "md5f>", string.upper(md5f))
								
								local query = "SET CHARSET cp1251"
								--local query = "SET CHARSET utf8"
								res, err, errno, sqlstate = db:query(query)
								if not res then
									ngx.log(ngx.ERR, "Bad result: ", err, ": ", errno, ": ", sqlstate, ".")
									return
								end
								
								-- pull md5 from DB to compare
								local sq = 'SELECT`md5`FROM`clips`WHERE`path`=%s LIMIT 1'
								sq = string.format(sq, ngx.quote_sql_str(ffname));
								ngx.log(ngx.ERR, sq)
								res, err, errno, sqlstate = db:query(sq)
								if res and res[1] then
									-- custom setup
									local md5db = res[1]["md5"]
									ngx.log(ngx.ERR, "md5d>", md5db)
									md5ok = md5f == md5db
									ngx.log(ngx.ERR, "md5Ok>", md5ok)
								end
								
								-- update last used date field in DB
								if md5ok == true then
									local sq = 'UPDATE`clips`SET`lastused`="%d-%d-%d" WHERE `path`=%s'
									sq = string.format(sq, y, m, d, ngx.quote_sql_str(ffname));
									-- ngx.log(ngx.ERR, sq)
									res, err, errno, sqlstate = db:query(sq)
									-- handle errors here
								end 
							else 
								
							end
							if md5ok ~= true then
								noErrors = false
								--sErrorMsg  = "MD5 failed: "..ffname
								--sErrorMsg  = t2s8.toutf8(ngx.quote_sql_str(sfile).. t2s8.fromutf8(" ошибка MD5"))
								--sErrorMsg  = t2s8.toutf8(sfile..t2s8.fromutf8(" ошибка MD5"))
								sErrorMsg  = sfile..t2s8.fromutf8(" ошибка MD5")
							end
						end
					end
				end
			end
		end
		-- local md5_sum = md5:final()
		-- local md5str = string.upper(str.to_hex(md5_sum))
		-- ngx.log(ngx.ERR, "md5_sum: ", md5str)

		--ngx.log(ngx.ERR, "noError>", noErrors)
		
		local action_code   = 0
		local action_result = t2s.LT_INFO
		
		--ngx.log(ngx.ERR, "filetype>", filetype)
		--ngx.log(ngx.ERR, "tvb_mark>", tvb_mark)
		--ngx.log(ngx.ERR, "ads_mark>", ads_mark)
		if filetype == tvb_mark then
			action_code = t2s.TVB_PROCESSING
		elseif filetype == ads_mark then
			action_code = t2s.ADS_PROCESSING
		end
		
		if action_code > 0 then
			if noErrors ~= true then 
				action_result = t2s.LT_ERR
			end
			
			-- log check result
			-- ngx.log(ngx.ERR, "action_result>", action_result)
			-- ngx.log(ngx.ERR, "action_type>", action_code)
			
			local sq = 'INSERT INTO`log`(`log_time`,`station`,`channel`,`sday`,`action_code`,`action_type`,`info`)VALUES(now(),"%s",%d,"%s-%s-%s",%d,%d,"%s")'
			--sq = string.format(sq, sid, cn, y,m,d, action_code, action_result, ngx.quote_sql_str(sErrorMsg));
			sq = string.format(sq, sid, cn, y,m,d, action_code, action_result, sErrorMsg);
			ngx.log(ngx.ERR, sq)
			res, err, errno, sqlstate = db:query(sq)
			
			if res == nil then
				ngx.log(ngx.ERR, "Failed to update DB: ", err, ": ", errno, " ", sqlstate)
				ngx.exit(500)
				return
			end
		end
		
		if noErrors == true then 
			-- ngx.log(ngx.ERR, ": ", name_to_log)
			file = io.open(t2s8.fromutf8(name_to_log), "wb+")
			
			if not file then
				ngx.say("ERROR")
				return
			end
			file:write(file_cont)
			
			file:close()
			file = nil
		else
			-- ngx.log(ngx.ERR, name_to_log, " was not written to the disk")
		end
		
	elseif typ == "eof" then
		break
	end
end

-- ngx.log(ngx.ERR, "Exiting...")

ngx.say("OK")
ngx.exit(200)
