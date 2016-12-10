export default class app {
  render() {
    // indent after return
    return (
      <div>
      </div>
    )
  }
  render() {
    // indent after return
    return <div></div>
  }
  render() {
    //nested
    return (
      <div>
        <span>
        </span>
      </div>
    )
  }
  render() {
    // do block
    return (
      <div>
      {do{
        if (x == 3) {
          console.log('bar')
        }
      }}
      </div>
    )
  }
}
