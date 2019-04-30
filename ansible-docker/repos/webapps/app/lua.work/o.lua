-- DB比較用のデータをRedisのデータを出力
--  ->DB比較用に値をタブ区切りで並べた行データで返す
-- @key1 記事ID
-- @key2 枝番
-- @mode [article|enclosure|rlink]
--  article:記事, enclosure:アイキャッチ画像, rlink:関連リンク

-- 各パラメータ
local article_id = KEYS[1]
local serial_num = KEYS[2]
local mode = ARGV[1]

-- Redisのハッシュ型をkey-value型の配列に変換
-- 
-- @param Redisのハッシュ値
-- @return key-value値形式
local function _hash2map(_hash)
    local _map = {}
    for _i = 1, #_hash, 2 do
        _map[_hash[_i]] = _hash[_i + 1]
    end
    return _map
end

-- 変換処理 for 記事情報
-- @param __aid 記事ID 
-- @return 変換結果（タブ区切りした各値）
local function article2row(_aid)
    if redis.call("EXISTS", "ARTICLE:AID=" .. _aid) == 0 then
        return "NULL"
    end
    local _m = _hash2map(redis.call("HGETALL", "ARTICLE:AID=" .. _aid))
    local _t = {}

    table.insert(_t, _m.AID or "")
    table.insert(_t, _m.CPID or "")
    table.insert(_t, _m.URL or "")
    table.insert(_t, _m.CPGUID or "")
    table.insert(_t, redis.sha1hex(_m.TITLE or ""))
    table.insert(_t, redis.sha1hex(_m.DESCRIPTION or ""))
    table.insert(_t, redis.sha1hex(_m.URL_REPLACED_BODY or ""))
    table.insert(_t, _m.PUBLISHED or "")
    table.insert(_t, _m.MODIFIED or "")
    table.insert(_t, _m.IS_DELETED or "")
    table.insert(_t, _m.CREATOR or "")

    return table.concat(_t, "\t")
end

-- 変換処理 for 関連リンク
-- @param _aid 記事ID 
-- @param _num 枝番
-- @return 変換結果（タブ区切りした各値）
local function rlink2row(_aid, _num)
    local _key = "EYECATCH:EYEC=".. _num .. ":AID=" .. _aid
    if redis.call("EXISTS", _key) == 0 then
        return "NULL"
    end
    local _m = _hash2map(redis.call("HGETALL", _key))
    local _t = {}

    table.insert(_t, _aid)
    table.insert(_t, _num)
    table.insert(_t, redis.sha1hex(_m.TITLE or ""))
    table.insert(_t, _m.URL or "")

    return table.concat(_t, "\t")
end

-- 変換処理 for アイキャッチ画像
-- @param _aid 記事ID 
-- @param _num 枝番
-- @return 変換結果（タブ区切りした各値）
local function enclosure2row(_aid, _num)
    local _key = "EYECATCH:EYEC=".. _num .. ":AID=" .. _aid
    if redis.call("EXISTS", _key) == 0 then
        return "NULL"
    end
    local _m = _hash2map(redis.call("HGETALL", _key))
    local _t = {}

    table.insert(_t, _aid)
    table.insert(_t, _num)
    table.insert(_t, _m.URL or "")
    table.insert(_t, redis.sha1hex(_m.ALT or ""))
    table.insert(_t, _m.LENGTH or "")
    table.insert(_t, _m.TYPE or "")

    return table.concat(_t, "\t")
end

if (mode == "article") then return article2row(article_id) end
if (mode == "rlink") then return rlink2row(article_id, serial_num) end
if (mode == "enclosure") then return enclosure2row(article_id, serial_num) end
