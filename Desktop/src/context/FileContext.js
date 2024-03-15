import { createContext } from 'react'

export const FilesContext = createContext();


export function FilesContext ({ children }) {

    return (
        <FilesContext.Provider value={{
            
        }} />
    )

}