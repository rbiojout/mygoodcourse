import { combineReducers } from 'redux';
import countries from 'faqApp/reducers/countries';
import topics from 'faqApp/reducers/topics';
import error from 'shared/reducers/errors';

const rootReducer = combineReducers({
  countries,
  topics,
  error,
});

export default rootReducer;

