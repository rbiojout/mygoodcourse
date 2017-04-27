import React, { PropTypes } from 'react';
import Topic from './topic';


function TopicList({ topics  }) {
    return(
    //if (typeof topics != 'undefined') {
        <ul>
            {topics.map(topic =>
                <Topic
                    key={topic.id}
                    {...topic}
                />
            )}
        </ul>

    //}

    );

};

// Specifies the default values for props:
TopicList.defaultProps = {
    topics: []
};

export default TopicList;

