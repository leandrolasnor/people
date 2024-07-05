const INITIAL_STATE = {
  report_built: null,
  genders: [],
  marital_statuses: [],
  workspaces: [],
  job_roles: [],
  person: {},
  search: {
    filter: [],
    hits: [],
    query: '',
    totalHits: 0
  }
}

var reducer = (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case 'PEOPLE_REPORT_DOWNLOADED':
      return {
        ...state,
        report_built: null
      }
    case 'PEOPLE_REPORT_BUILT':
      return {
        ...state,
        report_built: action.payload
      }
    case 'SET_PEOPLE_FILTER':
      return {
        ...state,
        search: {
          ...state.search,
          filter: action.payload
        }
      }
    case 'CLEAR_PEOPLE_FILTER':
      return {
        ...state,
        search: {
          ...state.search,
          filter: []
        }
      }
    case 'CLEAR_PERSON':
      return {
        ...state,
        person: {}
      }
    case 'PERSON_FETCHED':
      return {
        ...state,
        person: action.payload
      }
    case 'GENDERS_FETCHED':
      return {
        ...state,
        genders: action.payload
      }
    case 'MARITAL_STATUES_FETCHED':
      return {
        ...state,
        marital_statuses: action.payload
      }
    case 'WORKSPACES_FETCHED':
      return {
        ...state,
        workspaces: action.payload
      }
    case 'JOB_ROLES_FETCHED':
      return {
        ...state,
        job_roles: action.payload
      }
    case 'PERSON_UPDATED':
      action.payload = { ...action.payload, workspace: action.payload.workspace.title, job_role: action.payload.job_role.title }
      return {
        ...state,
        person: {},
        search: {
          ...state.search,
          hits: state.search.hits.map(hit => parseInt(hit.id) === parseInt(action.payload.id) ? action.payload : hit)
        }
      }
    case 'PERSON_DESTROYED':
      return {
        ...state,
        search: {
          ...state.search,
          hits: state.search.hits.filter(hit => parseInt(hit.id) !== parseInt(action.payload.id)),
          totalHits: state.search.totalHits - 1
        }
      }
    case 'PERSON_CREATED':
      action.payload = { ...action.payload, workspace: action.payload.workspace.title, job_role: action.payload.job_role.title }
      return {
        ...state,
        search: {
          ...state.search,
          hits: [action.payload, ...state.search.hits],
          totalHits: state.search.totalHits + 1
        }
      }
    case 'PEOPLE_FETCHED':
      return {
        ...state,
        search: { ...state.search, ...action.payload }
      }
    case 'QUERY_CHANGED':
      return {
        ...state,
        search: {
          ...state.search,
          query: action.payload
        }
      }
    default:
      return state
  }
}

export default reducer
