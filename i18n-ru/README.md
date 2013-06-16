# The Default Russian i18n Package for Lovely.io

This package contains the stock translations package for lovely.io in Russian.

## How To Use

You can use it as a standalone package

```js
Lovely(['i18n-ru'], function(i18n) {

  i18n('Save');   // -> 'Сохранить'
  i18n('Cancel'); // -> 'Отмена'

});
```

Or with UI and other packages like so

```js
Lovely(['dialog', 'i18n-ru'], function(Dialog, i18n_ru) {
  i18n_ru(Dialog);
  var dialog = new Dialog();
});
```

Copyright & License

All the code and content in this package are released under the terms of the CCLv3 license
