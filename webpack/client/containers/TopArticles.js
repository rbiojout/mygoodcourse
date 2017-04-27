import { connect } from 'react-redux'
import TopArticleList from '../components/TopArticleList'


const mapStateToProps = (state) => {
    return {
        topArticles: state.topics.topArticles,
        loading: state.topics.loadingTopArticles
    }
}

const mapDispatchToProps = (dispatch, ownProps) => {
    return {}
}

const TopArticles = connect(
    mapStateToProps,
    mapDispatchToProps
)(TopArticleList)

export default TopArticles