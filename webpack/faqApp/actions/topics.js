import { FETCH_TOPICS, FETCH_TOPIC } from 'shared/constants/actions';
// added for tests
import {FETCH_ALL_TOPICS} from 'shared/constants/actions';

import { TOPIC_PATH } from 'shared/constants/apis';
import { axios } from 'faqApp/utilities';
import { browserHistory } from 'react-router';
import { createError } from 'shared/actions/errors';


function fetchTopicsRequest() {
    return {
        type: FETCH_TOPICS.REQUEST,
    };
}
function fetchTopicsSuccess({ posts, meta }) {
    return {
        type: FETCH_TOPICS.SUCCESS,
        payload: {
            posts,
            total: meta.pagination.total,
            page: meta.pagination.page,
            limit: meta.pagination.limit,
        },
    };
}

function fetchTopicsFailure() {
    return {
        type: FETCH_TOPICS.FAILURE,
    };
}

export function fetchTopics(params = { page: 1 }) {
    let url = `${TOPIC_PATH}?page=${params.page}`;

    if (params.tagId) {
        url += `&tag-id=${params.tagId}`;
    }

    const request = axios.get(url);
    return dispatch => {
        if (params.page === 1) {
            dispatch(fetchTopicsRequest());
        }
        return (
            request
                .then(response => dispatch(fetchTopicsSuccess(response.data)))
                .catch(error => {
                    dispatch(fetchTopicsFailure());
                    dispatch(createError(error));
                })
        );
    };
}

function fetchTopicSuccess(response) {
    return {
        type: FETCH_TOPIC.SUCCESS,
        payload: {
            article: {
                name: response.name,
                description: response.description,
                position: response.position,
                slug: response.slug,
                topic_id: response.topic_id,
                created_at: response.created_at,
                updated_at: response.updated_at,
                counter_cache: response.counter_cache,
            },
        },
    };
}

export function fetchTopic(path) {
    const request = axios.get(`${TOPIC_PATH}/${path}`);
    return dispatch => {
        return request
            .then(response => dispatch(fetchTopicSuccess(response.data)))
            .catch(() => browserHistory.push('/not-found'));
    };
}


// added for tests
/* fetch simple */
export function fetchAllTopics(){
    const request = axios.get(`${TOPIC_PATH}?gfffffff=23`);
    return dispatch => {
        return request
            .then(response => dispatch(getAllTopics(response.data)))
    }
}

function getAllTopics(){
    return {
        type: FETCH_ALL_TOPICS,
        payload: topics
    };
}