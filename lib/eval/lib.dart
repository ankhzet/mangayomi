import 'package:mangayomi/eval/dummy/service.dart';
import 'package:mangayomi/eval/interface.dart';
import 'package:mangayomi/models/source.dart';

import 'dart/service.dart';
import 'javascript/service.dart';
import 'mihon/service.dart';
import 'lnreader/service.dart';

ExtensionService getExtensionService(Source source, String androidProxyServer) {
  if ((source.isActive != true) || (source.sourceCode?.isNotEmpty != true)) {
    return DummyExtensionService(source);
  }

  return switch (source.sourceCodeLanguage) {
    SourceCodeLanguage.dart => DartExtensionService(source),
    SourceCodeLanguage.javascript => JsExtensionService(source),
    SourceCodeLanguage.mihon => MihonExtensionService(
      source,
      androidProxyServer,
    ),
    SourceCodeLanguage.lnreader => LNReaderExtensionService(source),
  };
}

Future<T> withExtensionService<T>(
  Source source,
  String proxyServer,
  Future<T> Function(ExtensionService service) action,
) async {
  final service = getExtensionService(source, proxyServer);
  try {
    return await action(service);
  } finally {
    service.dispose();
  }
}
