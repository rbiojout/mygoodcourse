import axios from '../utilities';
/*
 * action types
 */

import {FETCH_TOPICS, FETCH_TOPIC, FETCH_TOPARTICLES} from '../constants/actions'


/*
 * other constants
 */

export const Topic = {"id":2,"name":"Le service MyGoodCourse","description":"\u003cp\u003eDans cette rubrique, les informations relatives au fonctionnement du service MyGoodCourse sont présentées.\u003c/p\u003e\u003cp\u003eIl s'agit les informations générales permettant de mieux connaitre le fonctionnement du service.\u003c/p\u003e","position":1,"slug":"a-qui-s-adresse-mygoodcourse","country_id":1,"created_at":"2016-08-22T09:57:01.119Z","updated_at":"2016-11-13T20:43:28.801Z","url":"https://www.mygoodcourse.com/fr/topics/a-qui-s-adresse-mygoodcourse.json"};

/*
 * action creators
 */

function fetchTopicsRequest() {
    return {
        type: FETCH_TOPICS.REQUEST,
    };
}

function fetchTopicsSuccess( data ) {
    return {
        type: FETCH_TOPICS.SUCCESS,
        payload: {
            topics: data['topics']
        },
    };
}

function fetchTopicsFailure() {
    return {
        type: FETCH_TOPICS.FAILURE,
    };
}


export function fetchTopics() {
    let url = 'topics?format=json';
    const request = axios.get(url);
    return (dispatch) => {
        dispatch(fetchTopicsRequest());
        return (
            request
                .then(response => dispatch(fetchTopicsSuccess(response.data)))
                .catch(error => {
                    console.log('error :'+error);
                    dispatch(fetchTopicsFailure());
                    //dispatch(createError(error));
                })
        );
    };
}


export const fetchTopic = (id) => {
    let topic = Topic;
    return {
        type: FETCH_TOPIC,
        topic: topic
    }
};

/* TopArticles */
function fetchTopArticlesRequest() {
    return {
        type: FETCH_TOPARTICLES.REQUEST,
    };
}//fetchTopArticlesRequest

function fetchTopArticlesSuccess( data ) {
    return {
        type: FETCH_TOPARTICLES.SUCCESS,
        payload: {
            topArticles: data['articles']
        },
    };
}//fetchTopArticlesSuccess

function fetchTopArticlesFailure() {
    return {
        type: FETCH_TOPARTICLES.FAILURE,
    };
}//fetchTopArticlesFailure

export const fetchTopArticles = (country_id) => {
    let url ='articles/top.json?country_id='+country_id;
    const request = axios.get(url);
    return (dispatch) => {
        dispatch(fetchTopArticlesRequest());
        return (
            request
                .then(response => dispatch(fetchTopArticlesSuccess(response.data)))
                .catch(error => {
                    console.log('error :'+error);
                    dispatch(fetchTopArticlesFailure());
                    //dispatch(createError(error));
                })
        );
    };
}//fetchTopArticles