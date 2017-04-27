// common

const REQUEST = 'REQUEST';
const SUCCESS = 'SUCCESS';
const FAILURE = 'FAILURE';

function createRequestTypes(base) {
  const requestType = {};
  [REQUEST, SUCCESS, FAILURE].forEach(type => {
    requestType[type] = `${base}_${type}`;
  });
  return requestType;
}

export const SIGN_OUT = createRequestTypes('SIGN_OUT');
export const AUTH = createRequestTypes('AUTH');

export const FETCH_COUNTRIES = createRequestTypes('FETCH_COUNTRIES');
export const FETCH_COUNTRY = createRequestTypes('FETCH_COUNTRY');


export const FETCH_TOPICS = createRequestTypes('FETCH_TOPICS');
export const FETCH_TOPIC = createRequestTypes('FETCH_TOPIC');
export const FETCH_ARTICLES = createRequestTypes('FETCH_ARTICLES');
export const FETCH_ARTICLE = createRequestTypes('FETCH_ARTICLE');

export const FETCH_ALL_TOPICS = 'FETCH_ALL_TOPICS';

export const CREATE_ERROR = 'CREATE_ERROR';
export const DELETE_ERROR = 'DELETE_ERROR';
