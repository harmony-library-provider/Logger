import { hilog } from "@kit.PerformanceAnalysisKit"
import { LogEvent } from "../abstract/output"

export abstract class Filter {
  public level: hilog.LogLevel = hilog.LogLevel.DEBUG

  async init(): Promise<void> {
  }

  async destroy(): Promise<void> {
  }

  public should(_: LogEvent): boolean {
    throw new Error('Not implemented')
  }
}
