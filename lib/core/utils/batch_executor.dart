class BatchExecutor {
  static Future<List<T>> execute<T>({
    required List<Future<T> Function()> tasks,
    int batchSize = 5,
  }) async {
    final results = <T>[];

    for (var i = 0; i < tasks.length; i += batchSize) {
      final batch = tasks.skip(i).take(batchSize);
      final batchResults = await Future.wait(batch.map((task) => task()));
      results.addAll(batchResults);
    }

    return results;
  }
}
