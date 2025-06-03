const Trader = ({ link, title, desc }) => {
  return (
    <a href={link}>
      <h4>{title}</h4>
      <p>{desc}</p>
    </a>
  )
}

export default Trader
