InlineSvg = React.createClass({
  render() {
    const iconName = this.props.iconName;
    const useTag = '<use xlink:href="'+iconName+'"></use>';

    return (
      <svg className={this.props.iconClass} preserveAspectRatio="xMinYMin meet" dangerouslySetInnerHTML={{__html: useTag }} />
    );
  }
});
