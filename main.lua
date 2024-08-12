
if arg[2] == "debug" then
    require("lldebugger").start()
end




function requireFiles(directory)
    local files = love.filesystem.getDirectoryItems(directory)

    for _, file in ipairs(files) do
        if file:sub(-4) == ".lua" then
            local moduleName = file:sub(1, -5)
            require(directory .. "." .. moduleName)
        end
    end
end

function getCartridges()
    local files = love.filesystem.getDirectoryItems("games")
	local games = {}

    for _, gameDir in ipairs(files) do
        if (love.filesystem.getInfo("games/"..gameDir, "directory")) then
			local gameFiles = love.filesystem.getDirectoryItems("games/"..gameDir)

			-- First we get the game root file
			for _, file in ipairs(gameFiles) do
				if (file == "game.lua") then
					games[gameDir] = {
						name = gameDir,
						description = "Error",
						author = "Error",
						version = 1,
						path = "games/"..gameDir.."/"..file:gsub(".lua", ""),
					}
				end
			end

			-- Then we add the gameinfo.txt
			for _, file in ipairs(gameFiles) do
				if (file == "gameinfo.json") then
					local jsonFile = love.filesystem.read("games/"..gameDir.."/"..file)
					if (jsonFile) then
						local gameInfo = json.decode(jsonFile)
						if (gameInfo) then
							games[gameDir].name = gameInfo["Name"]
							games[gameDir].description = gameInfo["Description"]
							games[gameDir].author = gameInfo["Author"]
							games[gameDir].version = gameInfo["Version"]
						end
					end
				end
			end
		end
    end

	local formattedGames = {}

	for _, gameInfo in pairs(games) do
		formattedGames[#formattedGames + 1] = {
			name = gameInfo.name,
			description = gameInfo.description,
			author = gameInfo.author,
			version = gameInfo.version,
			path = gameInfo.path,
		}
	end

	return formattedGames
end


-- Console Libraries
requireFiles("console")
gScreen = require('console/pixel')

debug.SetEnabled(false)

local gamePackage = ""
currentGame = nil
currentGameInfo = {}
games = getCartridges()

-- Game Modules
input = require("modules/input") -- made by tarion
render = require("modules/render") -- made by tarion
vector = require("modules/nvec") -- https://github.com/MikuAuahDark/NPad93/blob/master/nvec.lua
audio = require("modules/wave") -- https://github.com/Ulydev/wave/tree/master



local curTime = 0
function CurTime()
	return curTime
end

function LoadGame(game)
	UnloadGame()

	currentGameInfo = games[game]
	local path = currentGameInfo.path
	gamePackage = path

	local success, err = pcall(function()
		currentGame = require(path)
	end)

	if not success then
		print("Failed to load game module: ", err)
	else
		currentGame.Load()
		love.filesystem.setIdentity(currentGameInfo.name)
		love.window.setTitle(currentGameInfo.name)
	end
end

function UnloadGame()
	currentGame = nil
	package.loaded[gamePackage] = nil
end

local curScaling = 4
local testFont = love.graphics.newImageFont("font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.:;<=>?-+*/)('&%$#ß!@[ß]^_{|}~", -1)
fontColor = Color(224, 248, 207)
windowWidth = 160
windowHeight = 144
function love.load(args)
	love.graphics.setFont(testFont)

	debug.Load()

	gScreen.load(2)
	love.graphics.setBackgroundColor(0.2, 0.2, 0.2)

	hook.Call("Load")
	hook.Call("PostLoad")
end

function love.update(dt)
	curTime = curTime + dt

	-- Load cartriges
	for i = 1, 10 do
		if (input.KeyPressed("f"..i) and games[i]) then
			if (game) then
				UnloadGame()
			else
				LoadGame(i)
			end

			break
		end
	end

	if (input.KeyPressed("f11")) then
		debug.SetEnabled(not debug.GetEnabled())
	end

	if (input.KeyPressed("f12")) then
		curScaling = curScaling + 1
		if (curScaling == 6) then
			curScaling = 1
		end
		gScreen.load(curScaling)
	end

	if (currentGame) then
		currentGame.Update(dt)
	end

	hook.Call("Update", dt)

	gScreen.update(dt)
	timer.Update(dt)
	debug.Update()
	input.Update(dt)
end

function love.draw()
	gScreen.start() -- Start Scaling

	hook.Call("PreDraw")

	if (currentGame) then
		currentGame.Draw()

		debug.DrawText("Loaded: " .. currentGameInfo.name)
		debug.DrawText("test")
	end

	debug.Draw()

	hook.Call("Draw")
	hook.Call("PostDraw")

	gScreen.stop() -- Stop Scaling
end

function love.keypressed(key)
    input.keypressed(key)
end

local love_errorhandler = love.errhand

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end
