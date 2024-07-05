import { useState } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { IconButton, Accordion, Tag, Col, Row, InputPicker, Stack } from 'rsuite'
import Funnel from '@rsuite/icons/Funnel'
import { FaAngleDoubleDown } from 'react-icons/fa';

const Filter = () => {
  const { genders, job_roles, workspaces, search: { filter } } = useSelector(state => state.people)
  const dispatch = useDispatch()

  const [activeKey, setActiveKey] = useState(0)
  const [genderFilter, setGenderFilter] = useState(false)
  const [jobRoleFilter, setJobRoleFilter] = useState(false)
  const [workspaceFilter, setWorkspaceFilter] = useState(false)

  const handleGenderFilter = value => setGenderFilter(value)
  const handleJobRoleFilter = value => setJobRoleFilter(value)
  const handleWorkspaceFilter = value => setWorkspaceFilter(value)

  const gendersData = Object.entries(genders).map(([k, v]) => ({
    label: <Tag size='sm'>{v}</Tag>,
    value: v
  }))
  const jobRolesData = job_roles.map((job_role) => ({
    label: <Tag size='sm'>{job_role.title}</Tag>,
    value: job_role.title
  }))
  const workspacesData = workspaces.map((workspace) => ({
    label: <Tag size='sm'>{workspace.title}</Tag>,
    value: workspace.title
  }))

  const applyFilter = () => {
    let filter = []
    if (genderFilter) filter.push(`gender = '${genderFilter}'`)
    if (jobRoleFilter) filter.push(`job_role = '${jobRoleFilter}'`)
    if (workspaceFilter) filter.push(`workspace = '${workspaceFilter}'`)
    dispatch({ type: 'SET_PEOPLE_FILTER', payload: filter })
  }

  const handleAccordionSelect = (key, event) => {
    setActiveKey(key)
    if (event.currentTarget.ariaExpanded === 'true') {
      setGenderFilter(false)
      setJobRoleFilter(false)
      setWorkspaceFilter(false)
      if (filter.length) dispatch({ type: 'CLEAR_PEOPLE_FILTER' })
    }
  }

  return (
    <Row className='mt-3'>
      <Accordion activeKey={activeKey} bordered onSelect={handleAccordionSelect}>
        <Accordion.Panel eventKey={1} header="Filter" caretAs={FaAngleDoubleDown} >
          <Row className='mt-2'>
            <Col md={4}>
              <InputPicker placeholder="Gender" key='gender' value={genderFilter} autoFocus data={gendersData} onChange={handleGenderFilter} />
            </Col >
            <Col md={4}>
              <InputPicker placeholder="Job Role" key='job_role' value={jobRoleFilter} data={jobRolesData} onChange={handleJobRoleFilter} />
            </Col>
            <Col md={4}>
              <InputPicker placeholder="Workspace" id='workspace' key='workspace' value={workspaceFilter} data={workspacesData} onChange={handleWorkspaceFilter} />
            </Col>
            <Col md={12}>
              <Stack justifyContent="flex-end"><IconButton onClick={applyFilter} icon={<Funnel />}>Apply</IconButton></Stack>
            </Col>
          </Row>
        </Accordion.Panel>
      </Accordion>
    </Row>
  )
}

export default Filter
