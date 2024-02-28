import './Headers.css'

const Headers = () => {

    return (
        <div className='container'>
            <input type = 'checkbox' id = 'toggle' hidden />
            <label htmlFor='toggle' className='button'  ></label>


            <nav className='nav'>
                <ul>
                    <a 
                        target='_blank'>Add Document</a>
                </ul>
            </nav>

        </div>
    );
}

export default Headers