import "./App.css"
import ProfileCard from "./components/ProfileCard"

function App() {
  return (
    <div className='app'>
      <ProfileCard
        name='Gustav'
        jobTitle='Creative Director'
        company='Sandfall Interactive'
        bio='For Those Who Come After, Right?'
        skills={["Concept", "Direction", "Leadership"]}
        imageUrl='/pfp1.PNG'
      />

      <ProfileCard
        name='Maelle'
        jobTitle='Lead Environment Artist'
        company='Expedition 33'
        bio='I have had Enough condolences.'
        skills={["World-building", "Storytelling ", "Texturing"]}
        imageUrl='/pfp1.PNG'
      />

      <ProfileCard
        name='Lune'
        jobTitle='Lead Writer'
        company='Kepler Interactive'
        bio='Not IF, When One Falls. We, continue.'
        skills={["Narrative", "Dialogue", "Scriptwriting"]}
        imageUrl='/pfp1.PNG'
      />
    </div>
  )
}

export default App
