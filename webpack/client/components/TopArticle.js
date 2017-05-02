import React from 'react';
import PropTypes from 'prop-types';

class TopArticle extends React.Component {
    render() {
        return(
            <li className="with-dash">
                <a href={"/fr/topics/"+this.props.topic_id+"/articles/"+this.props.id}>
                    <h4>{this.props.name}</h4>
                </a>
                <ul className="list-meta">
                    <li><span className="fa fa-eye"></span> {this.props.counter_cache}</li>
                    <li><span className="fa fa-book"></span>
                        <a href={"/fr/topics/"+this.props.topic_id} >
                            {this.props.name}
                        </a>
                    </li>
                </ul>
            </li>
        )
    }
}// TopArticle


TopArticle.propTypes = {
    id: PropTypes.number.isRequired,
    topic_id: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    counter_cache: PropTypes.number.isRequired,
}

module.exports = TopArticle;