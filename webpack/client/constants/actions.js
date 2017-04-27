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


// countries
export const FETCH_COUNTRIES = createRequestTypes('FETCH_COUNTRIES');

export const SET_COUNTRY = 'SET_COUNTRY';

// topics
export const FETCH_TOPICS = createRequestTypes('FETCH_TOPICS');


export const FETCH_TOPIC = 'FETCH_TOPIC';
export const FETCH_TOPARTICLES = createRequestTypes('FETCH_TOPARTICLES');

