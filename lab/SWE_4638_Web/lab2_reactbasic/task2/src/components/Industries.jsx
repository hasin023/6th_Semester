import Industry from "./Industry"

const Industries = () => {
  return (
    <>
      <header>
        <h2>Industries</h2>
      </header>
      <section className='travel-business-customer'>
        <Industry
          title={"Travel and Aviation Consulting"}
          icon={"fa fa-plane"}
          description={
            "We are a company that offers design and build services for you from initial sketches to the final construction."
          }
        />

        <Industry
          title={"Business Services Consulting"}
          icon={"fa fa-line-chart"}
          description={
            "The sector is diverse, including professional services, education and training, and support services and outsourcing."
          }
        />

        <Industry
          title={"Consumer Products Consulting"}
          icon={"fa fa-shopping-cart"}
          description={
            "We are a company that offers design and build services for you from initial sketches to the final construction."
          }
        />

        <Industry
          title={"Financial Services Consulting"}
          icon={"fa fa-university"}
          description={
            "We are a company that offers design and build services for you from initial sketches to the final construction."
          }
        />

        <Industry
          title={"Energy and Environment Consulting"}
          icon={"fa fa-lightbulb-o"}
          description={
            "We are a company that offers design and build services for you from initial sketches to the final construction."
          }
        />

        <Industry
          title={"Surface Transport & Logistics Consulting"}
          icon={"fa fa-truck"}
          description={
            "We are a company that offers design and build services for you from initial sketches to the final construction."
          }
        />
      </section>
    </>
  )
}

export default Industries
