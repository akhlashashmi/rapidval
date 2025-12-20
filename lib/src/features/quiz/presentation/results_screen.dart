import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_outlined_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../domain/quiz_entity.dart';
import '../domain/user_answer.dart';
import 'widgets/question_result_tile.dart';

class ResultsScreen extends StatefulWidget {
  final QuizResult quizResult;
  final String? returnPath;
  const ResultsScreen({super.key, required this.quizResult, this.returnPath});
  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final GlobalKey _shareCardKey = GlobalKey();
  bool _isSharing = false;

  Future<void> _showShareOptions() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: colorScheme.surfaceContainerLow,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share Results',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          'Choose how you\'d like to share your achievement',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    iconSize: 22,
                    color: colorScheme.onSurfaceVariant,
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(36, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _ShareOptionTile(
                icon: Icons.image_outlined,
                title: 'Share as Image',
                subtitle: 'Beautiful certificate card perfect for social media',
                onTap: () {
                  Navigator.pop(context);
                  _shareAsImage();
                },
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 12),
              _ShareOptionTile(
                icon: Icons.list_alt_rounded,
                title: 'Share Results Summary',
                subtitle: 'Text summary with your answers and performance',
                onTap: () {
                  Navigator.pop(context);
                  _shareResultsText();
                },
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 12),
              _ShareOptionTile(
                icon: Icons.picture_as_pdf_outlined,
                title: 'Share Learning Guide',
                subtitle:
                    'Professional PDF with all questions and correct answers',
                onTap: () {
                  Navigator.pop(context);
                  _shareLearningGuidePdf();
                },
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareAsImage() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final boundary =
          _shareCardKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Unable to capture image');
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes == null) throw Exception('Failed to generate image');
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imagePath = '${directory.path}/rapidval_result_$timestamp.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(pngBytes);
      final shareText = _buildImageShareText(widget.quizResult);
      await Share.shareXFiles([XFile(imagePath)], text: shareText);
    } catch (e) {
      debugPrint('Error sharing image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to share image. Please try again.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  String _buildImageShareText(QuizResult result) {
    final emoji = result.percentage >= 80
        ? '🎯'
        : result.percentage >= 60
        ? '📚'
        : '💪';
    return '''$emoji I scored ${result.percentage.toInt()}% on "${result.quiz.title}" in RapidVal!
Download: https://play.google.com/store/apps/details?id=dev.akhlasahmed.rapidval''';
  }

  Future<void> _shareResultsText() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final result = widget.quizResult;
      final buffer = StringBuffer();
      buffer.writeln('═══════════════════════════════════');
      buffer.writeln('📊 RAPIDVAL QUIZ RESULTS');
      buffer.writeln('═══════════════════════════════════\n');
      buffer.writeln('Quiz: ${result.quiz.title}');
      buffer.writeln('Category: ${result.quiz.category}');
      buffer.writeln(
        'Score: ${result.correctAnswers}/${result.totalQuestions} (${result.percentage.toInt()}%)',
      );
      buffer.writeln(
        'Time: ${_formatDuration(result.completedAt.difference(result.startedAt))}',
      );
      buffer.writeln('\n═══════════════════════════════════');
      buffer.writeln('DETAILED BREAKDOWN');
      buffer.writeln('═══════════════════════════════════\n');
      for (int i = 0; i < result.quiz.questions.length; i++) {
        final q = result.quiz.questions[i];
        final answer = result.answers.firstWhere(
          (a) => a.questionIndex == i,
          orElse: () => UserAnswer(
            questionIndex: i,
            selectedOptionIndex: -1,
            answeredAt: DateTime.now(),
          ),
        );
        final isCorrect = _checkIfCorrect(q, answer);
        final isSkipped =
            answer.selectedOptionIndex == -1 && answer.selectedIndices.isEmpty;
        buffer.writeln('Q${i + 1}. ${q.question}');
        buffer.writeln();
        if (isSkipped) {
          buffer.writeln('   Your Answer: [SKIPPED] ⏭️');
        } else {
          final userAnswerText = _getUserAnswerText(q, answer);
          final status = isCorrect ? '✅ CORRECT' : '❌ INCORRECT';
          buffer.writeln('   Your Answer: $userAnswerText');
          buffer.writeln('   Status: $status');
        }
        if (!isCorrect) {
          final correctAnswerText = _getCorrectAnswerText(q);
          buffer.writeln('   Correct Answer: $correctAnswerText');
        }
        buffer.writeln();
        buffer.writeln('───────────────────────────────────');
        buffer.writeln();
      }
      buffer.writeln('\n═══════════════════════════════════');
      buffer.writeln('Developed by Akhlas Ahmed at ATIF IY');
      buffer.writeln(
        'Download RapidVal: https://play.google.com/store/apps/details?id=dev.akhlasahmed.rapidval',
      );
      buffer.writeln('═══════════════════════════════════');
      await Share.share(buffer.toString());
    } catch (e) {
      debugPrint('Error sharing text: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to share results. Please try again.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _shareLearningGuidePdf() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final result = widget.quizResult;
      final doc = pw.Document();

      final fontRegular = await PdfGoogleFonts.interRegular();
      final fontMedium = await PdfGoogleFonts.interMedium();
      final fontBold = await PdfGoogleFonts.interBold();
      final fontItalic = await PdfGoogleFonts.interItalic();

      final PdfColor primaryBlue = PdfColor.fromInt(0xFF1E40AF);
      final PdfColor textDark = PdfColor.fromInt(0xFF111827);
      final PdfColor textLight = PdfColor.fromInt(0xFF6B7280);
      final PdfColor successBg = PdfColor.fromInt(0xFFECFDF5);
      final PdfColor successBorder = PdfColor.fromInt(0xFF10B981);

      doc.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            theme: pw.ThemeData.withFont(
              base: fontRegular,
              bold: fontBold,
              italic: fontItalic,
            ),
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            buildBackground: (context) => pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: PdfColors.white),
            ),
          ),
          // MODIFIED: Wrapped in Column to enforce spacing on ALL pages
          header: (context) => pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              _buildSwissHeader(
                result,
                fontBold,
                fontRegular,
                textDark,
                textLight,
                primaryBlue,
              ),
              pw.SizedBox(
                height: 20,
              ), // Consistent spacing after header divider
            ],
          ),
          footer: (context) => _buildPdfFooter(
            context,
            fontRegular,
            fontMedium,
            textLight,
            PdfColor.fromInt(0xFFE5E7EB),
          ),
          build: (context) => [
            // Intro text
            pw.Text(
              'This comprehensive guide includes all quiz questions, your answers, and detailed explanations. Review this document to reinforce your learning.',
              style: pw.TextStyle(
                font: fontRegular,
                fontSize: 10,
                color: textLight,
                lineSpacing: 1.4,
              ),
            ),
            pw.SizedBox(height: 25),
            ...List.generate(result.quiz.questions.length, (index) {
              final q = result.quiz.questions[index];
              final userAnswer = result.answers.firstWhere(
                (a) => a.questionIndex == index,
                orElse: () => UserAnswer(
                  questionIndex: index,
                  selectedOptionIndex: -1,
                  answeredAt: DateTime.now(),
                ),
              );
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 24),
                child: _buildSwissQuestion(
                  q,
                  index,
                  userAnswer,
                  fontRegular,
                  fontBold,
                  fontItalic,
                  textDark,
                  textLight,
                  successBg,
                  successBorder,
                  primaryBlue,
                ),
              );
            }),
          ],
        ),
      );

      final bytes = await doc.save();
      final filename =
          'RapidVal_${_sanitizeFilename(result.quiz.title)}_Guide.pdf';
      await Printing.sharePdf(bytes: bytes, filename: filename);
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to generate PDF. Please try again.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  pw.Widget _buildSwissHeader(
    QuizResult result,
    pw.Font fontBold,
    pw.Font fontRegular,
    PdfColor textDark,
    PdfColor textLight,
    PdfColor primaryBlue,
  ) {
    final dateStr = _formatDate(DateTime.now());
    final metaString =
        '${result.quiz.category.toUpperCase()}   •   ${result.quiz.questions.length} QUESTIONS   •   $dateStr';

    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 15),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColor.fromInt(0xFFE5E7EB), width: 1),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  result.quiz.title,
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 24,
                    color: textDark,
                    lineSpacing: 1.1,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  metaString,
                  style: pw.TextStyle(
                    font: fontRegular,
                    fontSize: 9,
                    color: textLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 20),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                '${result.percentage.toInt()}%',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 40,
                  color: textDark,
                  lineSpacing: 0.8,
                ),
              ),
              pw.Text(
                'SCORE',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 8,
                  color: textLight,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSwissQuestion(
    QuizQuestion q,
    int index,
    UserAnswer userAnswer,
    pw.Font fontRegular,
    pw.Font fontBold,
    pw.Font fontItalic,
    PdfColor textDark,
    PdfColor textLight,
    PdfColor successBg,
    PdfColor successBorder,
    PdfColor accentColor,
  ) {
    // Determine if the user's answer is correct
    final isSkipped =
        userAnswer.selectedOptionIndex == -1 &&
        userAnswer.selectedIndices.isEmpty;

    bool isAnswerCorrect = false;
    if (!isSkipped) {
      if (q.type == QuizQuestionType.multiple) {
        final userSet = userAnswer.selectedIndices.toSet();
        final correctSet = q.correctIndices.toSet();
        isAnswerCorrect =
            userSet.length == correctSet.length &&
            userSet.containsAll(correctSet);
      } else {
        isAnswerCorrect =
            userAnswer.selectedOptionIndex == q.correctOptionIndex;
      }
    }

    // Colors for status
    final PdfColor errorBg = PdfColor.fromInt(0xFFFEF2F2);
    final PdfColor errorBorder = PdfColor.fromInt(0xFFEF4444);
    final PdfColor skippedBg = PdfColor.fromInt(0xFFF9FAFB);
    final PdfColor skippedBorder = PdfColor.fromInt(0xFF9CA3AF);

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Question number with status indicator
        pw.Container(
          width: 28,
          padding: const pw.EdgeInsets.only(top: 1),
          child: pw.Column(
            children: [
              pw.Text(
                '${index + 1}.',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 11,
                  color: isSkipped
                      ? skippedBorder
                      : isAnswerCorrect
                      ? successBorder
                      : errorBorder,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Question text with status badge
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      q.question,
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 11,
                        color: textDark,
                        lineSpacing: 1.3,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  // Status badge
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: pw.BoxDecoration(
                      color: isSkipped
                          ? skippedBg
                          : isAnswerCorrect
                          ? successBg
                          : errorBg,
                      borderRadius: pw.BorderRadius.circular(4),
                      border: pw.Border.all(
                        color: isSkipped
                            ? skippedBorder
                            : isAnswerCorrect
                            ? successBorder
                            : errorBorder,
                        width: 0.5,
                      ),
                    ),
                    child: pw.Text(
                      isSkipped
                          ? 'SKIPPED'
                          : isAnswerCorrect
                          ? 'CORRECT'
                          : 'INCORRECT',
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 6,
                        color: isSkipped
                            ? skippedBorder
                            : isAnswerCorrect
                            ? successBorder
                            : errorBorder,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              // Options
              pw.Column(
                children: List.generate(q.options.length, (optIndex) {
                  final isCorrectOption = (q.type == QuizQuestionType.multiple)
                      ? q.correctIndices.contains(optIndex) ||
                            (q.correctIndices.isEmpty &&
                                q.correctOptionIndex == optIndex)
                      : q.correctOptionIndex == optIndex;

                  final isUserSelected = (q.type == QuizQuestionType.multiple)
                      ? userAnswer.selectedIndices.contains(optIndex)
                      : userAnswer.selectedOptionIndex == optIndex;

                  // Determine option styling
                  PdfColor? bgColor;
                  PdfColor textColor = textDark;
                  pw.Font font = fontRegular;

                  if (isCorrectOption) {
                    bgColor = successBg;
                    textColor = PdfColor.fromInt(0xFF065F46);
                    font = fontBold;
                  } else if (isUserSelected && !isCorrectOption) {
                    bgColor = errorBg;
                    textColor = PdfColor.fromInt(0xFF991B1B);
                    font = fontRegular;
                  }

                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 4),
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 8,
                    ),
                    decoration: (bgColor != null)
                        ? pw.BoxDecoration(
                            color: bgColor,
                            borderRadius: pw.BorderRadius.circular(4),
                          )
                        : const pw.BoxDecoration(),
                    child: pw.Row(
                      children: [
                        // Option indicator
                        pw.Container(
                          width: 14,
                          height: 14,
                          decoration: pw.BoxDecoration(
                            shape: pw.BoxShape.circle,
                            color: isCorrectOption
                                ? successBorder
                                : isUserSelected
                                ? errorBorder
                                : PdfColor.fromInt(0xFFE5E7EB),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              isCorrectOption
                                  ? '✓'
                                  : isUserSelected
                                  ? '✗'
                                  : '',
                              style: pw.TextStyle(
                                color: (isCorrectOption || isUserSelected)
                                    ? PdfColors.white
                                    : textLight,
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                          child: pw.Text(
                            q.options[optIndex],
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 9,
                              color: textColor,
                            ),
                          ),
                        ),
                        // Label for user selection or correct answer
                        if (isUserSelected && !isCorrectOption)
                          pw.Text(
                            'Your answer',
                            style: pw.TextStyle(
                              font: fontRegular,
                              fontSize: 7,
                              color: errorBorder,
                            ),
                          ),
                        if (isCorrectOption)
                          pw.Text(
                            isUserSelected ? '✓ Correct' : 'Correct answer',
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 7,
                              color: successBorder,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
              // Explanation
              if (q.explanation.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 3,
                      height: 40,
                      color: textLight.shade(0.3),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Explanation',
                            style: pw.TextStyle(
                              font: fontBold,
                              fontSize: 8,
                              color: textLight,
                            ),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            q.explanation,
                            style: pw.TextStyle(
                              font: fontItalic,
                              fontSize: 9,
                              color: textLight,
                              lineSpacing: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfFooter(
    pw.Context context,
    pw.Font fontRegular,
    pw.Font fontMedium,
    PdfColor textSecondary,
    PdfColor divider,
  ) {
    final PdfColor primaryBlue = PdfColor.fromInt(0xFF1E40AF);

    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      padding: const pw.EdgeInsets.only(top: 15),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: divider, width: 1)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Google Play Badge Style
          pw.Row(
            children: [
              // Play Store Icon (Triangle)
              pw.Container(
                width: 20,
                height: 20,
                decoration: pw.BoxDecoration(
                  color: primaryBlue,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Center(
                  child: pw.Text(
                    '▶',
                    style: pw.TextStyle(color: PdfColors.white, fontSize: 10),
                  ),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'GET IT ON',
                    style: pw.TextStyle(
                      font: fontMedium,
                      fontSize: 6,
                      color: textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  pw.Text(
                    'Google Play',
                    style: pw.TextStyle(
                      font: fontMedium,
                      fontSize: 10,
                      color: PdfColor.fromInt(0xFF111827),
                    ),
                  ),
                ],
              ),
              pw.Container(
                height: 16,
                width: 1,
                margin: const pw.EdgeInsets.symmetric(horizontal: 12),
                color: divider,
              ),
              pw.UrlLink(
                destination:
                    'https://play.google.com/store/apps/details?id=dev.akhlasahmed.rapidval',
                child: pw.Text(
                  'RapidVal',
                  style: pw.TextStyle(
                    font: fontMedium,
                    fontSize: 11,
                    color: primaryBlue,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
          // Page number
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(
              font: fontRegular,
              color: PdfColors.grey400,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  String _getUserAnswerText(QuizQuestion q, UserAnswer answer) {
    if (answer.selectedOptionIndex != -1) {
      return q.options[answer.selectedOptionIndex];
    } else if (answer.selectedIndices.isNotEmpty) {
      return answer.selectedIndices.map((idx) => q.options[idx]).join(', ');
    }
    return 'No answer';
  }

  String _getCorrectAnswerText(QuizQuestion q) {
    if (q.type == QuizQuestionType.multiple) {
      return q.correctIndices.map((idx) => q.options[idx]).join(', ');
    }
    return q.options[q.correctOptionIndex];
  }

  bool _checkIfCorrect(QuizQuestion q, UserAnswer answer) {
    if (q.type == QuizQuestionType.multiple) {
      final userSet = answer.selectedIndices.toSet();
      final correctSet = q.correctIndices.toSet();
      return userSet.length == correctSet.length &&
          userSet.containsAll(correctSet);
    }
    return answer.selectedOptionIndex == q.correctOptionIndex;
  }

  String _formatDuration(Duration d) {
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes % 60}m';
    if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds % 60}s';
    return '${d.inSeconds}s';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _sanitizeFilename(String filename) {
    final sanitized = filename
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_');
    return sanitized.substring(
      0,
      sanitized.length > 50 ? 50 : sanitized.length,
    );
  }

  void _showExplanationBottomSheet(
    BuildContext context,
    QuizQuestion question,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.3,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 16,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.5,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'QUESTION',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question.question,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF22C55E,
                          ).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(
                              0xFF22C55E,
                            ).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF22C55E),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Correct Answer',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: const Color(0xFF16A34A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...() {
                              final correctIndices =
                                  question.type == QuizQuestionType.multiple
                                  ? question.correctIndices
                                  : [question.correctOptionIndex];
                              return correctIndices.map(
                                (index) => Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    bottom: 4,
                                  ),
                                  child: Text(
                                    question.options[index],
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              );
                            }(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_rounded,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Insight',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              question.explanation.isNotEmpty
                                  ? question.explanation
                                  : 'No additional insight provided.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.quizResult;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: theme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
        title: Text(
          'Quiz Summary',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
            letterSpacing: 0.3,
          ),
        ),
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: IconButton(
              onPressed: () {
                if (widget.returnPath != null) {
                  context.go(widget.returnPath!);
                } else {
                  context.go('/dashboard');
                }
              },
              icon: const Icon(Icons.close, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                foregroundColor: colorScheme.onSurface,
                fixedSize: const Size(40, 40),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: _isSharing ? null : _showShareOptions,
              icon: _isSharing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                      ),
                    )
                  : const Icon(Icons.share_rounded, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                foregroundColor: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: -10000,
            top: -10000,
            child: RepaintBoundary(
              key: _shareCardKey,
              child: _ShareableResultCard(result: result),
            ),
          ),
          Container(
            color: colorScheme.surface,
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).padding.top + 70,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _ResultSummaryCard(result: result)
                                .animate()
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  duration: 600.ms,
                                  curve: Curves.easeOutBack,
                                )
                                .fadeIn(duration: 400.ms),
                          ),
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Text(
                                  'Detailed Breakdown',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                    letterSpacing: 1,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer
                                        .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${result.correctAnswers}/${result.totalQuestions} Correct',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            itemCount: result.quiz.questions.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final question = result.quiz.questions[index];
                              final userAnswer = result.answers.firstWhere(
                                (a) => a.questionIndex == index,
                                orElse: () => UserAnswer(
                                  questionIndex: index,
                                  selectedOptionIndex: -1,
                                  answeredAt: DateTime.now(),
                                ),
                              );
                              final isSkipped =
                                  userAnswer.selectedOptionIndex == -1 &&
                                  userAnswer.selectedIndices.isEmpty;
                              bool isCorrect = false;
                              if (!isSkipped)
                                isCorrect = _checkIfCorrect(
                                  question,
                                  userAnswer,
                                );
                              return QuestionResultTile(
                                    index: index,
                                    question: question,
                                    userAnswer: userAnswer,
                                    isCorrect: isCorrect,
                                    isSkipped: isSkipped,
                                    onTap: () => _showExplanationBottomSheet(
                                      context,
                                      question,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(
                                    delay: Duration(
                                      milliseconds: 200 + (index * 50),
                                    ),
                                    duration: 400.ms,
                                  )
                                  .slideX(
                                    begin: 0.1,
                                    end: 0,
                                    delay: Duration(
                                      milliseconds: 200 + (index * 50),
                                    ),
                                    curve: Curves.easeOutCubic,
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  _ActionDock(
                        onReview: () {
                          context.push(
                            '/quiz',
                            extra: {
                              'quizResult': result,
                              'isReviewMode': true,
                              'returnPath': widget.returnPath,
                            },
                          );
                        },
                        onRetake: () => context.pushReplacement(
                          '/quiz-setup',
                          extra: result.quiz,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 600.ms)
                      .slideY(begin: 1, end: 0, curve: Curves.easeOutCubic),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ... (Rest of the file: _ResultSummaryCard, _ActionDock, _ShareableResultCard, _ShareOptionTile remain exactly as they were in the previous complete response)

class _ResultSummaryCard extends StatelessWidget {
  final QuizResult result;
  const _ResultSummaryCard({required this.result});
  Color _getScoreColor() {
    if (result.percentage >= 80) return const Color(0xFF22C55E);
    if (result.percentage >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String _getMessage() {
    if (result.percentage >= 90) return 'Outstanding!';
    if (result.percentage >= 80) return 'Great Job!';
    if (result.percentage >= 60) return 'Good Effort';
    return 'Keep Practicing';
  }

  @override
  Widget build(BuildContext context) {
    final scoreColor = _getScoreColor();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getMessage(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quiz completed in ${_formatDuration(result.completedAt.difference(result.startedAt))}.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: 1.0,
                        color: scoreColor.withValues(alpha: 0.1),
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: result.percentage / 100),
                      duration: 1500.ms,
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: value,
                          color: scoreColor,
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: result.percentage),
                      duration: 1500.ms,
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${value.toInt()}%',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: scoreColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.inMinutes > 0) return '${d.inMinutes}m ${d.inSeconds % 60}s';
    return '${d.inSeconds}s';
  }
}

class _ActionDock extends StatelessWidget {
  final VoidCallback onReview;
  final VoidCallback onRetake;
  const _ActionDock({required this.onReview, required this.onRetake});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppOutlinedButton(
              onPressed: onReview,
              text: 'Review',
              icon: const Icon(Icons.visibility_outlined, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AppButton(
              onPressed: onRetake,
              text: 'Retake',
              icon: const Icon(Icons.refresh_rounded, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareableResultCard extends StatelessWidget {
  final QuizResult result;
  const _ShareableResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scoreColor = _getScoreColor(result.percentage);

    return Container(
      width: 450,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(color: colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Text(
            result.quiz.category.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            result.quiz.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.15,
              letterSpacing: -0.3,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: 36,
            height: 3,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 36),

          // Score (intentionally centered)
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 12,
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.35,
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: result.percentage / 100,
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round,
                    color: scoreColor,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${result.percentage.toInt()}%',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: scoreColor,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SCORE',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Stats
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: scoreColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  '${result.correctAnswers}/${result.totalQuestions} Correct',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scoreColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Can you beat my score?',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),

          // Footer
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesomeIcons.googlePlay,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GET IT ON',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 7,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        'Google Play',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 16,
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  Text(
                    'RapidVal',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.primary,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return const Color(0xFF22C55E);
    if (percentage >= 60) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }
}

class _ShareOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _ShareOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
