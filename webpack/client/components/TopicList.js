import React, { PropTypes } from 'react';
import Topic from './Topic';
import Loading from './Loading';


function TopicList({ topics, loading  }) {
    if (loading) {
        return (
            <Loading />
        );
    }
    return(
        <ul className="list-unstyled">
            {topics.map(topic =>
                <Topic
                    key={topic.id}
                    {...topic}
                />
            )}
        </ul>
    );

};

// Specifies the default values for props:
TopicList.defaultProps = {
    topics: []
};

export default TopicList;

