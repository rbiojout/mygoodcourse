import { FETCH_COUNTRIES, FETCH_COUNTRY } from 'shared/constants/actions';
import { COUNTRY_PATH } from 'shared/constants/apis';


function fetchCountriessRequest() {
    return {
        type: FETCH_COUNTRIES.REQUEST,
    };
}
function fetchCountriesSuccess({ posts, meta }) {
    return {
        type: FETCH_COUNTRIES.SUCCESS,
        payload: {
            countries,
            total: meta.pagination.total,
            page: meta.pagination.page,
            limit: meta.pagination.limit,
        },
    };
}

function fetchCountriesFailure() {
    return {
        type: FETCH_COUNTRIES.FAILURE,
    };
}

export function fetchCountries(params = { page: 1 }) {
    let url = `${COUNTRY_PATH}?page=${params.page}`;

    if (params.tagId) {
        url += `&tag-id=${params.tagId}`;
    }

    const request = axios.get(url);
    return dispatch => {
        if (params.page === 1) {
            dispatch(fetchCountriessRequest());
        }
        return (
            request
                .then(response => dispatch(fetchCountriesSuccess(response.data)))
                .catch(error => {
                    dispatch(fetchCountriesFailure());
                    dispatch(createError(error));
                })
        );
    };
}

function fetchCountrySuccess(response) {
    return {
        type: FETCH_COUNTRY.SUCCESS,
        payload: {
            country: {
                id: response.id,
                name: response.name,
                code2: response.code2,
                code3: response.code3,
                continent: response.prevTitle,
                currency: response.currency,
                eu_member: response.eu_member,
                created_at: response.created_at,
                updated_at: response.updated_at,
            },
        },
    };
}

export function fetchPost(path) {
    const request = axios.get(`${COUNTRY_PATH}/${path}`);
    return dispatch => {
        return request
            .then(response => dispatch(fetchCountrySuccess(response.data)))
            .catch(() => browserHistory.push('/not-found'));
    };
}