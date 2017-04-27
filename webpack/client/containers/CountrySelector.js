import { connect } from 'react-redux'
import CountryList from '../components/CountryList'
import { setCountry } from '../actions/countries';
import { fetchTopics, fetchTopArticles } from '../actions/topics';

const mapStateToProps = (state) => {
    return {
        countries: state.countries.countries,
        current_country: state.countries.current_country
    }
}

const mapDispatchToProps = (dispatch, ownProps) => {
    return {
        onCountryClick: (country_id) => {
            dispatch(setCountry(country_id));
            dispatch(fetchTopics());
            dispatch(fetchTopArticles(country_id));
        }
    }
}

const CountrySelector = connect(
    mapStateToProps,
    mapDispatchToProps
)(CountryList)

export default CountrySelector