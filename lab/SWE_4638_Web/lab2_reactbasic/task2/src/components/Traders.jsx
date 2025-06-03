import Trader from "./Trader"

const Traders = () => {
  return (
    <section className='traders'>
      <h2>Why Traders Choose Us</h2>
      <div className='article-container'>
        <Trader
          link={"#"}
          title={"Raw Spreads"}
          desc={
            "Receive premium pricing from Top Tier financial institutions. Pricing from Top Tier financial institutions."
          }
        />

        <Trader
          link={"#"}
          title={"No Dealing Desk"}
          desc={
            "With Consulting WP you’ll get no re-quotes, no dealer intervention and fair order execution."
          }
        />

        <Trader
          link={"#"}
          title={"State of the Art"}
          desc={
            "Trade Forex and CFDs with the world’s best trading platforms on your desktop or mobile device."
          }
        />
      </div>
    </section>
  )
}

export default Traders
