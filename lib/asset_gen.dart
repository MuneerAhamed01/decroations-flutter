import 'dart:io';

void main() async {
  // Define directories to scan
  final directories = ['assets/images', 'assets/svgs'];
  const outputFile = 'lib/utils/images.dart';

  // Store all asset paths
  final List<String> assetPaths = [];

  // Scan directories for assets
  for (final dir in directories) {
    final directory = Directory(dir);
    if (await directory.exists()) {
      await for (final entity in directory.list(recursive: false)) {
        if (entity is File) {
          final path =
              entity.path.replaceAll('\\', '/'); // Normalize path separators
          assetPaths.add(path);
        }
      }
    }
  }

  // Generate constant declarations
  final StringBuffer code = StringBuffer();

  // Add file header
  code.writeln('// Generated file. Do not edit.');
  code.writeln('// Generated on ${DateTime.now()}');
  code.writeln();

  // Generate constants for each asset
  for (final path in assetPaths.sorted()) {
    final name = _generateConstantName(path);
    code.writeln("const String $name = '$path';");
  }

  // Write to file
  final file = File(outputFile);
  await file.writeAsString(code.toString());

  print('Generated asset constants in $outputFile');
}

String _generateConstantName(String path) {
  // Remove 'assets/' prefix and file extension
  final name = path
      .replaceFirst('assets/', '')
      .replaceAll(RegExp(r'\.(png|jpg|jpeg|svg|gif)$'), '');

  // Convert path segments to camelCase
  final segments = name.split('/');
  final constantName = segments.map((segment) {
    final words = segment
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
    return words;
  }).join('');

  // Add 'k' prefix and ensure first character after 'k' is uppercase
  return 'k$constantName';
}

extension on List<String> {
  List<String> sorted() {
    final copy = List<String>.from(this);
    copy.sort();
    return copy;
  }
}
