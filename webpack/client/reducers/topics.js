import { FETCH_TOPICS, FETCH_TOPIC, FETCH_TOPARTICLES } from '../constants/actions'
import { Topic} from '../actions/topics'

const initialState = {
    topics: [],
    loadingTopics: false,
    topic: {},
    topArticles: [],
    loadingTopArticles: false,
}

function topics(state = initialState, action) {
    switch (action.type) {

        case FETCH_TOPICS.REQUEST:
            return { ...state, loadingTopics: true };

        case FETCH_TOPICS.SUCCESS:
            return { ...state, topics: action.payload.topics, loadingTopics: false };


        case FETCH_TOPICS.FAILURE:
            return { ...state, loadingTopics: false };

        case FETCH_TOPIC:
            return Object.assign({}, state, {
                topic: Topic
            })

        case FETCH_TOPARTICLES.REQUEST:
            return { ...state, loadingTopArticles: true };

        case FETCH_TOPARTICLES.SUCCESS:
            return { ...state, topArticles: action.payload.topArticles, loadingTopArticles: false };


        case FETCH_TOPARTICLES.FAILURE:
            return { ...state, loadingTopArticles: false };


        default:
            return state;
    }
}

export default topics