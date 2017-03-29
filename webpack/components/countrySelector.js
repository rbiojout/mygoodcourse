var React = require('react');

class CountrySelector extends React.Component {
    constructor(props) {
        super(props);
        this.handleChange = this.handleChange.bind(this);
        this.state = {countries: []};
    };//constructor

    componentDidMount() {
        $.getJSON('/countries.json', (response) => {
            this.setState({ countries: response});
        });

    };//componentDidMount

    handleChange(e,country) {
        this.props.onCountryChange(e,country);
    }//handleChange

    render() {
        var country_list = this.state.countries.map(function(country, index) {
            return(
                <li key={country.id} value={country} onClick={(e) => this.handleChange(e, country)}>
                    <a href="#" value={country}  ref={country.id}><i className={"famfamfam-flag-"+country.code2} ></i> {country.name}</a>
                </li>
            ); //return
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
}//CountrySelector

module.exports = CountrySelector;