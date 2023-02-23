--!strict
export type BloxConnection = {
    [string]: RBXScriptSignal | RBXScriptConnection
}
export type BloxConstraint = {
    ParentType: string,
    InstanceType: string,
    Children: {
        [string]: BloxConstraint
    },
    Child: BloxConstraint
}
export type BloxDefinition<FunctionsType> = {
    __constraints: BloxConstraint,
    __connections: BloxConnection|nil,
    __methods: FunctionsType
}

return nil