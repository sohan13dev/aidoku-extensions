function Info()
    return {
        name = "nhentai",
        author = "YourName",
        version = 1.0,
        description = "Fetch manga from nhentai.net",
        website = "https://nhentai.net"
    }
end

function Search(query)
    local url = "https://nhentai.net/search/?q=" .. query
    local result = Network.Request("GET", url, {})
    if result.code == 200 then
        local mangas = {}
        for id, title in result.body:gmatch('<a href="/g/(%d+)/".-><div class="caption">(.-)</div>') do
            table.insert(mangas, {
                id = id,
                title = title,
                url = "https://nhentai.net/g/" .. id
            })
        end
        return mangas
    else
        return {}
    end
end

function GetDetails(id)
    local url = "https://nhentai.net/g/" .. id
    local result = Network.Request("GET", url, {})
    if result.code == 200 then
        local title = result.body:match('<meta property="og:title" content="(.-)" />')
        local cover = result.body:match('<meta property="og:image" content="(.-)" />')
        return {
            title = title,
            cover = cover,
            url = url
        }
    else
        return nil
    end
end

function GetChapters(id)
    local url = "https://nhentai.net/g/" .. id
    local result = Network.Request("GET", url, {})
    if result.code == 200 then
        local pages = {}
        for pageUrl in result.body:gmatch('<a href="(/g/' .. id .. '/%d+)">') do
            table.insert(pages, "https://nhentai.net" .. pageUrl)
        end
        return pages
    else
        return {}
    end
end

function GetImages(chapterUrl)
    local result = Network.Request("GET", chapterUrl, {})
    if result.code == 200 then
        local images = {}
        for imageUrl in result.body:gmatch('<img src="(https://i%.nhentai%.net/galleries/%d+/.-)"') do
            table.insert(images, imageUrl)
        end
        return images
    else
        return {}
    end
end