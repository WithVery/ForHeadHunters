local t2u = require("scripts.t2utils");

ngx.header.content_type = 'application/json'
local settings = ngx.shared.globalsettings
local channels = settings:get('channels')

if channels == nil then
	ngx.log(ngx.ERR, "refreshing!")
	ngx.redirect("/refreshconfig/")
	return
end


--ngx.log(ngx.ERR, "cns=", channels);
--ngx.log(ngx.ERR, "channels =", ngx.var.arg_c);

local req_channels = ngx.var.arg_c
-- ngx.log(ngx.ERR, "channels =", req_channels);
local user     = t2u.getUsernameFromHeader(ngx.req.get_headers()['Authorization'])
-- ngx.log(ngx.ERR, "user =", user);
local u_channels = t2u.pullChannelsForUser(user)
local t_uchannels = t2u.splitKeys(u_channels)
-- ngx.log(ngx.ERR, "u_channels =", u_channels);

if req_channels ~= nil then -- we have to deliver only requested channels

	local t_channels = t2u.splitKeys(req_channels)
  --ngx.log(ngx.ERR, "t_channels =", cjson.encode(t_channels));
  --ngx.log(ngx.ERR, cjson.encode(cns));
	--local cname = "";
	local cst = {};
	local cns = cjson.decode(channels)
	
	if cns ~= nil then
		for j = 1, #t_channels do
			local cc = t_channels[j]
			-- ngx.log(ngx.ERR, "cc[", j, "]=", cc);
			for k = 1, #t_uchannels do
				local uc = t_uchannels[k]
				-- ngx.log(ngx.ERR, "uc[", k, "]=", uc);
				if uc == cc then
			--if kval ~= nil and type(kval) ~= "userdata" then
					for i,line in ipairs(cns) do
						--if (line["id"] == tonumber(ngx.var.arg_c)) then
						-- ngx.log(ngx.ERR, "line[", i, "]=", line["id"]);
						if (line["id"] == tonumber(cc)) then
							-- channel = cjson.encode(line);
							cst[cc] = line["settings"]
							--ngx.log(ngx.ERR, "cst =>", cjson.encode(cst));
							break
						end
					end 
					break
				end
			end
		end
	end
	--ngx.log(ngx.ERR, "settings0 =>", cjson.encode({cs = cst}))
	ngx.say(cjson.encode({chs = channels, cs = cst}))	
else -- we have to deliver all channels allowed to the user
	local gcs = channels
	
	local cst = null;
	local cns = cjson.decode(channels)
	local cname = "";
	for i,line in ipairs(cns) do
		--if (line["id"] == tonumber(ngx.var.arg_c)) then
		if (line["id"] == 1) then
			-- channel = cjson.encode(line);
			cst = line["settings"]
			--ngx.log(ngx.ERR, "cst =>",cst);
		end
	end 
		
	if cst then 
		ngx.say(cjson.encode({chs = channels, cs = cst}))
		--ngx.log(ngx.ERR, "settings1 =>", cjson.encode({chs = channels, cs = cst}))
	else
		ngx.say(cjson.encode({chs = channels}))
		--ngx.log(ngx.ERR, "settings2 =>", cjson.encode({chs = channels}))
	end
	--ngx.log(ngx.ERR, "settings =>", cjson.encode({chs = channels}))
end

return
--local channels = 

-- if channels then
	-- local gcs = channels
	
	-- local cst = null;
	-- local cns = cjson.decode(channels)
	-- local cname = "";
	-- for i,line in ipairs(cns) do
		-- --if (line["id"] == tonumber(ngx.var.arg_c)) then
		-- if (line["id"] == 1) then
			-- -- channel = cjson.encode(line);
			-- cst = line["settings"]
			-- --ngx.log(ngx.ERR, "cst =>",cst);
		-- end
	-- end 
		
	-- if cst then 
		-- ngx.say(cjson.encode({chs = channels, cs = cst}))
		-- --ngx.log(ngx.ERR, "settings1 =>", cjson.encode({chs = channels, cs = cst}))
	-- else
		-- ngx.say(cjson.encode({chs = channels}))
		-- --ngx.log(ngx.ERR, "settings2 =>", cjson.encode({chs = channels}))
	-- end
	-- --ngx.log(ngx.ERR, "settings =>", cjson.encode({chs = channels}))
-- else
	-- -- ngx.say("UNDEF")
	-- --require("/scripts/get_channel_names")
	-- ngx.log(ngx.ERR, "refreshing!")
	-- ngx.redirect("/refreshconfig/")
-- end
