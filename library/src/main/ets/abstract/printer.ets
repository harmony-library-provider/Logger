import { hilog } from "@kit.PerformanceAnalysisKit";
import { LogEvent } from "../abstract/output";

export interface IFormatOptions {
  level: hilog.LogLevel;
  message?: string;
  stack?: string;
  error?: string;
  time?: string;
}

export abstract class Printer {
  async init(): Promise<void> {
  }

  async destroy(): Promise<void> {
  }

  public print(_: LogEvent): string[] {
    throw new Error('No implemented')
  }
}
