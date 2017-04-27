import { FETCH_ARTICLES, FETCH_ARTICLE } from 'shared/constants/actions';
// added for tests
import {FETCH_ALL_TOPICS} from 'shared/constants/actions';
import { ARTICLE_PATH } from 'shared/constants/apis';
import { axios } from 'faqApp/utilities';
import { browserHistory } from 'react-router';
import { createError } from 'shared/actions/errors';


function fetchArticlesRequest() {
    return {
        type: FETCH_ARTICLES.REQUEST,
    };
}
function fetchArticlesSuccess({ articles, meta }) {
    return {
        type: FETCH_ARTICLES.SUCCESS,
        payload: {
            articles,
        },
    };
}

function fetchArticlesFailure() {
    return {
        type: FETCH_ARTICLES.FAILURE,
    };
}

/* fetch all Articles */
export function fetchArticles(params = { page: 1 }) {
    let url = `${ARTICLE_PATH}?page=${params.page}`;

    if (params.tagId) {
        url += `&tag-id=${params.tagId}`;
    }

    const request = axios.get(url);
    return dispatch => {
        if (params.page === 1) {
            dispatch(fetchArticlesRequest());
        }
        return (
            request
                .then(response => dispatch(fetchArticlesSuccess(response.data)))
                .catch(error => {
                    dispatch(fetchArticlesFailure());
                    dispatch(createError(error));
                })
        );
    };
}

function fetchArticleSuccess(response) {
    return {
        type: FETCH_ARTICLE.SUCCESS,
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

/* fetch one Article providing the id */
export function fetchArticle(path) {
    const request = axios.get(`${ARTICLE_PATH}/${path}`);
    return dispatch => {
        return request
            .then(response => dispatch(fetchArticleSuccess(response.data)))
            .catch(() => browserHistory.push('/not-found'));
    };
}


