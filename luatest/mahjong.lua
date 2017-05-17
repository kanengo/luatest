local OneNineType = {
	{2,1},{2,9},{3,1},{3,9},{4,1},{4,9}
}

local Color = {
	FLOWER = 1, --花
	WAN    = 2, --万
	TONG   = 3, --同
	SUO    = 4, --索
	CHARACTER = 5, --东南西北中發白
}

local CardDigital = {
	ONE     = 1,  --(东)
	TWO     = 2,  --(南)
	THREE 	= 3,  --(西)
	FOUR	= 4,  --(北)
	FIVE	= 5,  --(中)
	SIX		= 6,  --(發)
	SEVEN	= 7,  --(白)
	EIGHT	= 8,
	NINE	= 9,
}
local table = table

--table浅复制
local function copy(src)
	if type(src) ~= "table" then
		return src
	end
	local ret = {}
	for k, v in pairs(src) do
		ret[k] = copy(v)
	end
	return ret
end

function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function checkHuAndType(cards, ghostCards)
	local function getKey(card)
    	return card.colorType * 10 + card.digitalNum
    end

    local function getCardByKey(cardKey)
    	return {digitalNum = math.floor(cardKey / 10), colorType = cardKey % 10}
    end

    local ghostKeys = {}
    local ghostNum = 0

    if ghostCards then
    	for _ ,ghost in ipairs(ghostCards) do
			ghostKeys[getKey(ghost)] = true
		end
    end

    local cardTypeCount = {}
    for _, card in pairs(cards) do
    	local key = getKey(card)
    	if ghostKeys[key] then
    		ghostNum = ghostNum + 1
    	elseif not cardTypeCount[key] then
    		cardTypeCount[key] = 1
    	else
    		cardTypeCount[key] = cardTypeCount[key] + 1
    	end
    end
    --dump(cardTypeCount, "first")
    for cardKey, count in pairs(cardTypeCount) do
    	if count >= 2 or count + ghostNum >= 2 then
    		local momentCount = 0
    		local pairCardKey = 0
    		local pengCount = 0
    		local allOneNine = true
    		local fourHea = 0
    		local threeYuan = 0
    		local colorCount = {}
    		local tmpCardTypeCount = copy(cardTypeCount)
    		local tmpGhostNum = ghostNum

    		if count < 2 then
    			tmpCardTypeCount[cardKey] = tmpCardTypeCount[cardKey] - count
    			tmpGhostNum = tmpGhostNum - (2 - count)
    		else
    			tmpCardTypeCount[cardKey] = tmpCardTypeCount[cardKey] - 2
    		end

    		pairCardKey = cardKey
    		local resultCards = {}
    		--print("pairCardKey", cardKey)
    		--print("tmpGhostNum", tmpGhostNum)
    		--dump(tmpCardTypeCount, "tmpCardTypeCount")
    		for cardKey, count in pairs(tmpCardTypeCount) do
    			if count > 0 then
    				--print("for cardKey", cardKey)
    				--print("guinum", tmpGhostNum)
    				local colorType, digitalNum = math.floor(cardKey / 10), cardKey % 10
    				local acc = 1
    				while tmpCardTypeCount[cardKey] > 0 do
    					acc = acc + 1
    					if acc > 1000 then
    						print("acc over")
    						return false
    					end
    					count = tmpCardTypeCount[cardKey]
		    			if count >= 3 then
		    				tmpCardTypeCount[cardKey] = tmpCardTypeCount[cardKey] - 3

		    				-- resultCards[#resultCards + 1] = cardKey
		    				-- resultCards[#resultCards + 1] = cardKey
		    				-- resultCards[#resultCards + 1] = cardKey

		    				momentCount = momentCount + 1
		    				pengCount = pengCount + 1
		    				if not colorCount[colorType] then
		    					colorCount[colorType] = 1
		    				else
		    					colorCount[colorType] = colorCount[colorType] + 1
		    				end

		    				if allOneNine and (cardKey % 10 ~= 1 and cardKey % 10 ~= 9) then
		    					allOneNine = false
		    				end
	    					if cardKey >= 51 and cardKey <= 54 then
	    						fourHea =  fourHea + 1
	    					elseif cardKey >= 55 and cardKey <= 57 then
	    						threeYuan = threeYuan + 1
		    				end
		    			elseif colorType ~= Color.CHARACTER and digitalNum <= 7 and 
		    					tmpCardTypeCount[cardKey + 1] and tmpCardTypeCount[cardKey + 1] > 0 and 
	    						tmpCardTypeCount[cardKey + 2] and tmpCardTypeCount[cardKey + 2] > 0
	    						then
	    						tmpCardTypeCount[cardKey] = tmpCardTypeCount[cardKey] - 1
	    						tmpCardTypeCount[cardKey + 1] = tmpCardTypeCount[cardKey + 1] - 1
	    						tmpCardTypeCount[cardKey + 2] = tmpCardTypeCount[cardKey + 2] - 1
	    						-- resultCards[#resultCards + 1] = cardKey
	    						-- resultCards[#resultCards + 1] = cardKey + 1
	    						-- resultCards[#resultCards + 1] = cardKey + 2

	    						if not colorCount[colorType] then
			    					colorCount[colorType] = 1
			    				else
			    					colorCount[colorType] = colorCount[colorType] + 1
			    				end

	    						momentCount = momentCount + 1
	    						allOneNine = false
		    			elseif count == 2 and tmpGhostNum >= 1 then
		    				tmpCardTypeCount[cardKey] = tmpCardTypeCount[cardKey] - 2
		    				-- resultCards[#resultCards + 1] = cardKey
		    				-- resultCards[#resultCards + 1] = cardKey
		    				-- resultCards[#resultCards + 1] = -cardKey
		    				momentCount = momentCount + 1
		    				pengCount = pengCount + 1
		    				if not colorCount[colorType] then
		    					colorCount[colorType] = 1
		    				else
		    					colorCount[colorType] = colorCount[colorType] + 1
		    				end

		    				if allOneNine and (cardKey % 10 ~= 1 and cardKey % 10 ~= 9) then
		    					allOneNine = false
		    				end
	    					if cardKey >= 51 and cardKey <= 54 then
	    						fourHea =  fourHea + 1
	    					elseif cardKey >= 55 and cardKey <= 57 then
	    						threeYuan = threeYuan + 1
		    				end
		    				tmpGhostNum = tmpGhostNum - 1
		    			elseif colorType ~= Color.CHARACTER and digitalNum <= 8 and tmpGhostNum > 0  then
		    				if tmpCardTypeCount[cardKey + 1] and tmpCardTypeCount[cardKey + 1] > 0 and tmpGhostNum > 0 then
	    						tmpGhostNum = tmpGhostNum - 1
	    						tmpCardTypeCount[cardKey] = tmpCardTypeCount[cardKey] - 1
	    						tmpCardTypeCount[cardKey + 1] = tmpCardTypeCount[cardKey + 1] - 1
	    						-- resultCards[#resultCards + 1] = cardKey
	    						-- resultCards[#resultCards + 1] = cardKey + 1
	    						-- resultCards[#resultCards + 1] = -cardKey
	    						if not colorCount[colorType] then
			    					colorCount[colorType] = 1
			    				else
			    					colorCount[colorType] = colorCount[colorType] + 1
			    				end

	    						momentCount = momentCount + 1
	    						allOneNine = false
		    				elseif digitalNum < 8 and tmpCardTypeCount[cardKey + 2] and tmpCardTypeCount[cardKey + 2] > 0 and tmpGhostNum > 0 then
	    						tmpGhostNum = tmpGhostNum - 1
	    						tmpCardTypeCount[cardKey] = tmpCardTypeCount[cardKey] - 1
	    						tmpCardTypeCount[cardKey + 2] = tmpCardTypeCount[cardKey + 2] - 1
	    						-- resultCards[#resultCards + 1] = cardKey
	    						-- resultCards[#resultCards + 1] = -cardKey 
	    						-- resultCards[#resultCards + 1] = cardKey + 2
	    						if not colorCount[colorType] then
			    					colorCount[colorType] = 1
			    				else
			    					colorCount[colorType] = colorCount[colorType] + 1
			    				end

	    						momentCount = momentCount + 1
	    						allOneNine = false
	    					elseif count + tmpGhostNum >= 3 then
		    					tmpCardTypeCount[cardKey] = tmpCardTypeCount[cardKey] - count
		    					-- resultCards[#resultCards + 1] = cardKey
		    					-- resultCards[#resultCards + 1] = -cardKey
		    					-- resultCards[#resultCards + 1] = -cardKey

			    				momentCount = momentCount + 1
			    				pengCount = pengCount + 1
			    				if not colorCount[colorType] then
			    					colorCount[colorType] = 1
			    				else
			    					colorCount[colorType] = colorCount[colorType] + 1
			    				end

			    				if allOneNine and (cardKey % 10 ~= 1 and cardKey % 10 ~= 9) then
			    					allOneNine = false
			    				end
		    					if cardKey >= 51 and cardKey <= 54 then
		    						fourHea =  fourHea + 1
		    					elseif cardKey >= 55 and cardKey <= 57 then
		    						threeYuan = threeYuan + 1
			    				end
			    				tmpGhostNum = tmpGhostNum - (3 - count)
			    			else
			    				break
		    				end
		    			else
		    				break
		    			end
		    		end
	    		--dump(tmpCardTypeCount, "after for key")
	    		end
    		end

    		if momentCount == 4 then
    			local huType = 1
    			if fourHea == 3 then 
    				print(1)
    			elseif fourHea == 4 then 
    				print(2)
    			elseif threeYuan == 3 then 
    				print(3)
    			elseif threeYuan == 2 and pairCardKey >= 55 and pairCardKey <= 57 then 
    				print(4) 
    			elseif allOneNine and math.floor(pairCardKey / 10) == Color.CHARACTER then 
    				print(5)  
    			elseif allOneNine and (pairCardKey % 10 == 1 or pairCardKey % 10 == 9) then 
    				print(6) 
    			elseif colorCount[Color.CHARACTER] and colorCount[Color.CHARACTER] == 4 then 
    				print(7)
    			elseif table.nums(colorCount) == 1 then 
    				if math.floor(pairCardKey / 10) == Color.CHARACTER then
    					if pengCount == 4 then 
    						print(8)
    					else
    						print(9)
    					end
    				elseif colorCount[math.floor(pairCardKey / 10)] then
						if pengCount == 4 then
							print(10) 
    					else
    						print(11)
    					end
    				end
    			elseif pengCount == 4 then 
    				print(12)
    			elseif pengCount == 0 then 
    				print(13) 
    			end
    			--dump(resultCards)
    			return true, huType
    		end
    	end
    end
    return false
end

--测试牌型
local cards = {
	{digitalNum = 1, colorType = 2},
	{digitalNum = 1, colorType = 2},


	{digitalNum = 3, colorType = 2},
	{digitalNum = 3, colorType = 2},

	{digitalNum = 5, colorType = 2},

	{digitalNum = 6, colorType = 2},
	{digitalNum = 7, colorType = 2},
	{digitalNum = 8, colorType = 2},

	{digitalNum = 9, colorType = 3},
	{digitalNum = 9, colorType = 3},
	{digitalNum = 9, colorType = 3},

	{digitalNum = 1, colorType = 5},
	{digitalNum = 1, colorType = 5},
	{digitalNum = 1, colorType = 5},
}

local t1 = os.clock()
for i = 1, 1000 do
	checkHuAndType(cards, {{digitalNum = 1, colorType = 5}})
end

print(os.clock() - t1)