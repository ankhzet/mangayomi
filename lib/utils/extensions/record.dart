extension Listable on Record {
  List<V> toList<V>() {
    return switch (this) {
      (V v1,) => [v1],
      (V v1, V v2) => [v1, v2],
      (V v1, V v2, V v3) => [v1, v2, v3],
      (V v1, V v2, V v3, V v4) => [v1, v2, v3, v4],
      (V v1, V v2, V v3, V v4, V v5) => [v1, v2, v3, v4, v5],
      (V v1, V v2, V v3, V v4, V v5, V v6) => [v1, v2, v3, v4, v5, v6],
      (V v1, V v2, V v3, V v4, V v5, V v6, V v7) => [v1, v2, v3, v4, v5, v6, v7],
      (V v1, V v2, V v3, V v4, V v5, V v6, V v7, V v8) => [v1, v2, v3, v4, v5, v6, v7, v8],
      (V v1, V v2, V v3, V v4, V v5, V v6, V v7, V v8, V v9) => [v1, v2, v3, v4, v5, v6, v7, v8, v9],
      _ => throw AssertionError('Record has > 9 positions')
    };
  }
}
