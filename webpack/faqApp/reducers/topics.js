import {
    FETCH_TOPICS,
    FETCH_TOPIC,
    FETCH_ALL_TOPICS,
} from 'shared/constants/actions';

const INITIAL_STATE = {
    topics: [],
    loading: false,
    limit: 20,
    page: 1,
    total: 0,
    topic: { title: '', publishedAt: '' },
    topicForm: { },
    errorMessage: ''
};

export default function (state = INITIAL_STATE, action) {
    switch (action.type) {
        case FETCH_TOPICS.REQUEST:
            return { ...state, loading: true };

        case FETCH_TOPICS.SUCCESS:
            return {
                ...state,
                posts: action.payload.posts,
                limit: action.payload.limit,
                page: action.payload.page,
                total: action.payload.total
            };

        case FETCH_TOPIC.SUCCESS:
            return {...state, post: action.payload.post, errorMessage: '' };


        case FETCH_TOPICS.FAILURE:
            return { ...state, loading: false };

        case FETCH_ALL_TOPICS:
            return {
                ...state,
                topics: action.payload.topics };

        default:
            return state;
    }
}