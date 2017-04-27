import React from 'react'
import TopArticleList from './components/topArticleList';
import CountrySelector from './components/countrySelector';
import TopicList from './components/topicList';

const FaqApp = () => (
    <div className="row">
        <div className="col-md-8">
            <TopicList />
        </div>
        <div className="col-md-4">

        </div>
    </div>
)


//<CountrySelector current_country={this.state.current_country} onCountryChange={this.onCountryChange} />
//<TopArticleList topArticles={this.state.topArticles}/>

export default FaqApp