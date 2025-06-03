const ProfileCard = ({ name, jobTitle, company, bio, skills, imageUrl }) => {
  return (
    <div className='profile-card'>
      <div className='profile-header'>
        <h2 className='profile-name'>{name}</h2>
        <span className='job-title-badge'>{jobTitle}</span>
        <p className='company-name'>{company}</p>
      </div>

      <div className='profile-bio'>
        <p>{bio}</p>
      </div>

      <div className='profile-skills'>
        {Array.isArray(skills) && skills.length > 0 ? (
          skills.map((skill, index) => (
            <span key={index} className='skill-tag'>
              {skill}
            </span>
          ))
        ) : (
          <span className='no-skills'>No skills</span>
        )}
      </div>

      <div className='profile-avatar'>
        <img src={imageUrl || "/pfp1.PNG"} alt={`${name} avatar`} />
      </div>

      <div className='profile-actions'>
        <button
          onClick={() => {
            console.log("Contacting the user")
          }}
          className='contact-btn'
        >
          CONTACT
        </button>
      </div>
    </div>
  )
}

export default ProfileCard
