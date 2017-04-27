import { connect } from 'react-redux'
import TopicList from '../components/TopicList'


const getVisibleTopics = (topics, country_id) => {
    if (topics == undefined) {
        return []
    }
    return topics.filter(t => t.country_id == country_id)
}

const mapStateToProps = (state) => {
    let country_id = (state.countries.current_country==undefined)?1:state.countries.current_country.id;
    return {
        topics: getVisibleTopics(state.topics.topics, country_id),
        loading: state.topics.loadingTopics
    }
}

const mapDispatchToProps = (dispatch, ownProps) => {
    return {}
}

const VisibleTopics = connect(
    mapStateToProps,
    mapDispatchToProps
)(TopicList)

export default VisibleTopics