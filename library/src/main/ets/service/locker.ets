export class AsyncMutex {
  private locked: boolean = false
  private queues: Array<() => void> = []

  public async synchronized<T = void>(fn: () => T | Promise<T>): Promise<T> {
    await this.acquire()

    try {
      return await fn()
    } finally {
      this.release()
    }
  }

  public async acquire(): Promise<void> {
    return new Promise<void>((resolve) => {
      if (!this.locked) {
        this.locked = true
        resolve()
        return
      }

      this.queues.push(resolve)
    })
  }

  public release(): void {
    this.queues.length > 0 ? this.queues.shift()?.() : this.locked = false
  }
}
