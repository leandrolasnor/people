import { toastr } from 'react-redux-toastr'

var _ = require('lodash')

const handle_error_object = (key,errors) => {
  for (const [k, v] of Object.entries(errors)) {
    if (Array.isArray(v)) {
      toastr.error(`${key} > ${k}`, v.join('\n'))
    } else {
      handle_error_object(`${key} > ${k}`, v)
    }
  }
}

const handle_errors = e => {
  if (_.get(e, 'response.data', false)) {
    for (const [key, value] of Object.entries(e.response.data)) {
      if(Array.isArray(value)){
        toastr.error(key, value.join('\n'))
      }else{
        handle_error_object(key, value)
      }
    }
  } else if (_.get(e, 'response', false)) {
    toastr.error(String(e.response.status), e.response.statusText)
  } else if (_.get(e, 'message', false) === 'Network Error') {
    toastr.error('API', e.message)
  } else {
    toastr.error('Error', _.get(e, 'message', 'unknown error'))
  }
}

export default handle_errors
