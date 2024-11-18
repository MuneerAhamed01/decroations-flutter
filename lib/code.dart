import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeSyntaxTheme {
  static const keyword = Color(0xFF569CD6); // Light blue for keywords
  static const string = Color(0xFFCE9178); // Coral for strings
  static const comment = Color(0xFF6A9955); // Green for comments
  static const number = Color(0xFFB5CEA8); // Light green for numbers
  static const type = Color(0xFF4EC9B0); // Turquoise for types
  static const background = Color(0xFF1E1E1E); // Dark background
  static const text = Color(0xFFD4D4D4); // Light grey text
  static const annotation = Color(0xFF569CD6); // Light blue for annotations
}

class ClaudeStyleCodeWidget extends StatefulWidget {
  final String code;
  final String? title;

  const ClaudeStyleCodeWidget({
    Key? key,
    required this.code,
    this.title,
  }) : super(key: key);

  @override
  State<ClaudeStyleCodeWidget> createState() => _ClaudeStyleCodeWidgetState();
}

class _ClaudeStyleCodeWidgetState extends State<ClaudeStyleCodeWidget> {
  bool _isCopied = false;

  List<TextSpan> _highlightSyntax(String code) {
    final List<TextSpan> spans = [];

    // Updated RegExp patterns
    final RegExp keyword = RegExp(
      r'\b(void|int|double|String|var|final|const|class|extends|if|else|for|while|do|switch|case|break|continue|return|true|false|null|bool)\b',
      multiLine: true,
    );

    // Fixed string RegExp to properly match quotes
    final RegExp string =
        RegExp(r'("([^"\\]|\\.)*")|' + r"('([^'\\]|\\.)*')", multiLine: true);

    // Updated comment RegExp to properly match single and multi-line comments
    final RegExp comment = RegExp(r'//[^\n]*|/\*[\s\S]*?\*/', multiLine: true);

    final RegExp number = RegExp(r'\b\d+\.?\d*\b');
    final RegExp annotation = RegExp(r'@\w+');
    final RegExp type = RegExp(
        r'\b(List|Map|Set|Future|Stream|Widget|State|BuildContext|TextSpan|RegExp)\b');

    String remaining = code;

    while (remaining.isNotEmpty) {
      Match? annotationMatch = annotation.firstMatch(remaining);
      Match? keywordMatch = keyword.firstMatch(remaining);
      Match? typeMatch = type.firstMatch(remaining);
      Match? stringMatch = string.firstMatch(remaining);
      Match? commentMatch = comment.firstMatch(remaining);
      Match? numberMatch = number.firstMatch(remaining);

      Match? firstMatch;
      Color? color;
      int startIndex = remaining.length;

      // Find the earliest match
      if (annotationMatch?.start != null &&
          annotationMatch!.start < startIndex) {
        firstMatch = annotationMatch;
        color = CodeSyntaxTheme.annotation;
        startIndex = annotationMatch.start;
      }
      if (keywordMatch?.start != null && keywordMatch!.start < startIndex) {
        firstMatch = keywordMatch;
        color = CodeSyntaxTheme.keyword;
        startIndex = keywordMatch.start;
      }
      if (typeMatch?.start != null && typeMatch!.start < startIndex) {
        firstMatch = typeMatch;
        color = CodeSyntaxTheme.type;
        startIndex = typeMatch.start;
      }
      if (stringMatch?.start != null && stringMatch!.start < startIndex) {
        firstMatch = stringMatch;
        color = CodeSyntaxTheme.string;
        startIndex = stringMatch.start;
      }
      if (commentMatch?.start != null && commentMatch!.start < startIndex) {
        firstMatch = commentMatch;
        color = CodeSyntaxTheme.comment;
        startIndex = commentMatch.start;
      }
      if (numberMatch?.start != null && numberMatch!.start < startIndex) {
        firstMatch = numberMatch;
        color = CodeSyntaxTheme.number;
        startIndex = numberMatch.start;
      }

      if (firstMatch != null && firstMatch.start == 0) {
        spans.add(TextSpan(
          text: firstMatch.group(0),
          style: TextStyle(color: color),
        ));
        remaining = remaining.substring(firstMatch.end);
      } else {
        spans.add(TextSpan(
          text: remaining[0],
          style: const TextStyle(color: CodeSyntaxTheme.text),
        ));
        remaining = remaining.substring(1);
      }
    }

    return spans;
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.code));
    setState(() {
      _isCopied = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: CodeSyntaxTheme.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with copy button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.title != null)
                  Text(
                    widget.title!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: CodeSyntaxTheme.text,
                    ),
                  ),
                IconButton(
                  onPressed: _copyToClipboard,
                  icon: Icon(
                    _isCopied ? Icons.check : Icons.copy,
                    size: 20,
                    color: _isCopied ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Code section with syntax highlighting
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: SelectableText.rich(
              TextSpan(
                children: _highlightSyntax(widget.code),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
