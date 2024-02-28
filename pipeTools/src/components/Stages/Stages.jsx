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
                    <h1 key={index}>{step.name}</h1>
            ))}
        </div>

    )
}

export default Stages