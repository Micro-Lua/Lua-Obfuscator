math.randomseed(os.time())

local input  = arg[1] or "input.lua"
local output = arg[2] or "output.lua"

local function read(path)
    local f = assert(io.open(path, "rb"))
    local content = f:read("*a")
    f:close()
    return content
end

local function write(path, data)
    local f = assert(io.open(path, "wb"))
    f:write(data)
    f:close()
end

local function gvr()
    return "_" .. math.random(1,1024) .. "_" .. math.random(1,1024)
end

local function gso(len, key)
    local ord = {}
    for i = 1, len do ord[i] = i end

    local seed = 0
    for i = 1, #key do
        seed = (seed + string.byte(key, i) * i) % 2147483647
    end

    for i = len, 2, -1 do
        seed = (seed * 1664525 + 1013904223) % 2147483647
        local j = (seed % i) + 1
        ord[i], ord[j] = ord[j], ord[i]
    end

    return ord
end

local function enc(src, key)
    local kln = #key
    local tmp = {}

    for i = 1, #src do
        local byt = string.byte(src, i)
        local kbt = string.byte(key, ((i - 1) % kln) + 1)

        tmp[i] = (byt + kbt * 3 + i * 17 + (kbt % 7) * i) % 256
    end

    local ord = gso(#tmp, key)
    local shf = {}

    for i = 1, #tmp do
        shf[i] = tmp[ord[i]]
    end

    local chr = {}
    for i = 1, #shf do
        chr[i] = string.char(shf[i])
    end

    return table.concat(chr)
end

local function hex(str)
    return (str:gsub(".", function(c)
        return string.format("%02X", string.byte(c))
    end))
end

local function lrd(src, key)
    local loader = [=[local a,b,c,d,e=string.byte,string.char,table.concat,tonumber,loadstring or load;local f="]=] .. src .. [=["local function g(h,i)local j=0;local k;local l;while true do if j==0 or 4593<=3808-1136 then k={}for m=1066-(68+997),h do k[m]=m end;j=2-1 end;if j==2-1 or 5085-3917>3156 then l=117-(32+85)for n=1,#i do l=(l+a(i,n)*n)%(2813442830-665959183)end;j=4-2 end;if j==621-(555+64)or 572>5443-(892+65)then for o=h,933-(857+74),-1 do l=(l*(3076768-1412243)+1013904791-(367+201))%(2147484574-(214+713))local p=l%o+1-0;k[o],k[p]=k[p],k[o]end;return k end end end;local function q(r,s)local t=#s;local u={}for v=1,#r do u[v]=a(r,v)end;local w=g(#u,s)local x={}for y=351-(87+263),#u do x[w[y]]=u[y]end;local z={}for A=1+0,#x do local B=a(s,(A-1)%t+1+0)local C=(x[A]-(B*(880-(282+595))+A*(1654-(1523+114))+B%7*A))%(628-372)z[A]=b(C)end;return c(z)end;local function D(E)return E:gsub("..",function(F)return b(d(F,15+1))end)end;return e(q(D(f),"]=] .. key .. [=["))()]=]
    return loader
end

local src = read(input)

src = src:gsub("%-%-.-\n","")

local key = gvr()
local encd = hex(enc(src, key))
local final = lrd(encd, key)

write(output, final)

print("Size:   "..#final.." bytes")
