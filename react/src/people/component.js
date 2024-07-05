import { Grid } from 'rsuite'
import Searcher from './searcher.js'
import List from './list.js'
import Paginate from './paginate.js'
import Filter from './filter.js'

const People = () => {

  return (
    <Grid fluid>
      <Filter />
      <Searcher />
      <hr></hr>
      <Paginate />
      <List />
    </Grid>
  )
}

export default People
