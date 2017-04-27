import React, { Component } from 'react';

export default function (ComposedComponent) {
  class ProgressBar extends Component {
    constructor(props) {
      super(props);
      this.state = { loading: true };
    }

    renderProgressBar() {
      if (this.state.loading) {
        return (
          <div>Progress</div>
        );
      }
    }


    render() {
      return (
        <div>
          {this.renderProgressBar()}
          <ComposedComponent
            {...this.props}
            finishLoading={() => this.setState({ loading: false })}
          />
        </div>
      );
    }
  }

  return ProgressBar;
}

