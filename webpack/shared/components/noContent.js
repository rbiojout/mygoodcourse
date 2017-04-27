import React, { PropTypes } from 'react';

const propTypes = {
    pageName: PropTypes.string.isRequired,
};

function NoContent({ pageName }) {
    return (
        <div>
            <p>{`we couldn't find any ${pageName}`}</p>
        </div>
    );
}

NoContent.propTypes = propTypes;
export default NoContent;