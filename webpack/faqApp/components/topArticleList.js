var React = require('react');
var TopArticle = require('./topArticle')

class TopArticleList extends React.Component {
    constructor(props) {
        super(props);
    };//constructor

    render() {
        var topArticles = this.props.topArticles.map(function(article, index) {
            return(
                <TopArticle key = { article.id }
                            id = { article.id }
                            name = { article.name }
                            topic_id = { article.topic_id }
                            counter_cache = {article.counter_cache}
                />
            ) //return
        }.bind(this)); //topArticles.map

        return (
            <ul className="list-unstyled">
                {topArticles}
            </ul>
        );
    };//render

}//TopArticleList

module.exports = TopArticleList;