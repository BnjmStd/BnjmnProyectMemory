import './Headers.css'

import { TrashIcon, InfoIcon, UpdateFileIcon } from '../../Icons/Icons'

const Headers = () => {

    return (
        <>

        <div className="icon-bar">
            <a className="active" > <UpdateFileIcon /> </a>
            <a > <TrashIcon/> </a>
            <a > <InfoIcon/> </a>
        </div>
        
        </>
        )
}

export default Headers