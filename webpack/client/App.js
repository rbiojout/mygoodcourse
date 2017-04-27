import React from 'react'
import VisibleTopics from './containers/VisibleTopics'
import TopArticles from './containers/TopArticles'
import CountrySelector from './containers/CountrySelector'

const App = () => (
    <div>
        <div className="row">
            <h1>HELLO</h1>
            <div className="col-md-8">
                <CountrySelector/>
                <VisibleTopics/>
            </div>
            <div className="col-md-4">
                <TopArticles/>
            </div>
        </div>
    </div>
)

export default App