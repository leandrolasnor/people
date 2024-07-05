import { useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Table, Row, Col, Button, Tag } from 'rsuite'
import { Icon } from '@rsuite/icons'
import { FaTrashCan, FaFilePen, FaFilePdf, FaRegFileExcel } from 'react-icons/fa6'
import PersonForm from './person_form'
import { destroy_person, download_pdf, download_csv, get_person } from './actions'

const moment = require('moment')
const { Column, HeaderCell, Cell } = Table
const rowKey = 'id'

const List = () => {
  const dispatch = useDispatch()
  const { search: { hits, filter, query }, person, report_built } = useSelector(state => state.people)
  const formatDate = date => (moment(new Date(`${date} 00:00:00`)).format("DD/MM/YYYY"))
  useEffect(() => {
    if (report_built === 'people.pdf') dispatch(download_pdf())
    if (report_built === 'people.csv') dispatch(download_csv())
  }, [report_built])

  return (
    <Row>
      <Col xs={24} className="mt-3">
        <div style={{ position: 'relative' }}>
          <Table
            shouldUpdateScroll={false}
            autoHeight={true}
            data={hits}
            rowKey={rowKey}
            bordered={true}
            cellBordered={true}
            headerHeight={40}
          >
            <Column width={250} align='center'>
              <HeaderCell>NAME</HeaderCell>
              <Cell>{row => row.name}</Cell>
            </Column>
            <Column align='center'>
              <HeaderCell>REGISTRATION</HeaderCell>
              <Cell>{row => <Tag>{row.registration}</Tag>}</Cell>
            </Column>
            <Column align='center'>
              <HeaderCell>DATE BIRTH</HeaderCell>
              <Cell>{row => formatDate(row.date_birth)}</Cell>
            </Column>
            <Column align='center'>
              <HeaderCell>GENDER</HeaderCell>
              <Cell>{row => <Tag>{row.gender}</Tag>}</Cell>
            </Column>
            <Column flexGrow={1} align='center'>
              <HeaderCell>WORKSPACE</HeaderCell>
              <Cell>{row => row.workspace}</Cell>
            </Column>
            <Column flexGrow={1} align='center'>
              <HeaderCell>JOB ROLE</HeaderCell>
              <Cell>{row => row.job_role}</Cell>
            </Column>
            <Column align='center'>
              <HeaderCell style={{ padding: '6px' }}>
                <Button disabled={hits.length === 0} onClick={() => dispatch(download_pdf(query, filter))} appearance="link"><Icon color="red" size="4mm" as={FaFilePdf} /></Button>
                <Button disabled={hits.length === 0} onClick={() => dispatch(download_csv(query, filter))} appearance="link"><Icon color="green" size="4mm" as={FaRegFileExcel} /></Button>
              </HeaderCell>
              <Cell style={{ padding: '6px' }}>
                {
                  row => {
                    return (
                      <>
                        <Button appearance="link" onClick={() => dispatch(get_person(row.id))}><Icon color="gray" size="4mm" as={FaFilePen} /></Button>
                        <Button appearance="link" onClick={() => dispatch(destroy_person(row))}><Icon color="gray" size="4mm" as={FaTrashCan} /></Button>
                      </>
                    )
                  }
                }
              </Cell>
            </Column>
          </Table>
        </div>
      </Col>
      <PersonForm size='lg' open={Object.keys(person).length > 0} textButton='Update' title='Update Person' handleClose={() => dispatch({ type: 'CLEAR_PERSON' })} />
    </Row>
  )
}

export default List
