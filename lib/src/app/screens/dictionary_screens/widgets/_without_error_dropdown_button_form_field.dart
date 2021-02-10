part of 'languages_list_button.dart';

class _WithoutErrorDropdownButtonFormField<T> extends FormField<T> {
  final ValueChanged<T> onChanged;

  _WithoutErrorDropdownButtonFormField({
    Key key,
    @required List<DropdownMenuItem<T>> items,
    DropdownButtonBuilder selectedItemBuilder,
    T value,
    Widget hint,
    Widget disabledHint,
    this.onChanged,
    VoidCallback onTap,
    int elevation = 8,
    TextStyle style,
    Widget icon,
    Color iconDisabledColor,
    Color iconEnabledColor,
    double iconSize = 24.0,
    bool isDense = true,
    bool isExpanded = false,
    double itemHeight,
    Color focusColor,
    FocusNode focusNode,
    bool autofocus = false,
    Color dropdownColor,
    InputDecoration decoration,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    AutovalidateMode autovalidateMode,
  }) :  assert(items == null || items.isEmpty || value == null || items.where((item) => item.value == value).length == 1,
          'There should be exactly one item with [DropdownButton]\'s value: $value. \n'
          'Either zero or 2 or more [DropdownMenuItem]s were detected with the same value',
        ),
        assert(elevation != null),
        assert(iconSize != null),
        assert(isDense != null),
        assert(isExpanded != null),
        assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
        assert(autofocus != null),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: value,
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<T> field) {
            final _WithoutErrorDropdownButtonFormFieldState<T> state = field as _WithoutErrorDropdownButtonFormFieldState<T>;
            final InputDecoration decorationArg =  decoration ?? InputDecoration(focusColor: focusColor);
            final InputDecoration effectiveDecoration = decorationArg.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );
            return Focus(
              canRequestFocus: false,
              skipTraversal: true,
              child: Builder(
                builder: (context) {
                  return InputDecorator(
                    decoration: effectiveDecoration,
                    isEmpty: state.value == null,
                    isFocused: Focus.of(context).hasFocus,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<T>(
                        items: items,
                        selectedItemBuilder: selectedItemBuilder,
                        value: state.value,
                        hint: hint,
                        disabledHint: disabledHint,
                        onChanged: state.didChange,
                        onTap: onTap,
                        elevation: elevation,
                        style: style,
                        icon: icon,
                        iconDisabledColor: iconDisabledColor,
                        iconEnabledColor: iconEnabledColor,
                        iconSize: iconSize,
                        isDense: isDense,
                        isExpanded: isExpanded,
                        itemHeight: itemHeight,
                        focusColor: focusColor,
                        focusNode: focusNode,
                        autofocus: autofocus,
                        dropdownColor: dropdownColor,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );

  @override
  FormFieldState<T> createState() => _WithoutErrorDropdownButtonFormFieldState<T>();
}

class _WithoutErrorDropdownButtonFormFieldState<T> extends FormFieldState<T> {
  @override
  _WithoutErrorDropdownButtonFormField<T> get widget => super.widget as _WithoutErrorDropdownButtonFormField<T>;

  @override
  void didChange(T value) {
    super.didChange(value);
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }

  @override
  void didUpdateWidget(_WithoutErrorDropdownButtonFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}
