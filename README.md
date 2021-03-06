vim-region-edit
===============

概要
----

範囲を選択してその範囲内だけ編集するためのプラグインです。
パターン検索して一致した行を抽出してそこだけ編集もできます。

![RegionEdit](https://raw.githubusercontent.com/tAkihiko/vim-region-edit/master/ss1.gif)

### パターン検索編集

そのまま or 範囲選択して

```
:RegionEdit {pat}
```

で `{pat}` を含む行を抽出し、

```
:EndRegionEdit
```

で戻ります。

この場合、改行未対応です。

範囲選択した場合その範囲内のみが対象となります。

### 範囲選択編集

上記の`{pat}`なしの状態でこちらのモードにります。

範囲選択して（もしくは手打ち）

```
:'<, '>RegionEdit
```

で選択した範囲を抽出し、

```
:EndRegionEdit
```

で戻ります。

こちらは行数変更も反映しますが、
なにも編集していなくても modified な状態になります。

Licence
-------

MIT

TODO
----

* ちゃんとした Vim Script の流儀に沿う
