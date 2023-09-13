require("math")
local lookup = require("lookup")

gBaseStats = 0x97bf67c
gBaseStats_struct_size = 0x1C
gBaseStats_gender_ratio_offset = 0x10
gBaseStats_ability1_offset = 0x16
gBaseStats_ability2_offset = 0x17
gBaseStats_type1_offset = 0x6
gBaseStats_type2_offset = 0x7
gBaseStats_hidden_ability_offset = 0x1A

-- specific to Radical Red 4
-- if you try to adapt this to some other game and find error this is probably
-- what you want to look at
local substructSelector = {
    [0] = { 0, 1, 2, 3 },
    [1] = { 0, 1, 2, 3 },
    [2] = { 0, 1, 2, 3 },
    [3] = { 0, 1, 2, 3 },
    [4] = { 0, 1, 2, 3 },
    [5] = { 0, 1, 2, 3 },
    [6] = { 0, 1, 2, 3 },
    [7] = { 0, 1, 2, 3 },
    [8] = { 0, 1, 2, 3 },
    [9] = { 0, 1, 2, 3 },
    [10] = { 0, 1, 2, 3 },
    [11] = { 0, 1, 2, 3 },
    [12] = { 0, 1, 2, 3 },
    [13] = { 0, 1, 2, 3 },
    [14] = { 0, 1, 2, 3 },
    [15] = { 0, 1, 2, 3 },
    [16] = { 0, 1, 2, 3 },
    [17] = { 0, 1, 2, 3 },
    [18] = { 0, 1, 2, 3 },
    [19] = { 0, 1, 2, 3 },
    [20] = { 0, 1, 2, 3 },
    [21] = { 0, 1, 2, 3 },
    [22] = { 0, 1, 2, 3 },
    [23] = { 0, 1, 2, 3 },
}

local Game = {
    new = function(self, game)
        self.__index = self
        setmetatable(game, self)
        return game
    end,
}

function Game.getParty(game)
    local party = {}
    local monStart = game._party
    local nameStart = game._partyNames
    local otStart = game._partyOt
    for i = 1, emu:read8(game._partyCount) do
        party[i] = game:_readPartyMon(monStart, nameStart, otStart)
        monStart = monStart + game._partyMonSize
        if game._partyNames then
            nameStart = nameStart + game._monNameLength + 1
        end
        if game._partyOt then
            otStart = otStart + game._playerNameLength + 1
        end
    end
    return party
end

function Game.toString(game, rawstring)
    local string = ""
    for _, char in ipairs({ rawstring:byte(1, #rawstring) }) do
        if char == game._terminator then
            break
        end
        string = string .. game._charmap[char]
    end
    return string
end

local GBGameEn = Game:new({
    _terminator = 0x50,
    _monNameLength = 10,
    _speciesNameLength = 10,
    _playerNameLength = 10,
})

local GBAGameEn = Game:new({
    _terminator = 0xFF,
    _monNameLength = 10,
    _speciesNameLength = 11,
    _playerNameLength = 10,
})

local Generation1En = GBGameEn:new({
    _boxMonSize = 33,
    _partyMonSize = 44,
    _readBoxMon = readBoxMonGen1,
    _readPartyMon = readPartyMonGen1,
})

local Generation2En = GBGameEn:new({
    _boxMonSize = 32,
    _partyMonSize = 48,
    _readBoxMon = readBoxMonGen2,
    _readPartyMon = readPartyMonGen2,
})

local Generation3En = GBAGameEn:new({
    _boxMonSize = 80,
    _partyMonSize = 100,
    _readBoxMon = readBoxMonGen3,
    _readPartyMon = readPartyMonGen3,
})

-- stylua: ignore
GBGameEn._charmap = { [0]=
    "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�",
    "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�",
    "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�",
    "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�",
    "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�",
    "", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�",
    "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�",
    "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", " ",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
    "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "(", ")", ":", ";", "[", "]",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
    "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "é", "ʼd", "ʼl", "ʼs", "ʼt", "ʼv",
    "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�",
    "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�", "�",
    "'", "P\u{200d}k", "M\u{200d}n", "-", "ʼr", "ʼm", "?", "!", ".", "ァ", "ゥ", "ェ", "▹", "▸", "▾", "♂",
    "$", "×", ".", "/", ",", "♀", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
}

-- stylua: ignore
GBAGameEn._charmap = { [0]=
    " ", "À", "Á", "Â", "Ç", "È", "É", "Ê", "Ë", "Ì", "こ", "Î", "Ï", "Ò", "Ó", "Ô",
    "Œ", "Ù", "Ú", "Û", "Ñ", "ß", "à", "á", "ね", "ç", "è", "é", "ê", "ë", "ì", "ま",
    "î", "ï", "ò", "ó", "ô", "œ", "ù", "ú", "û", "ñ", "º", "ª", "�", "&", "+", "あ",
    "ぃ", "ぅ", "ぇ", "ぉ", "v", "=", "ょ", "が", "ぎ", "ぐ", "げ", "ご", "ざ", "じ", "ず", "ぜ",
    "ぞ", "だ", "ぢ", "づ", "で", "ど", "ば", "び", "ぶ", "べ", "ぼ", "ぱ", "ぴ", "ぷ", "ぺ", "ぽ",
    "っ", "¿", "¡", "P\u{200d}k", "M\u{200d}n", "P\u{200d}o", "K\u{200d}é", "�", "�", "�", "Í", "%", "(", ")", "セ", "ソ",
    "タ", "チ", "ツ", "テ", "ト", "ナ", "ニ", "ヌ", "â", "ノ", "ハ", "ヒ", "フ", "ヘ", "ホ", "í",
    "ミ", "ム", "メ", "モ", "ヤ", "ユ", "ヨ", "ラ", "リ", "⬆", "⬇", "⬅", "➡", "ヲ", "ン", "ァ",
    "ィ", "ゥ", "ェ", "ォ", "ャ", "ュ", "ョ", "ガ", "ギ", "グ", "ゲ", "ゴ", "ザ", "ジ", "ズ", "ゼ",
    "ゾ", "ダ", "ヂ", "ヅ", "デ", "ド", "バ", "ビ", "ブ", "ベ", "ボ", "パ", "ピ", "プ", "ペ", "ポ",
    "ッ", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "!", "?", ".", "-", "・",
    "…", "“", "”", "‘", "’", "♂", "♀", "$", ",", "×", "/", "A", "B", "C", "D", "E",
    "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U",
    "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
    "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "▶",
    ":", "Ä", "Ö", "Ü", "ä", "ö", "ü", "⬆", "⬇", "⬅", "�", "�", "�", "�", "�", ""
}

function _read16BE(emu, address)
    return (emu:read8(address) << 8) | emu:read8(address + 1)
end

function Generation1En._readBoxMon(game, address, nameAddress, otAddress)
    local mon = {}
    mon.species = emu.memory.cart0:read8(game._speciesIndex + emu:read8(address + 0) - 1)
    mon.hp = _read16BE(emu, address + 1)
    mon.level = emu:read8(address + 3)
    mon.status = emu:read8(address + 4)
    mon.type1 = emu:read8(address + 5)
    mon.type2 = emu:read8(address + 6)
    mon.catchRate = emu:read8(address + 7)
    mon.moves = {
        emu:read8(address + 8),
        emu:read8(address + 9),
        emu:read8(address + 10),
        emu:read8(address + 11),
    }
    mon.otId = _read16BE(emu, address + 12)
    mon.experience = (_read16BE(emu, address + 14) << 8) | emu:read8(address + 16)
    mon.hpEV = _read16BE(emu, address + 17)
    mon.attackEV = _read16BE(emu, address + 19)
    mon.defenseEV = _read16BE(emu, address + 21)
    mon.speedEV = _read16BE(emu, address + 23)
    mon.spAttackEV = _read16BE(emu, address + 25)
    mon.spDefenseEV = mon.spAttackEv
    local iv = _read16BE(emu, address + 27)
    mon.attackIV = (iv >> 4) & 0xF
    mon.defenseIV = iv & 0xF
    mon.speedIV = (iv >> 12) & 0xF
    mon.spAttackIV = (iv >> 8) & 0xF
    mon.spDefenseIV = mon.spAttackIV
    mon.pp = {
        emu:read8(address + 28),
        emu:read8(address + 29),
        emu:read8(address + 30),
        emu:read8(address + 31),
    }
    mon.nickname = game:toString(emu:readRange(nameAddress, game._monNameLength))
    mon.otName = game:toString(emu:readRange(otAddress, game._playerNameLength))
    return mon
end

function Generation1En._readPartyMon(game, address, nameAddress, otAddress)
    local mon = game:_readBoxMon(address, nameAddress, otAddress)
    mon.level = emu:read8(address + 33)
    mon.maxHP = _read16BE(emu, address + 34)
    mon.attack = _read16BE(emu, address + 36)
    mon.defense = _read16BE(emu, address + 38)
    mon.speed = _read16BE(emu, address + 40)
    mon.spAttack = _read16BE(emu, address + 42)
    mon.spDefense = mon.spAttack
    return mon
end

function Generation2En._readBoxMon(game, address, nameAddress, otAddress)
    local mon = {}
    mon.species = emu:read8(address + 0)
    mon.item = emu:read8(address + 1)
    mon.moves = {
        emu:read8(address + 2),
        emu:read8(address + 3),
        emu:read8(address + 4),
        emu:read8(address + 5),
    }
    mon.otId = _read16BE(emu, address + 6)
    mon.experience = (_read16BE(emu, address + 8) << 8) | emu:read8(address + 10)
    mon.hpEV = _read16BE(emu, address + 11)
    mon.attackEV = _read16BE(emu, address + 13)
    mon.defenseEV = _read16BE(emu, address + 15)
    mon.speedEV = _read16BE(emu, address + 17)
    mon.spAttackEV = _read16BE(emu, address + 19)
    mon.spDefenseEV = mon.spAttackEv
    local iv = _read16BE(emu, address + 21)
    mon.attackIV = (iv >> 4) & 0xF
    mon.defenseIV = iv & 0xF
    mon.speedIV = (iv >> 12) & 0xF
    mon.spAttackIV = (iv >> 8) & 0xF
    mon.spDefenseIV = mon.spAttackIV
    mon.pp = {
        emu:read8(address + 23),
        emu:read8(address + 24),
        emu:read8(address + 25),
        emu:read8(address + 26),
    }
    mon.friendship = emu:read8(address + 27)
    mon.pokerus = emu:read8(address + 28)
    local caughtData = _read16BE(emu, address + 29)
    mon.metLocation = (caughtData >> 8) & 0x7F
    mon.metLevel = caughtData & 0x1F
    mon.level = emu:read8(address + 31)
    mon.nickname = game:toString(emu:readRange(nameAddress, game._monNameLength))
    mon.otName = game:toString(emu:readRange(otAddress, game._playerNameLength))
    return mon
end

function Generation2En._readPartyMon(game, address, nameAddress, otAddress)
    local mon = game:_readBoxMon(address, nameAddress, otAddress)
    mon.status = emu:read8(address + 32)
    mon.hp = _read16BE(emu, address + 34)
    mon.maxHP = _read16BE(emu, address + 36)
    mon.attack = _read16BE(emu, address + 38)
    mon.defense = _read16BE(emu, address + 40)
    mon.speed = _read16BE(emu, address + 42)
    mon.spAttack = _read16BE(emu, address + 44)
    mon.spDefense = _read16BE(emu, address + 46)
    return mon
end

function Generation3En._readBoxMon(game, address)
    local mon = {}
    mon.personality = emu:read32(address + 0)
    mon.otId = emu:read32(address + 4)
    mon.nickname = game:toString(emu:readRange(address + 8, game._monNameLength))
    mon.language = emu:read8(address + 18)
    local flags = emu:read8(address + 19)
    mon.isBadEgg = flags & 1
    mon.hasSpecies = (flags >> 1) & 1
    mon.isEgg = (flags >> 2) & 1
    mon.otName = game:toString(emu:readRange(address + 20, game._playerNameLength))
    mon.markings = emu:read8(address + 27)

    local pSel = substructSelector[mon.personality % 24]
    local ss0 = {}
    local ss1 = {}
    local ss2 = {}
    local ss3 = {}

    for i = 0, 2 do
        ss0[i] = emu:read32(address + 32 + pSel[1] * 12 + i * 4) -- growth
        ss1[i] = emu:read32(address + 32 + pSel[2] * 12 + i * 4) -- attack
        ss2[i] = emu:read32(address + 32 + pSel[3] * 12 + i * 4) -- effort
        ss3[i] = emu:read32(address + 32 + pSel[4] * 12 + i * 4) -- misc
    end

    mon.species = ss0[0] & 0xFFFF
    mon.heldItem = ss0[0] >> 16
    mon.experience = ss0[1]
    mon.ppBonuses = ss0[2] & 0xFF
    mon.friendship = (ss0[2] >> 8) & 0xFF

    mon.moves = {
        ss1[0] & 0xFFFF,
        ss1[0] >> 16,
        ss1[1] & 0xFFFF,
        ss1[1] >> 16,
    }
    mon.pp = {
        ss1[2] & 0xFF,
        (ss1[2] >> 8) & 0xFF,
        (ss1[2] >> 16) & 0xFF,
        ss1[2] >> 24,
    }

    mon.hpEV = ss2[0] & 0xFF
    mon.attackEV = (ss2[0] >> 8) & 0xFF
    mon.defenseEV = (ss2[0] >> 16) & 0xFF
    mon.speedEV = ss2[0] >> 24
    mon.spAttackEV = ss2[1] & 0xFF
    mon.spDefenseEV = (ss2[1] >> 8) & 0xFF
    mon.cool = (ss2[1] >> 16) & 0xFF
    mon.beauty = ss2[1] >> 24
    mon.cute = ss2[2] & 0xFF
    mon.smart = (ss2[2] >> 8) & 0xFF
    mon.tough = (ss2[2] >> 16) & 0xFF
    mon.sheen = ss2[2] >> 24

    mon.pokerus = ss3[0] & 0xFF
    mon.metLocation = (ss3[0] >> 8) & 0xFF
    flags = ss3[0] >> 16
    mon.metLevel = flags & 0x7F
    mon.metGame = (flags >> 7) & 0xF
    mon.pokeball = (flags >> 11) & 0xF
    mon.otGender = (flags >> 15) & 0x1
    flags = ss3[1]
    mon.hpIV = flags & 0x1F
    mon.attackIV = (flags >> 5) & 0x1F
    mon.defenseIV = (flags >> 10) & 0x1F
    mon.speedIV = (flags >> 15) & 0x1F
    mon.spAttackIV = (flags >> 20) & 0x1F
    mon.spDefenseIV = (flags >> 25) & 0x1F
    -- Bit 30 is another "isEgg" bit
    mon.hasHiddenAbility = (flags >> 31) & 1
    flags = ss3[2]
    mon.coolRibbon = flags & 7
    mon.beautyRibbon = (flags >> 3) & 7
    mon.cuteRibbon = (flags >> 6) & 7
    mon.smartRibbon = (flags >> 9) & 7
    mon.toughRibbon = (flags >> 12) & 7
    mon.championRibbon = (flags >> 15) & 1
    mon.winningRibbon = (flags >> 16) & 1
    mon.victoryRibbon = (flags >> 17) & 1
    mon.artistRibbon = (flags >> 18) & 1
    mon.effortRibbon = (flags >> 19) & 1
    mon.marineRibbon = (flags >> 20) & 1
    mon.landRibbon = (flags >> 21) & 1
    mon.skyRibbon = (flags >> 22) & 1
    mon.countryRibbon = (flags >> 23) & 1
    mon.nationalRibbon = (flags >> 24) & 1
    mon.earthRibbon = (flags >> 25) & 1
    mon.worldRibbon = (flags >> 26) & 1
    mon.eventLegal = (flags >> 27) & 0x1F

    local p_gender = mon.personality % 256
    local gender_ratio = emu:read8(gBaseStats + gBaseStats_struct_size * mon.species + gBaseStats_gender_ratio_offset)
    if gender_ratio == 0 then
        mon.gender = "M"
    elseif gender_ratio == 254 then
        mon.gender = "F"
    elseif gender_ratio == 255 then
        mon.gender = "Gender unknown"
    else
        if p_gender < gender_ratio then
            mon.gender = "F"
        else
            mon.gender = "M"
        end
    end

    local ability1 = emu:read8(gBaseStats + gBaseStats_struct_size * mon.species + gBaseStats_ability1_offset)
    local ability2 = emu:read8(gBaseStats + gBaseStats_struct_size * mon.species + gBaseStats_ability2_offset)
    local hidden_ability =
        emu:read8(gBaseStats + gBaseStats_struct_size * mon.species + gBaseStats_hidden_ability_offset)
    if mon.hasHiddenAbility == 1 and hidden_ability ~= 0 then
        mon.ability = hidden_ability
    else
        if (mon.personality & 1) == 0 or (ability2 == 0) then
            mon.ability = ability1
        else
            mon.ability = ability2
        end
    end

    mon.type1 = emu:read8(gBaseStats + gBaseStats_struct_size * mon.species + gBaseStats_type1_offset)
    mon.type2 = emu:read8(gBaseStats + gBaseStats_struct_size * mon.species + gBaseStats_type2_offset)

    return mon
end

function Generation3En._readPartyMon(game, address)
    local mon = game:_readBoxMon(address)
    mon.status = emu:read32(address + 80)
    mon.level = emu:read8(address + 84)
    mon.mail = emu:read32(address + 85)
    mon.hp = emu:read16(address + 86)
    mon.maxHP = emu:read16(address + 88)
    mon.attack = emu:read16(address + 90)
    mon.defense = emu:read16(address + 92)
    mon.speed = emu:read16(address + 94)
    mon.spAttack = emu:read16(address + 96)
    mon.spDefense = emu:read16(address + 98)
    return mon
end

local gameRBEn = Generation1En:new({
    name = "Red/Blue (USA)",
    _party = 0xd16b,
    _partyCount = 0xd163,
    _partyNames = 0xd2b5,
    _partyOt = 0xd273,
    _speciesNameTable = 0x1c21e,
    _speciesIndex = 0x41024,
})

local gameYellowEn = Generation1En:new({
    name = "Yellow (USA)",
    _party = 0xd16a,
    _partyCount = 0xd162,
    _partyNames = 0xd2b4,
    _partyOt = 0xd272,
    _speciesNameTable = 0xe8000,
    _speciesIndex = 0x410b1,
})

local gameGSEn = Generation2En:new({
    name = "Gold/Silver (USA)",
    _party = 0xda2a,
    _partyCount = 0xda22,
    _partyNames = 0xdb8c,
    _partyOt = 0xdb4a,
    _speciesNameTable = 0x1b0b6a,
})

local gameCrystalEn = Generation2En:new({
    name = "Crystal (USA)",
    _party = 0xdcdf,
    _partyCount = 0xdcd7,
    _partyNames = 0xde41,
    _partyOt = 0xddff,
    _speciesNameTable = 0x5337a,
})

local gameRubyEn = Generation3En:new({
    name = "Ruby (USA)",
    _party = 0x3004360,
    _partyCount = 0x3004350,
    _speciesNameTable = 0x1f716c,
})

local gameSapphireEn = Generation3En:new({
    name = "Sapphire (USA)",
    _party = 0x3004360,
    _partyCount = 0x3004350,
    _speciesNameTable = 0x1f70fc,
})

local gameEmeraldEn = Generation3En:new({
    name = "Emerald (USA)",
    _party = 0x20244ec,
    _partyCount = 0x20244e9,
    _speciesNameTable = 0x3185c8,
})

local gameFireRedEn = Generation3En:new({
    name = "FireRed (USA)",
    _party = 0x2024284,
    _partyCount = 0x2024029,
    _speciesNameTable = 0x245ee0,
})

local gameFireRedEnR1 = gameFireRedEn:new({
    name = "FireRed (USA) (Rev 1)",
    _speciesNameTable = 0x245f50,
})

local gameLeafGreenEn = Generation3En:new({
    name = "LeafGreen (USA)",
    _party = 0x2024284,
    _partyCount = 0x2024029,
    _speciesNameTable = 0x245ebc,
})

local gameLeafGreenEnR1 = gameLeafGreenEn:new({
    name = "LeafGreen (USA)",
    _party = 0x2024284,
    _partyCount = 0x2024029,
    _speciesNameTable = 0x245f2c,
})

gameCodes = {
    ["DMG-AAUE"] = gameGSEn, -- Gold
    ["DMG-AAXE"] = gameGSEn, -- Silver
    ["CGB-BYTE"] = gameCrystalEn,
    ["AGB-AXVE"] = gameRubyEn,
    ["AGB-AXPE"] = gameSapphireEn,
    ["AGB-BPEE"] = gameEmeraldEn,
    ["AGB-BPRE"] = gameFireRedEn,
    ["AGB-BPGE"] = gameLeafGreenEn,
}

-- These versions have slight differences and/or cannot be uniquely
-- identified by their in-header game codes, so fall back on a CRC32
gameCrc32 = {
    [0x9f7fdd53] = gameRBEn, -- Red
    [0xd6da8a1a] = gameRBEn, -- Blue
    [0x7d527d62] = gameYellowEn,
    [0x3358e30a] = gameCrystal, -- Crystal rev 1
    [0x84ee4776] = gameFireRedEnR1,
    [0xdaffecec] = gameLeafGreenEnR1,
}

-- TODO change this so we can print both current party and enemy party
function printPartyStatus(game)
    partyBuffer:clear()
    for _, mon in ipairs(game:getParty()) do
        -- printMon(mon, partyBuffer) -- the emulator refreshes too quickly to use this
        partyBuffer:print(
            string.format(
                "%s (Lv%3i): %3i/%3i\n",
                species[mon.species],
                mon.level,
                mon.hp,
                mon.maxHP
            )
        )
    end
end

function detectGame()
    local checksum = 0
    for i, v in ipairs({ emu:checksum(C.CHECKSUM.CRC32):byte(1, 4) }) do
        checksum = checksum * 256 + v
    end
    game = gameCrc32[checksum]
    if not game then
        game = gameCodes[emu:getGameCode()]
    end

    if not game then
        console:error("Unknown game!")
    else
        console:log("Found game: " .. game.name)
        if not partyBuffer then
            partyBuffer = console:createBuffer("Party")
        end
        if not exportBuffer then
            exportBuffer = console:createBuffer("Exports")
            exportBuffer:setSize(200, 1000)
        end
    end
end

function printMon(mon, buffer)
    str = ""
    str = str .. mon.nickname .. " (" .. species[mon.species] .. ")"
    if item[mon.heldItem] then
        str = str .. string.format(" @ %s", item[mon.heldItem])
    end
    str = str .. string.format("\n")
    str = str
        .. "Ability: "
        .. string.format("%s", ability[mon.ability])
        .. string.format("\n")
    str = str .. string.format("Level: %d\n", mon.level)
    str = str .. string.format("%s", nature[(mon.personality % 25) + 1]) .. " Nature" .. string.format("\n")
    str = str
        .. string.format(
            "IVs: %d HP / %d Atk / %d Def / %d SpA / %d SpD / %d Spe",
            mon.hpIV,
            mon.attackIV,
            mon.defenseIV,
            mon.spAttackIV,
            mon.spDefenseIV,
            mon.speedIV
        )
        .. string.format("\n")
    for i = 1, 4 do
        local mv = move[mon.moves[i]]
        if mv ~= "" then
            str = str .. string.format("- %s\n", mv)
        end
    end
    str = str .. string.format("\n")
    buffer:print(str)
end

-- TODO
function pc()
    address = 0x2029800 + 4 + emu:read8(0x3005d94)
    i = 0
    exportparty()
    while i < 120 do
        if emu:read32(address) ~= 0 then
            printMon(game:_readBoxMon(address), exportBuffer)
        end
        i = i + 1
        address = address + 80
    end
end

function party()
    exportBuffer:clear()
    for _, mon in ipairs(game:getParty()) do
        printMon(mon, exportBuffer)
    end
end

function updatePartyBuffer()
    if not game or not partyBuffer then
        return
    end
    printPartyStatus(game, partyBuffer)
end

function help()
    exportBuffer:clear()
    exportBuffer:print("Available commands:\n")
    exportBuffer:print(" party() - exports showdown calc verison of party to console\n")
    exportBuffer:print(" pc() - exports showdown calc verison of first 5 boxes + party to console\n")
end

callbacks:add("start", detectGame)
callbacks:add("frame", updatePartyBuffer) -- useful for print debugging in real time lmao
if emu then
    detectGame()
    help()
end
