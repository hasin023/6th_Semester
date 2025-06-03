const Industry = ({ title, icon, description }) => {
  return (
    <>
      <div className='icon'>
        <i className={icon} aria-hidden='true'></i>
      </div>
      <article>
        <header>
          <h2>{title}</h2>
        </header>
        <p>{description}</p>
      </article>
    </>
  )
}

export default Industry
