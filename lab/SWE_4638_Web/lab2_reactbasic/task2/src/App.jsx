import FooterSection from "./components/common/FooterSection"
import Navbar from "./components/common/Navbar"
import Entrepreneurs from "./components/Entrepreneurs"
import HeroSection from "./components/hero"
import Industries from "./components/Industries"
import Partners from "./components/Partners"
import Traders from "./components/Traders"

function App() {
  return (
    <>
      <header className='header-bg'>
        <Navbar />
        <HeroSection />
      </header>

      <main>
        <Industries />
        <Entrepreneurs />
        <Traders />
        <Partners />
      </main>

      <FooterSection />
    </>
  )
}

export default App
