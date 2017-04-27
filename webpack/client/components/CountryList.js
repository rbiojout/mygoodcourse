var React = require('react');
import PropTypes from 'prop-types'


class CountryList extends React.Component {
    constructor(props) {
        super(props);
        this.handleChange = this.handleChange.bind(this);
        this.onCountryClick = this.props.onCountryClick.bind(this);
    };//constructor


    handleChange(e,country) {
        this.props.onCountryChange(e,country);
    }//handleChange

    render() {
        var country_list = this.props.countries.map(function(country, index) {
            if(this.props.current_country.id != country.id) {
                return(
                    <li key={country.id} value={country} onClick={() => this.onCountryClick(country.id)}>
                        <a href="#" value={country}  ref={country.id}><i className={"famfamfam-flag-"+country.code2} ></i> {country.name}</a>
                    </li>
            ); //return
            }
        }.bind(this)) //country_list

        return (
            <div className="btn-group margined-vertical" style={{width: '100%'}}>
                <a className="btn btn-primary" style={{width: '85%'}} href="#"><i className={"famfamfam-flag-"+this.props.current_country.code2}></i> {this.props.current_country.name }</a>
                <a className="btn btn-primary dropdown-toggle" style={{width: '15%'}} data-toggle="dropdown" href="#"><span className="caret"></span></a>
                <ul className="dropdown-menu" style={{width: '100%'}}>
                    {country_list}
                </ul>
            </div>
        )
    }//render
}//CountryList


CountryList.propTypes = {
    onCountryClick: PropTypes.func.isRequired
}

// Specifies the default values for props:
CountryList.defaultProps = {
    countries: [],
    current_country: {code2: 'fr', name: 'France'}
};

module.exports = CountryList;