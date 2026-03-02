import 'dart:ui';

  String approxColorName(Color color) {
    int r = color.red;
    int g = color.green;
    int b = color.blue;

    if (r > 180 && g < 80 && b < 80) return 'red';

    if (r > 200 && g > 100 && g < 180 && b < 80) return 'orange';

    if (r > 200 && g > 200 && b < 100) return 'yellow';

    if (g > 150 && r < 120 && b < 120) return 'green';

    if (r > 170 && g > 220 && b < 120) return 'lime';

    if (b > 160 && r < 100 && g < 140) return 'blue';

    if (b > 180 && g > 180 && r < 120) return 'cyan';

    if (r > 150 && b > 150 && g < 100) return 'purple';

    if (r > 180 && b > 180 && g < 150) return 'violet';

    if (r > 220 && g < 180 && b > 200) return 'pink';

    if (r > 100 && g > 60 && b < 40) return 'brown';

    if (r < 50 && g < 50 && b < 50) return 'black';

    if (r > 230 && g > 230 && b > 230) return 'white';

    if ((r - g).abs() < 20 && (g - b).abs() < 20) {
      if (r > 180) return 'light gray';
      if (r > 100) return 'gray';
      return 'dark gray';
    }

    return 'other';
  }
