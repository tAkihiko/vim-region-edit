vim-region-edit
===============

概要
----

Region Edit といいつつパターン検索して一致した行を検索したいから作りました。

```
:RegionEdit {pat}
```

で `{pat}` を含む行を抽出し、

```
:EndRegionEdit
```

で戻ります。

改行未対応。

Licence
-------

MIT

TODO
----

* 範囲選択のみは行を置き換えて行数変動を許容する。
* ちゃんとした Vim Script の流儀に沿う
