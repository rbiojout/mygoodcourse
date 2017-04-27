import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { deleteError } from 'shared/actions/errors';


export default function (ComposedComponent) {
  function mapStateToProps(state) {
    return {
      hasAlert: state.error.hasAlert,
      message: state.error.message,
    };
  }

  const propTypes = {
    hasAlert: PropTypes.bool.isRequired,
    message: PropTypes.string,
    deleteError: PropTypes.func.isRequired,
  };

  class Alert extends Component {

    componentWillMount() {
      this.deleteAlertIfNeeded(this.props);
    }

    componentWillReceiveProps(nextProps) {
      this.deleteAlertIfNeeded(nextProps);
    }

    deleteAlertIfNeeded(props) {
      if (props.hasAlert) {
        setTimeout(() => {
          this.props.deleteError();
        }, 1500);
      }
    }

    render() {
      if (this.props.hasAlert) {
        return (
          <div>
            <div>
              {this.props.message}
            </div>
            <ComposedComponent {...this.props} />
          </div>
        );
      }
      return <ComposedComponent {...this.props} />;
    }
  }

  Alert.propTypes = propTypes;
  return connect(mapStateToProps, { deleteError })(Alert);
}

