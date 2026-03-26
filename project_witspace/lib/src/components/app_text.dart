import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../widgets/extensions.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const AppText(
    this.text, {
    super.key,
    required this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  factory AppText.displayLg(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);
  
  factory AppText.displayMd(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);
  
  factory AppText.headingLg(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);
  
  factory AppText.headingMd(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);
  
  factory AppText.sectionLabel(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);
  
  factory AppText.bodyMd(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 16, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);
  
  factory AppText.bodySm(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 14, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);
  
  factory AppText.bodyXs(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 12, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);
  
  factory AppText.label(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);
  
  factory AppText.labelSm(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);
  
  factory AppText.caption(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 12, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);
  
  factory AppText.statValue(String text, {Color? color, TextAlign? textAlign, TextOverflow? overflow, int? maxLines}) => 
    AppText(text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color), textAlign: textAlign, overflow: overflow, maxLines: maxLines);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(color: style.color ?? context.colors.textPrimary),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
