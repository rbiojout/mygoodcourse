import { combineReducers } from 'redux'
import topics from './topics'
import countries from './countries'

const clientApp = combineReducers({
    topics,
    countries
})

export default clientApp