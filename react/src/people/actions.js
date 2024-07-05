import axios from 'axios'
import handle_errors from '../handle_errors'
import { toastr } from 'react-redux-toastr'

const qs = require('qs');
const _ = require('lodash')

export const detach = (id) => {
  return () => {
    axios.delete(`/v1/people/${id}/detach`,).catch(e => handle_errors(e))
  }
}

export const download_pdf = (query, filter) => {
  return dispatch => {
    axios.get(`/v1/people/download_pdf`, {
      params: { query: query, filter: filter },
      paramsSerializer: params => qs.stringify(params, { arrayFormat: 'brackets' }),
      responseType: 'blob'
    }).then((response) => {
      if (response.data.size) {
        const href = URL.createObjectURL(response.data);
        const link = document.createElement('a')
        link.href = href;
        link.setAttribute('download', 'people.pdf')
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(href)
        dispatch({ type: "PEOPLE_REPORT_DOWNLOADED", payload: "people.pdf" })
      } else {
        toastr.info('People Report', "PDF Building ...")
      }
    }).catch(e => handle_errors(e))
  }
}

export const download_csv = (query, filter) => {
  return dispatch => {
    axios.get(`/v1/people/download_csv`, {
      params: { query: query, filter: filter },
      paramsSerializer: params => qs.stringify(params, { arrayFormat: 'brackets' }),
      responseType: 'blob'
    }).then((response) => {
      if (response.data.size) {
        const href = URL.createObjectURL(response.data);
        const link = document.createElement('a')
        link.href = href;
        link.setAttribute('download', 'people.csv')
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(href)
        dispatch({ type: "PEOPLE_REPORT_DOWNLOADED", payload: "people.csv" })
      } else {
        toastr.info('People Report', "CSV Building ...")
      }

    }).catch(e => handle_errors(e))
  }
}

export const search = (query, pagination, filter) => {
  return dispatch => {
    axios.get('/v1/people/search', {
      params: { ...pagination, filter: filter, query: query },
      paramsSerializer: params => qs.stringify(params, { arrayFormat: 'brackets' }),
    }).then(resp => {
      dispatch({ type: "PEOPLE_FETCHED", payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}

export const get_person = (id) => {
  return dispatch => {
    axios.get(`/v1/people/${id}`).then(resp => {
      dispatch({ type: "PERSON_FETCHED", payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}

export const create_person = data => {
  return dispatch => {
    axios.post('/v1/people', data).then(resp => {
      dispatch({ type: 'PERSON_CREATED', payload: resp.data })
      toastr.success('New Person', _.get(resp, 'data.name', ''))
    }).catch(e => handle_errors(e))
  }
}

export const update_person = data => {
  const { id } = data
  return dispatch => {
    axios.patch(`/v1/people/${id}`, data).then(resp => {
      dispatch({ type: 'PERSON_UPDATED', payload: resp.data })
      toastr.success('Person updated!', _.get(resp, 'data.name', ''))
    }).catch(e => handle_errors(e))
  }
}

export const destroy_person = data => {
  return dispatch => {
    axios.delete(`/v1/people/${data.id}`).then(resp => {
      dispatch({ type: 'PERSON_DESTROYED', payload: resp.data })
      toastr.success('Person destroyed!', _.get(resp, 'data.name', ''))
    }).catch(e => handle_errors(e))
  }
}

export const get_genders = () => {
  return dispatch => {
    axios.get('/v1/people/genders').then(resp => {
      dispatch({ type: 'GENDERS_FETCHED', payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}

export const get_marital_statuses = () => {
  return dispatch => {
    axios.get('/v1/people/marital_statuses').then(resp => {
      dispatch({ type: 'MARITAL_STATUES_FETCHED', payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}

export const get_job_roles = () => {
  return dispatch => {
    axios.get('/v1/job_roles').then(resp => {
      dispatch({ type: 'JOB_ROLES_FETCHED', payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}

export const get_workspaces = () => {
  return dispatch => {
    axios.get('/v1/workspaces').then(resp => {
      dispatch({ type: 'WORKSPACES_FETCHED', payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}
