import { ChangeNotifier } from "../abstract/notifier"

export class SafeChangeNotifier extends ChangeNotifier {
  public notifyListeners() {
    super.notifyListeners()
  }
}
