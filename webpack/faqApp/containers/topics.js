import { connect } from 'react-redux'
import { toggleTodo } from '../actions'
import TopicList from '../components/topicList'


const mapStateToProps = (state) => {
    return {
        topics: getTopics(state.topics)
    }
}

const mapDispatchToProps = (dispatch) => {
    return {
        onTodoClick: (id) => {
            dispatch(toggleTodo(id))
        }
    }
}

const TopicList = connect(
    mapStateToProps,
    mapDispatchToProps
)(TodoList)

export default TopicList