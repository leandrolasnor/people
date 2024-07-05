import { useEffect, useRef, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Input, InputGroup, IconButton, Row, Col } from 'rsuite'
import PersonForm from './person_form.js'
import SearchIcon from '@rsuite/icons/Search'
import PlusIcon from '@rsuite/icons/Plus'

const Searcher = () => {
  const { search: { query } } = useSelector(state => state.people)
  const searchRef = useRef(null)
  const dispatch = useDispatch()
  const [openCreatePersonForm, setOpenCreatePersonForm] = useState(false)
  const keyDownSearchHandler = event => {
    if (event.key === 'Escape') {
      event.preventDefault()
      searchRef.current.value = ''
    } else if (event.key === 'Enter') {
      event.preventDefault()
      dispatch({ type: 'QUERY_CHANGED', payload: searchRef.current.value })
    }
  }

  const CustomInputGroupWidthButton = ({ placeholder, ...props }) => (
    <InputGroup {...props} inside>
      <Input placeholder={placeholder} autoFocus onKeyDown={keyDownSearchHandler} ref={searchRef} />
      <InputGroup.Button onClick={() => dispatch({ type: 'QUERY_CHANGED', payload: searchRef.current.value })}>
        <SearchIcon />
      </InputGroup.Button>
    </InputGroup>
  )

  useEffect(() => { searchRef.current.value = query })
  return (
    <Row className='mt-3'>
      <Col xs={22}>
        <CustomInputGroupWidthButton size="md" placeholder="Search" />
      </Col>
      <Col xs={2}>
        <IconButton onClick={() => setOpenCreatePersonForm(true)} icon={<PlusIcon />}>Person</IconButton>
      </Col>
      <PersonForm size='lg' open={openCreatePersonForm} textButton='Save' title='New Person' handleClose={() => setOpenCreatePersonForm(false)} />
    </Row>
  )
}

export default Searcher
