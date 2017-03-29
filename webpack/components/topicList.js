var React = require('react');
var Topic = require('./topic');

class TopicList extends React.Component {
    constructor(props) {
        super(props);
    };//constructor

    render() {
        var topics = this.props.topics.map(function(topic, index) {
            return(
                <Topic key = { topic.id }
                       name = { topic.name }
                       description = { topic.description } />
            ) //return
        }.bind(this)); //filteredApts.map

        return (
            <ul className="list-unstyled">
                {topics}
            </ul>
        );
    };//render

}//TopicList

module.exports = TopicList;