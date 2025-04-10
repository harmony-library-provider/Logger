import { hilog } from "@kit.PerformanceAnalysisKit";

export abstract class Output {
  async init(): Promise<void> {
  }

  async destroy(): Promise<void> {
  }

  public output(_: OutputEvent): void {
    throw new Error('No implemented')
  }
}

export interface ILogEvent {
  time: Date;
  level: hilog.LogLevel;
  message?: Object;
  error?: Object;
  stack?: Object;
}

export class OutputEvent {
  lines: string[];
  origin: LogEvent;

  public get level() {
    return this.origin.level;
  }

  constructor(origin: LogEvent, lines: string[]) {
    this.origin = origin
    this.lines = lines
  };
}

export class LogEvent {
  time: Date;
  level: hilog.LogLevel = hilog.LogLevel.DEBUG;
  message?: Object;
  error?: Object;
  stack?: Object;

  constructor(options: ILogEvent) {
    this.time = options.time
    this.level = options.level ?? this.level
    this.message = options.message ?? this.message
    this.error = options.error ?? this.error
    this.stack = options.stack ?? this.stack
  }
}
