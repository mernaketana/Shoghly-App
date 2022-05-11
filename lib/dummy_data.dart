import 'package:flutter/material.dart';
import 'package:project/models/image.dart';

import './models/category.dart';
import './models/employee.dart';
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
  // Category(title: 'قطر السيارات' , img: Icon),
  // Category(title: 'سمكرة سيارات' , img: Icons.metal),
  Category(title: 'أنظمة صوت', img: Icons.speaker),
  // Category(title: 'صناعات يدوية' , img: Icons.hand),
  Category(title: 'السباكة', img: Icons.plumbing),
  Category(title: 'النجارة', img: Icons.handyman),
];

// ignore: constant_identifier_names, non_constant_identifier_names
var DUMMY_EMP = [
  Employee(
    id: '1',
    categordId: DUMMY_CATEGORIES
        .firstWhere((element) => element.title == 'السباكة')
        .title,
    image:
        'https://media.angi.com/s3fs-public/plumber-fixing-bathroom-sink-leak.jpg',
    fname: 'احمد',
    lname: 'ابراهيم',
    email: 'ahmed@gmail.com',
    password: '123456789',
    phone: 01234567891,
    location: 'بورسعيد',
    role: 'worker',
  ),
  Employee(
    id: '2',
    image:
        'https://storage.googleapis.com/air-multi-tmbi-cpt-uploads/wp-content/uploads/2020/03/4e43e850-61u5vx9jfvl._ac_sl1000_-1024x1024.jpg',
    fname: 'اسلام',
    lname: 'زين',
    email: 'ahmedd@gmail.com',
    password: '123456789',
    phone: 01234567892,
    location: 'طنطا',
    role: 'client',
  ),
  Employee(
    image:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjGHveD6FYI8wfBYEBx8sKcof9110urFnoAQ&usqp=CAU',
    id: '3',
    categordId: DUMMY_CATEGORIES
        .firstWhere((element) => element.title == 'النجارة')
        .title,
    fname: 'عبدالسميع',
    lname: 'عبدالصمد',
    email: 'ahmeed@gmail.com',
    password: '123456789',
    phone: 01234567893,
    location: 'بورسعيد',
    role: 'worker',
  ),
];

// ignore: non_constant_identifier_names
var DUMMY_COMMENTS = [
  Comment(comment: 'رائع', userId: '2', workerId: '1'),
  Comment(comment: 'جامد', userId: '2', workerId: '1'),
  Comment(comment: 'رائع', userId: '2', workerId: '1'),
  Comment(comment: 'رائع', userId: '2', workerId: '1'),
];

// ignore: non_constant_identifier_names
var DUMMY_IMAGES = [
  MyImage(
      '1',
      [
        'https://3.imimg.com/data3/AQ/LU/MY-9021275/plumber-work-contractor-dwarka-delhi-500x500.jpg',
        'https://adoptostaging.blob.core.windows.net/media/plumber-job-description-template-tQh1-P.jpg',
        'https://previews.123rf.com/images/nenovbrothers/nenovbrothers1811/nenovbrothers181100014/111300956-plumber-working-on-kitchen-sink.jpg',
        'https://previews.123rf.com/images/bvb1981/bvb19811508/bvb1981150800055/43563732-.jpg'
      ],
      '1')
];
