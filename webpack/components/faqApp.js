var React = require('react');
var ReactDOM = require('react-dom');
var TopArticleList = require('./topArticleList');
var CountrySelector = require('./countrySelector');
var TopicList = require('./topicList');

class FaqApp extends React.Component {
    constructor(props) {
        super(props);
        this.onCountryChange = this.onCountryChange.bind(this);
        this.state = { current_country: {}, topics: [], topArticles: [] }
    };//constructor


    fetchCurrentCountry() {
        $.getJSON('/countries/'+this.props.country_id+'.json', (response) => {
            this.setState({ current_country: response});
            console.log(response[0]);
        });
    }

    fetchTopics() {
        $.getJSON('/fr/topics.json', (response) => {
            this.setState({ topics: response });
        });
    }

    fetchTopArticles(topic_id) {
        $.getJSON('/fr/topics/'+topic_id+'/articles.json', (response) => {
            this.setState({ topArticles: response });
        });
    }

    componentDidMount() {
        this.fetchCurrentCountry();
        this.fetchTopics();
        this.fetchTopArticles(1);

    };//componentDidMount

    onCountryChange(e, country) {
        e.preventDefault();

        // ajax call need to be finished to have the topics updated
        $.ajax({
            url:"/countries.json",
            data: {country_id: country.id},
            dataType: "json"
        }).success(function(res){
            this.fetchTopics();
            this.setState({current_country: country});
        }.bind(this));//ajax call

        console.log(country);

    };//onCountryChange

    render() {
        return (
            <div className="row">
                <div className="col-md-8">
                    <CountrySelector current_country={this.state.current_country} onCountryChange={this.onCountryChange} />
                    <TopicList topics={this.state.topics} />
                </div>
                <div className="col-md-4">
                    <TopArticleList topArticles={this.state.topArticles}/>
                </div>
            </div>
        );
    }//render
}


$(document).ready(function () {
    ReactDOM.render(
        <FaqApp country_id={document.getElementById('FaqApp').getAttribute("country_id")} />,
        document.getElementById('FaqApp')
    );
});

