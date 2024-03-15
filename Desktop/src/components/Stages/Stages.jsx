import { useState } from 'react'
/* mocks */
import { stages as bioStages} from '../../mocks/stages.json'

/* style */
import './Stages.css'

const Stages = () => {

    const [ stages ] = useState(bioStages)

    return (

        <div className='container-stages'>
            {
                stages.map((step, index) => (
                    <div className='item-stages' key={index}>{step.name}</div>
            ))}
        </div>

    )
}

export default Stages