local function exportFrame(sprite, frame_n, output)
	local tempsprite = Sprite(sprite)
	repeat
		if frame_n == 1 then
			tempsprite:deleteFrame(2)
		else
			tempsprite:deleteFrame(1)
			frame_n = frame_n - 1
		end 
	until #tempsprite.frames == 1
	-- sanity check (trust me it's more annoying with out this)
	if #tempsprite.frames ~= 1 then
		tempsprite:close()
		error("More than one frame left somehow?")
	end
	tempsprite:saveCopyAs(output)
	tempsprite:close()
end

local function export(sprite, directory)
	for _, tag in ipairs(sprite.tags) do
		local count = 1
		if tag.aniDir ~= AniDir.REVERSE then
			for j=tag.fromFrame.frameNumber,tag.toFrame.frameNumber do
				local file_name = tag.name .. "_" .. count .. ".png"
				count = count + 1
				exportFrame(sprite, j, directory .. file_name)
			end
		end
		if tag.aniDir == AniDir.PING_PONG or tag.aniDir == AniDir.PING_PONG_REVERSE or tag.aniDir == AniDir.REVERSE then
			for j=tag.toFrame.frameNumber,tag.fromFrame.frameNumber,-1 do
				local file_name = tag.name .. "_" .. count .. ".png"
				count = count + 1
				exportFrame(sprite, j, directory .. file_name)
			end
		end
	end
end

local function dirname(str)
    return str:match("(.*[/\\])")
end


if #app.sprite.tags == 0 then
	local dlg = Dialog{ title = "Error!" }
	dlg:label{text = "Need at least one tag in order to export!"}
	dlg:button{
			text="OK", onclick=function()
				dlg:close()
			end, focus = true}
	dlg:show()
	return
end
local dlg = Dialog()
dlg:entry{ id="target_dir",
	label="Target Directory",
	text=dirname(app.sprite.filename)}

dlg:button {
	text="Start",
	onclick=function()
		export(app.sprite, dlg.data.target_dir)
		dlg:close()
	end
}

dlg:button {
	text="Cancel",
	onclick=function()
		dlg:close()
	end
}
dlg:show{ wait=false }
