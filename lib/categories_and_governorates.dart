import 'package:flutter/material.dart';
import './models/category.dart';
import './models/comment.dart';

// ignore: constant_identifier_names
const DUMMY_CATEGORIES = [
  Category(title: 'نقاشة', img: Icons.format_paint_rounded),
  Category(title: 'ميكانيكا سيارات', img: Icons.car_repair_outlined),
  Category(title: 'كهرباء', img: Icons.electrical_services),
  Category(title: 'تكييف وتبريد', img: Icons.ac_unit),
  Category(title: 'ألوميتال', img: Icons.sensor_window_rounded),
  Category(title: 'تركيب أرضيات', img: Icons.home),
  Category(title: 'أنظمة دش', img: Icons.satellite),
  Category(title: 'تصليح أدوات منزلية', img: Icons.home_repair_service),
  Category(title: 'نقل ورفع الموبيليا', img: Icons.bedroom_parent),
  Category(title: 'قطر السيارات', img: Icons.emoji_transportation),
  Category(title: 'سمكرة سيارات', img: Icons.car_repair),
  Category(title: 'أنظمة صوت', img: Icons.speaker),
  Category(title: 'سباكة', img: Icons.plumbing),
  Category(title: 'نجارة', img: Icons.handyman),
];

// ignore: non_constant_identifier_names
final CITIES = [
  'الإسكندرية',
  'الإسماعيلية',
  'أسوان',
  'أسيوط',
  'الأقصر',
  'البحر الأحمر',
  'البحيرة',
  'بني سويف',
  'بورسعيد',
  'جنوب سيناء',
  'الجيزة',
  'الدقهلية',
  'دمياط',
  'سوهاج',
  'السويس',
  'الشرقية',
  'شمال سيناء',
  'الغربية',
  'الفيوم',
  'القاهرة',
  'القليوبية',
  'قنا',
  'كفر الشيخ',
  'مطروح',
  'المنوفية',
  'المنيا',
  'الوادي الجديد'
];

// ignore: non_constant_identifier_names
List<Comment> DUMMY_COMMENTS = [];
