--!strict
export type IEqual<T> = {
    __eq: (T, any) -> boolean
}

return nil