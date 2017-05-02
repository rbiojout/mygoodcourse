import React from 'react';
import PropTypes from 'prop-types';

class Topic extends React.Component {
    rawMarkup(){
        var rawMarkup = this.props.description
        return { __html: rawMarkup };
    };//rawMarkup

    render() {
        return(
            <li className="with-dash">
                <div className="feature-box fbox-outline fbox-dark fbox-effect">
                    <div className="fbox-icon">
                        <i className="fa fa-book"></i>
                    </div>
                    <a href="/fr/topics/#{this.props.id}/articles">
                        <h3>{ this.props.name }</h3></a>
                    <p dangerouslySetInnerHTML={this.rawMarkup()} />
                </div>
            </li>
        )
    }
}// Topic

function rawMarkup(description){
    var rawMarkup = description
    return { __html: rawMarkup };
};//rawMarkup

function TopicCool({name, description}) {
    <li className="with-dash">
        <div className="feature-box fbox-outline fbox-dark fbox-effect">
            <div className="fbox-icon">
                <i className="fa fa-book"></i>
            </div>
            <a href="/fr/topics/#{this.props.id}/articles">
                <h3>{ this.props.name }</h3></a>
            <p dangerouslySetInnerHTML={this.rawMarkup({description})} />
        </div>
    </li>
}

TopicCool.propTypes = {
    name: PropTypes.string.isRequired,
    description: PropTypes.string.isRequired,
}


export default TopicCool;

module.exports = Topic;