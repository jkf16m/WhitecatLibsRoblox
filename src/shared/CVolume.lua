-- 4D implementation of CFrame, "Coordinate Frame" class of Roblox

local CVolume = {}
CVolume.__index = CVolume

function CVolume.new(x,y,z,w, xx, xy, yx, yz, zx, zy, wx, wy, wz)
    local self = {}
    self.x = x
    self.y = y
    self.z = z
    self.w = w
    self.xx = xx
    self.xy = xy
    self.yx = yx
    self.yz = yz
    self.zx = zx
    self.zy = zy
    self.wx = wx
    self.wy = wy
    self.wz = wz
    return setmetatable(self, CVolume)
end
