export type VoidCallback = () => void

export abstract class ChangeNotifier {
  private _listeners: Set<VoidCallback> = new Set()

  addListener(listener: VoidCallback): void {
    this._listeners.add(listener)
  }

  removeListener(listener: VoidCallback): void {
    this._listeners.delete(listener)
  }

  notifyListeners(): void {
    this._listeners.forEach(listener => listener())
  }

  dispose(): void {
    this._listeners.clear()
  }
}
