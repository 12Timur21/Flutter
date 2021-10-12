class PaperTray {
  int _paperAmount;
  int get paperAmount => _paperAmount;

  PaperTray(this._paperAmount);

  void activatePaperFeed() {
    print('Бумага начинает подаваться в принтер');
  }
}

class PaintStorage {
  int _amountBlackPaint;
  int get amountBlackPaint => _amountBlackPaint;

  PaintStorage(this._amountBlackPaint);

  void submitPaint() {
    print('Чёрная краска подаётся в принтер');
  }
}

class Sensors {
  bool checkPaperAvailability(PaperTray paperTray) {
    if (paperTray.paperAmount == 0) {
      return false;
    }
    return true;
  }

  bool checkPaintStorage(PaintStorage paintStorage) {
    if (paintStorage.amountBlackPaint == 0) {
      return false;
    }
    return true;
  }
}

class PrinterLaser {
  void activatePrinterLaser() {
    print('Лазер вырисовывает текст...');
  }
}

class Printer {
  PaperTray _paperTray = PaperTray(10);
  PaintStorage _paintStorage = PaintStorage(25);
  Sensors _printerSensors = Sensors();
  PrinterLaser _printerLaser = PrinterLaser();

  bool checkSystems() {
    if (!_printerSensors.checkPaperAvailability(_paperTray)) {
      print('В принтере закончилась бумага!');
      return false;
    } else if (!_printerSensors.checkPaintStorage(_paintStorage)) {
      print('В принтере закончиалсь чёрная краска');
      return false;
    }
    return true;
  }

  void printText() {
    if (checkSystems()) {
      _paperTray.activatePaperFeed();
      _paintStorage.submitPaint();
      _printerLaser.activatePrinterLaser();
      print('Идёт печать');
    }
  }
}

void main() {
  Printer printer = Printer();
  printer.printText();
}
