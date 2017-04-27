import {
    FETCH_COUNTRIES,
    FETCH_COUNTRY,
} from 'shared/constants/actions';


const INITIAL_STATE = {
    countries: [],
    loading: false,
    limit: 20,
    page: 1,
    total: 0,
    country: { name: '', publishedAt: '' },
    errorMessage: ''
};

export default function (state = INITIAL_STATE, action) {
    switch (action.type) {
        case FETCH_COUNTRIES.REQUEST:
            return { ...state, loading: true };

        case FETCH_COUNTRIES.SUCCESS:
            return {
                ...state,
                posts: action.payload.posts,
                limit: action.payload.limit,
                page: action.payload.page,
                total: action.payload.total
            };

        case FETCH_COUNTRY.SUCCESS:
            return {...state, post: action.payload.post, errorMessage: '' };


        case FETCH_COUNTRIES.FAILURE:
            return { ...state, loading: false };

        case FETCH_COUNTRY.FAILURE:
            return { ...state, errorMessage: action.payload.errorMessage };

        default:
            return state;
    }
}

