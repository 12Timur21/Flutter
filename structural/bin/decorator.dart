abstract class HtmlTag {
  String render();
}

class Span implements HtmlTag {
  String text = '';

  Span(this.text);

  String render() {
    return '<span>$text<span>';
  }
}

abstract class HtmlTagDecorator extends HtmlTag {
  HtmlTag htmlTag;

  HtmlTagDecorator(this.htmlTag);

  @override
  String render() {
    return htmlTag.render();
  }
}

class B extends HtmlTagDecorator {
  B(HtmlTag htmlTag) : super(htmlTag);

  @override
  String render() {
    return '<b>${htmlTag.render()}</b>';
  }
}

class ColorRed extends HtmlTagDecorator {
  ColorRed(HtmlTag htmlTag) : super(htmlTag);

  @override
  String render() {
    return '<span style="color:red">${htmlTag.render()}</span>';
  }
}

void main() {
  Span span = Span('Bold red text');

  B b = B(span);

  ColorRed colorRed = ColorRed(b);

  print(colorRed.render());

  // HtmlTag boldRedText = ColorRed(B(Span('Bold red text...')));
  // print(htmlTag.render());
}
