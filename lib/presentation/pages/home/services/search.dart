import 'dart:ui';

  /// 🧠 تحويل اللون إلى اسم تقريبي (يغطي معظم الألوان الشائعة)
  String approxColorName(Color color) {
    int r = color.red;
    int g = color.green;
    int b = color.blue;

    // 🔴 الأحمر
    if (r > 180 && g < 80 && b < 80) return 'red';

    // 🟠 البرتقالي
    if (r > 200 && g > 100 && g < 180 && b < 80) return 'orange';

    // 🟡 الأصفر
    if (r > 200 && g > 200 && b < 100) return 'yellow';

    // 🟢 الأخضر
    if (g > 150 && r < 120 && b < 120) return 'green';

    // 🟢 فاتح (ليموني)
    if (r > 170 && g > 220 && b < 120) return 'lime';

    // 🔵 الأزرق
    if (b > 160 && r < 100 && g < 140) return 'blue';

    // 🩵 السماوي (أزرق فاتح)
    if (b > 180 && g > 180 && r < 120) return 'cyan';

    // 🟣 البنفسجي
    if (r > 150 && b > 150 && g < 100) return 'purple';

    // 💜 الموف
    if (r > 180 && b > 180 && g < 150) return 'violet';

    // 💗 الوردي
    if (r > 220 && g < 180 && b > 200) return 'pink';

    // 🟤 البني
    if (r > 100 && g > 60 && b < 40) return 'brown';

    // ⚫ الأسود
    if (r < 50 && g < 50 && b < 50) return 'black';

    // ⚪ الأبيض
    if (r > 230 && g > 230 && b > 230) return 'white';

    // ⚙️ الرمادي
    if ((r - g).abs() < 20 && (g - b).abs() < 20) {
      if (r > 180) return 'light gray';
      if (r > 100) return 'gray';
      return 'dark gray';
    }

    // 🎨 fallback
    return 'other';
  }
