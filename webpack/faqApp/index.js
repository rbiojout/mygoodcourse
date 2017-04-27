
import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
// import { applyRouterMiddleware, Router, browserHistory } from 'react-router';
import { createStore, applyMiddleware } from 'redux';
import { AUTH } from 'shared/constants/actions';

// import routes from './routes';
import reducers from './reducers';
// import injectTapEventPlugin from 'react-tap-event-plugin';
import thunk from 'redux-thunk';
const store = createStore(reducers, applyMiddleware(thunk));
// injectTapEventPlugin();

// Log the initial state
console.log(store.getState())


var TopArticleList = require('./components/topArticleList');
var CountrySelector = require('./components/countrySelector');
var TopicList = require('./components/topicList');

import FaqApp from './faqApp';


const accessToken = localStorage.getItem('accessToken');
if (accessToken) {
    store.dispatch({ type: AUTH.SUCCESS });
}

//<CountrySelector current_country={this.state.current_country} onCountryChange={this.onCountryChange} />
//<TopArticleList topArticles={this.state.topArticles}/>

$(document).ready(function () {
    ReactDOM.render(
        <Provider store={store}>
            <FaqApp country_id={document.getElementById('FaqApp').getAttribute("country_id")} />
        </Provider>,
        document.getElementById('FaqApp')
    );
});

