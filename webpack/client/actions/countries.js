import axios from '../utilities';
/*
 * action types
 */

import {FETCH_COUNTRIES, SET_COUNTRY} from '../constants/actions'


/*
 * action creators
 */

function fetchCountriesSuccess( data ) {
    return {
        type: FETCH_COUNTRIES.SUCCESS,
        payload: {
            countries: data['countries'],
        },
    };
}

export function fetchCountries() {
    let url = 'countries?format=json';

    const request = axios.get(url);
    return dispatch => {
        return (
            request
                .then(response => dispatch(fetchCountriesSuccess(response.data)))
                .catch(error => {
                    console.log('error :'+error)
                    //dispatch(fetchPostsFailure());
                    //dispatch(createError(error));
                })
        );
    };
}

function setCountrySuccess( data ) {
    return {
        type: SET_COUNTRY,
        payload: {
            current_country: data['country'],
        },
    };
}

export function setCountry(country_id) {
    let url = 'countries/'+country_id+'?country_id='+country_id+'&format=json';

    const request = axios.get(url);
    return dispatch => {
        return (
            request
                .then(response => dispatch(setCountrySuccess(response.data)))
                .catch(error => {
                    console.log('error :'+error)
                    //dispatch(fetchPostsFailure());
                    //dispatch(createError(error));
                })
        );
    };
}