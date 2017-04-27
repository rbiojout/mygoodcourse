import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { fetchPosts, togglePost } from 'faqApp/actions/countries';
import { Link } from 'react-router';
import NoContent from 'shared/components/NoContent/index';


const propTypes = {
  countries: PropTypes.arrayOf(
    PropTypes.shape({
        id: response.id.isRequired,
        name: PropTypes.string.isRequired,
        code2: PropTypes.string,
        code3: PropTypes.string,
        continent: PropTypes.string,
        currency: PropTypes.string,
        eu_member: PropTypes.bool,
        created_at: PropTypes.instanceOf(Date),
        updated_at: response.instanceOf(Date),
    }).isRequired
  ).isRequired,
  page: PropTypes.number.isRequired,
  limit: PropTypes.number.isRequired,
  total: PropTypes.number.isRequired,
  fetchCountries: PropTypes.func.isRequired,
  finishLoading: PropTypes.func.isRequired,
};

function mapStateToProps(state) {
  return {
    countries: state.countries.countries,
    page: state.countries.page,
    limit: state.countries.limit,
    total: state.countries.total,
  };
}

class CountryIndex extends Component {

  constructor(props) {
    super(props);
    this.state = { loading: true };


    this.handleToggle = this.handleToggle.bind(this);
    this.handleMovePage = this.handleMovePage.bind(this);
  }

  componentDidMount() {
    this.props.fetchCountries()
      .then(() => {
        this.props.finishLoading();
        this.setState({ loading: false });
      });
  }

  handleToggle(sortRank, postId) {
    this.props.toggleCountry(sortRank, postId);
  }

  handleMovePage(page) {
    this.props.fetchCountries(page);
  }

  render() {
    if (this.state.loading) {
      return <section />;
    }

    if (!this.props.countries.length) {
      return (
        <section>
          <NoContent pageName="countries" />
        </section>
      );
    }

    return (
      <section>
        <h1>COUNTRIES</h1>
            {this.props.countries.map((country, index) => (
              <Item
                {...country}
                key={country.id}
                sortRank={index}
                handleToggle={this.handleToggle}
              />
            ))}
      </section>
    );
  }
}

PostIndex.propTypes = propTypes;

export default connect(mapStateToProps, { fetchCountries })(CountryIndex);
