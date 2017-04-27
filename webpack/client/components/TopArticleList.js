import React, { PropTypes } from 'react';
var TopArticle = require('./TopArticle');
import Loading from './Loading';



function TopArticleList({topArticles, loading}) {
    if (loading) {
        return (
            <Loading />
        );
    }
    return(
        <ul className="list-unstyled">
            {topArticles.map(article =>
                <TopArticle key = { article.id }
                    {...article}
                />
            )}
            </ul>
    );
}// TopArticleList

// Specifies the default values for props:
TopArticleList.defaultProps = {
    topArticles: []
};


export default TopArticleList;
