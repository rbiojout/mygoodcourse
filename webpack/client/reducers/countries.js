import { FETCH_COUNTRIES, SET_COUNTRY } from '../constants/actions';



const initialState = {
    loading: false,
    errorMessage: '',
}


export default function countries(state = initialState, action) {
    switch (action.type) {

        case FETCH_COUNTRIES.REQUEST:
            return { ...state, loading: true };

        case FETCH_COUNTRIES.SUCCESS:
            return { ...state, countries: action.payload.countries, loading: false };


        case FETCH_COUNTRIES.FAILURE:
            return { ...state, loading: false };


        case SET_COUNTRY:
            return Object.assign({}, state, {
                current_country: action.payload.current_country
            })

        default:
            return state;
    }
}
