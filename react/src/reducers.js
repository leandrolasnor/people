import { combineReducers } from 'redux'
import people from './people/reducer'
import {reducer as toastr} from 'react-redux-toastr'

const rootReducer = combineReducers({
  people,
  toastr
})

export default rootReducer
