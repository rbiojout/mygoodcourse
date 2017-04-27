import React from 'react'
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux'
import { createStore, applyMiddleware } from 'redux'
import axios from 'axios';
import { composeWithDevTools } from 'remote-redux-devtools';
import thunk from 'redux-thunk';

import clientApp from './reducers'
import {fetchTopics, fetchTopic, fetchTopArticles} from './actions/topics'
import {fetchCountries, setCountry} from './actions/countries'
import App from './App'


import {FETCH_TOPICS, FETCH_TOPIC, FETCH_TOPARTICLES} from './constants/actions'

const client = axios.create({ //all axios can be used, shown in axios documentation
    baseURL:'/',
    responseType: 'json'
});

// let store = createStore(clientApp);

const composeEnhancers = composeWithDevTools({ realtime: true
    // options like actionSanitizer, stateSanitizer
});
//const store = createStore(reducer, /* preloadedState, */ composeEnhancers(


const logger = store => next => action => {
    console.log('dispatching', action)
    let result = next(action)
    console.log('next state', store.getState())
    return result
}

const crashReporter = store => next => action => {
    try {
        return next(action)
    } catch (err) {
        console.error('Caught an exception!', err)
        Raven.captureException(err, {
            extra: {
                action,
                state: store.getState()
            }
        })
        throw err
    }
}

let store = createStore(
    clientApp, //custom reducers
    composeEnhancers(
        applyMiddleware(
            //all middlewares
            thunk, //second parameter options can optionally contain onSuccess, onError, onComplete, successSuffix, errorSuffix
            logger,
            crashReporter
        )
    )
);

// Log the initial state
console.log(store.getState());


// Every time the state changes, log it
// Note that subscribe() returns a function for unregistering the listener
let unsubscribe = store.subscribe(() =>
    console.log(store.getState())
);

// Dispatch some actions
store.dispatch(fetchCountries());
store.dispatch(setCountry(1));
store.dispatch(fetchTopics());
store.dispatch(fetchTopic());

function nextOp() {
    return {
        type: FETCH_TOPICS.REQUEST,
    }
}

store.dispatch(nextOp());
//store.dispatch(fetchTopArticles());

window.Redux = require("redux");
window.ReactRedux = require("react-redux");

$(document).ready(function () {
    ReactDOM.render(
        <Provider store={store}>
            <App />
        </Provider>,
        document.getElementById('Client')
    );
});