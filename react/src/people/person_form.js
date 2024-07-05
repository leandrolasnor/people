import { useRef, useState, forwardRef, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Modal, Button, Schema, Form, InputPicker, Input, DatePicker, Tag, Uploader, Row, Col, Grid, IconButton, VisuallyHidden } from 'rsuite'
import Plus from '@rsuite/icons/Plus';
import { create_person, detach, get_genders, get_marital_statuses, get_workspaces, get_job_roles, update_person } from './actions.js'
import styled from 'styled-components'

const _ = require('lodash')

const TextField = forwardRef((props, ref) => {
  const { name, label, accepter, ...rest } = props;
  return (
    <Form.Group ref={ref}>
      <Form.ControlLabel>{label} </Form.ControlLabel>
      <Form.Control name={name} accepter={accepter} {...rest} />
    </Form.Group>
  )
})

const StyledInput = styled(Input)`
    min-width: 100%;
    max-width: 100%;
  `

const PersonForm = props => {
  const dispatch = useDispatch()
  const { genders, marital_statuses, workspaces, job_roles, person } = useSelector(state => state.people)
  const { size, open, handleClose, textButton, title } = props
  const formRef = useRef()
  const uploader = useRef()
  const [fileList, setFileList] = useState([]);
  const [formError, setFormError] = useState({})
  const [contactsIndex, setContactsIndex] = useState(_.get(person, 'contacts_attributes', []).map((_, i) => i))
  const [contactsRemoved, setContactsRemoved] = useState([0])
  const [formValue, setFormValue] = useState()
  const handleSubmit = () => submit(formValue)
  const submit = formValue => {
    var contacts_for_update_schema = Schema.Model({})
    const contacts_for_update = _.get(person, 'contacts', []).map(contact => {
      let email = `contacts_attributes[contact_${contact.id}][email]`
      let phone = `contacts_attributes[contact_${contact.id}][phone]`
      let mobile = `contacts_attributes[contact_${contact.id}][mobile]`

      contacts_for_update_schema = Schema.Model.combine(contacts_for_update_schema, Schema.Model({
        [email]: Schema.Types.StringType().isEmail('Please enter a valid email address.').isRequired('Required.'),
        [phone]: Schema.Types.StringType().containsNumber('Must contain numbers').rangeLength(8, 14, '8 to 14 numbers').isRequired('Required.'),
        [mobile]: Schema.Types.StringType().containsNumber('Must contain numbers').rangeLength(8, 14, '8 to 14 numbers').isRequired('Required.')
      }))

      let object = {
        id: formValue[`contacts_attributes[contact_${contact.id}][id]`],
        email: formValue[`contacts_attributes[contact_${contact.id}][email]`],
        phone: formValue[`contacts_attributes[contact_${contact.id}][phone]`],
        mobile: formValue[`contacts_attributes[contact_${contact.id}][mobile]`],
      }
      if (contactsRemoved.includes(`contact_${contact.id}`)) object = { ...object, _destroy: contact.id }

      return object
    })
    var contacts_for_insert_schema = Schema.Model({})
    const contacts_for_insert = contactsIndex.filter(i => !contactsRemoved.includes(i)).map(i => {
      let email = `contacts_attributes[${i}][email]`
      let phone = `contacts_attributes[${i}][phone]`
      let mobile = `contacts_attributes[${i}][mobile]`
      contacts_for_insert_schema = Schema.Model.combine(contacts_for_insert_schema, Schema.Model({
        [email]: Schema.Types.StringType().isEmail('Please enter a valid email address.').isRequired('Required.'),
        [phone]: Schema.Types.StringType().containsNumber('Must contain numbers').rangeLength(8, 14, '8 to 14 numbers').isRequired('Required.'),
        [mobile]: Schema.Types.StringType().containsNumber('Must contain numbers').rangeLength(8, 14, '8 to 14 numbers').isRequired('Required.')
      }))

      return {
        email: formValue[`contacts_attributes[${i}][email]`],
        phone: formValue[`contacts_attributes[${i}][phone]`],
        mobile: formValue[`contacts_attributes[${i}][mobile]`]
      }
    })

    const normal_form_value_schema = Schema.Model({
      name: Schema.Types.StringType().isRequired('This field is required.'),
      registration: Schema.Types.StringType().isRequired('This field is required.'),
      job_role_id: Schema.Types.NumberType().isRequired('This field is required.'),
      workspace_id: Schema.Types.NumberType().isRequired('This field is required.')
    })

    const schema = Schema.Model.combine(contacts_for_update_schema, contacts_for_insert_schema, normal_form_value_schema)
    const checking = schema.check(formValue)
    setFormError(checking)

    const data = {
      name: formValue.name,
      registration: formValue.registration,
      contacts_attributes: [...contacts_for_update, ...contacts_for_insert],
      marital_status: formValue.marital_status,
      date_birth: formValue.date_birth?.toISOString().split('T')[0],
      gender: formValue.gender,
      city_birth: formValue.city_birth,
      state_birth: formValue.state_birth,
      job_role_id: formValue.job_role_id,
      workspace_id: formValue.workspace_id
    }

    const errors = Object.values(checking).filter(field => field.hasError)
    if (_.isEmpty(errors)) _.get(person, 'id', false) ? dispatch([update_person({ id: person.id, ...data }), uploader.current.start(), close()]) : dispatch([create_person(data), close()])
  }

  const formData = () => {
    let contacts = {}
    _.get(person, 'contacts', []).forEach(c => {
      contacts[`contacts_attributes[contact_${c.id}][id]`] = c.id
      contacts[`contacts_attributes[contact_${c.id}][email]`] = c.email
      contacts[`contacts_attributes[contact_${c.id}][phone]`] = c.phone
      contacts[`contacts_attributes[contact_${c.id}][mobile]`] = c.mobile
    })
    return {
      name: _.get(person, 'name', ''),
      registration: _.get(person, 'registration', ''),
      date_birth: _.get(person, 'date_birth', false) ? new Date(`${person.date_birth} 00:00:00`) : new Date(),
      city_birth: _.get(person, 'city_birth', null),
      state_birth: _.get(person, 'state_birth', null),
      marital_status: _.get(person, 'marital_status', null),
      gender: _.get(person, 'gender', null),
      workspace_id: _.get(person, 'workspace.id', ''),
      job_role_id: _.get(person, 'job_role.id', ''),
      ...contacts
    }
  }

  const close = () => {
    setFormValue({})
    setFormError({})
    setContactsIndex([])
    setContactsRemoved([0])
    handleClose()
  }

  const maritalStatusesData = Object.entries(marital_statuses).map(([k, v]) => ({
    label: <Tag size='sm'>{v}</Tag>,
    value: v
  }))
  const gendersData = Object.entries(genders).map(([k, v]) => ({
    label: <Tag size='sm'>{v}</Tag>,
    value: v
  }))
  const workspacesData = workspaces.map((workspace) => ({
    label: <Tag size='sm'>{workspace.title}</Tag>,
    value: workspace.id
  }))
  const jobRolesData = job_roles.map((job_role) => ({
    label: <Tag size='sm'>{job_role.title}</Tag>,
    value: job_role.id
  }))

  const addContact = () => setContactsIndex([...contactsIndex, contactsIndex.length + 1])
  const removeContact = i => setContactsRemoved([...contactsRemoved, i])

  useEffect(() => { if (genders?.length === 0) dispatch(get_genders()) }, [])
  useEffect(() => { if (marital_statuses?.length === 0) dispatch(get_marital_statuses()) }, [])
  useEffect(() => { if (job_roles?.length === 0) dispatch(get_job_roles()) }, [])
  useEffect(() => { if (workspaces?.length === 0) dispatch(get_workspaces()) }, [])
  useEffect(() => {
    setFormValue(formData())
    setFileList(_.get(person, 'docs', []).map(doc => ({ name: doc.filename, id: doc.id })))
  }, [person])

  return (
    <Form
      layout="vertical"
      ref={formRef}
      formError={formError}
      onChange={setFormValue}
      formValue={formValue}
    >
      <Modal autoFocus size={size} open={open} onClose={close}>
        <Modal.Header>
          <Modal.Title>{title}</Modal.Title>
        </Modal.Header>
        <Modal.Body style={{ '-ms-overflow-style': "none", "scrollbar-width": "none" }}>
          <Grid fluid>
            <Row className="show-grid">
              <Col md={8}><TextField accepter={StyledInput} autoFocus name='registration' label="Registration" /></Col>
              <Col md={8}><TextField accepter={StyledInput} name='name' label="Name" /></Col>
              <Col md={8}><TextField name='date_birth' label="Date Birth" accepter={DatePicker} format="dd/MM/yyyy" oneTap={true} value={_.get(formValue, 'date_birth', new Date())} /></Col>
            </Row>
            <Row className="show-grid mt-4">
              <Col md={6}><TextField accepter={StyledInput} name='city_birth' label="City Birth" /></Col>
              <Col md={6}><TextField accepter={StyledInput} name='state_birth' label="State Birth" /></Col>
              <Col md={6}><TextField name='marital_status' label="Marital Status" accepter={InputPicker} data={maritalStatusesData} /></Col>
              <Col md={6}><TextField name='gender' label="Gender" accepter={InputPicker} data={gendersData} /></Col>
            </Row>
            <Row className="show-grid mt-4">
              <Col md={8}><TextField name='workspace_id' label="Workspace" accepter={InputPicker} data={workspacesData} /></Col>
              <Col md={8}><TextField name='job_role_id' label="Job Role" accepter={InputPicker} data={jobRolesData} /></Col>
            </Row>
            <hr></hr>
            {_.get(person, 'id', false) &&
              <Row className="show-grid mt-4">
                <Col md={24}>
                  <Uploader
                    multiple
                    fileList={fileList}
                    autoUpload={false}
                    accept={'application/pdf'}
                    draggable={true}
                    onChange={setFileList}
                    onRemove={attach => dispatch(detach(attach.id))}
                    action={`http://localhost:3000/v1/people/${person.id}/attach`}
                    ref={uploader}
                  >
                    <div style={{ height: 50, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                      <span>Click or Drag files to this area to upload</span>
                    </div>
                  </Uploader>
                </Col>
              </Row>
            }
            {
              _.get(person, 'contacts', []).map((contact) => (
                <>
                  <hr></hr>
                  <Row key={`contact_${contact.id}`} className="show-grid mt-0">
                    <VisuallyHidden type='hidden' value={contact.id} name={`contacts_attributes[contact_${contact.id}][id]`} />
                    <Col md={7}>
                      <TextField size="sm" accepter={StyledInput} disabled={contactsRemoved.includes(`contact_${contact.id}`)} placeholder={contact.phone} name={`contacts_attributes[contact_${contact.id}][phone]`} label="Phone" />
                    </Col>
                    <Col md={7}>
                      <TextField size="sm" accepter={StyledInput} disabled={contactsRemoved.includes(`contact_${contact.id}`)} placeholder={contact.mobile} name={`contacts_attributes[contact_${contact.id}][mobile]`} label="Mobile" />
                    </Col>
                    <Col md={7}>
                      <TextField size="sm" accepter={StyledInput} disabled={contactsRemoved.includes(`contact_${contact.id}`)} placeholder={contact.email} name={`contacts_attributes[contact_${contact.id}][email]`} label="Email" />
                    </Col>
                    <Col md={3}>
                      {!contactsRemoved.includes(`contact_${contact.id}`) && <Button color="red" appearance="ghost" size="xs" onClick={() => removeContact(`contact_${contact.id}`)}>X</Button>}
                      {contactsRemoved.includes(`contact_${contact.id}`) && <Button color="yellow" appearance="ghost" size="xs" onClick={() => setContactsRemoved([...contactsRemoved.filter(i => i !== `contact_${contact.id}`)])}>Undo</Button>}
                    </Col>
                  </Row>
                </>
              )
              )
            }
            {
              contactsIndex.filter(i => !contactsRemoved.includes(i)).map(i => (
                <Row key={`row-${i}`} className="show-grid mt-1">
                  <Col md={7}>
                    <TextField size="sm" accepter={StyledInput} name={`contacts_attributes[${i}][phone]`} label="Phone" />
                  </Col>
                  <Col md={7}>
                    <TextField size="sm" accepter={StyledInput} name={`contacts_attributes[${i}][mobile]`} label="Mobile" />
                  </Col>
                  <Col md={7}>
                    <TextField size="sm" accepter={StyledInput} name={`contacts_attributes[${i}][email]`} label="Email" />
                  </Col>
                  <Col md={3}>
                    <Button color="red" appearance="ghost" size="xs" onClick={() => removeContact(i)}>X</Button>
                  </Col>
                </Row>
              ))
            }
            <Row className="show-grid mt-4">
              <Col md={24}>
                <IconButton size='xs' onClick={addContact} appearance="primary" color="blue" icon={<Plus />}>contacts</IconButton>
              </Col>
            </Row>
          </Grid>
        </Modal.Body>
        <Modal.Footer className='mt-3'>
          <Button onClick={close} appearance="subtle">Cancel</Button>
          <Button onClick={handleSubmit} appearance='primary'>{textButton || 'Ok'}</Button>
        </Modal.Footer>
      </Modal>
    </Form>
  )
}

export default PersonForm
