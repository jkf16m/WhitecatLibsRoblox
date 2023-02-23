--!strict
local IEqual = require(script.Parent.Interfaces.IEqual)
type Vector4Inst = {
    x: number,
    y: number,
    z: number,
    w: number,
    GetVector3: () -> Vector3,
    FromVector3: (Vector3, number) -> Vector4Inst,
    Clone: () -> Vector4Inst,
    __add: (Vector4Inst) -> Vector4Inst,
    __mul: (Vector4Inst) -> Vector4Inst,
    __div: (Vector4Inst) -> Vector4Inst
}
type Vector4 = IEqual.IEqual<Vector4Inst> & Vector4Inst

local Vector4: Vector4 = {}
Vector4.__index = Vector4


function Vector4.is(other) : Vector4
    return type(other) == "table" and getmetatable(other) == Vector4
end

function Vector4.new(x:number, y:number, z:number, w:number): Vector4
    local self = {
        x = x,
        y = y,
        z = z,
        w = w
    }
    return setmetatable(self, Vector4)
end
function Vector4:GetVector3() : Vector3
    return Vector3.new(self.x, self.y, self.z)
end
function Vector4.FromVector3(vector3:Vector3, w:number)
    local self = {
        x = vector3.X,
        y = vector3.Y,
        z = vector3.Z,
        w = w
    }
    return setmetatable(self, Vector4)
end

function Vector4:Clone()
    return Vector4.new(self.x, self.y, self.z, self.w)
end

function Vector4:__add(other: Vector4) :Vector4
    return Vector4.new(
        self.vector3.X + other.vector3.X,
        self.vector3.Y + other.vector3.Y,
        self.vector3.Z + other.vector3.Z,
        self.w + other.w
    )
end

function Vector4:__mul(other:Vector4) : Vector4
    return Vector4.new(
        self.vector3.X * other.vector3.X,
        self.vector3.Y * other.vector3.Y,
        self.vector3.Z * other.vector3.Z,
        self.w * other.w
    )
end

function Vector4:__div(other:Vector4): Vector4
    return Vector4.new(
        self.vector3.X / other.vector3.X,
        self.vector3.Y / other.vector3.Y,
        self.vector3.Z / other.vector3.Z,
        self.w / other.w
    )
end