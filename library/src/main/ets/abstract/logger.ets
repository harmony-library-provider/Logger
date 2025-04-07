import { Output } from "../abstract/output";
import { Filter } from "../abstract/filter";
import { Printer } from "../abstract/printer";
import { LogEvent } from "../abstract/output";
import { ILogEvent } from "../abstract/output";
import { OutputEvent } from "../abstract/output";
import { hilog } from "@kit.PerformanceAnalysisKit";

export type OutputCallback = (event: OutputEvent) => void

export type LogCallback = (event: LogEvent) => void

export abstract class Logger {
  private isReady: Promise<ESObject>;
  private active: boolean = false;
  public printer: Printer;
  public output: Output;
  public filter: Filter;

  async init() {
    return this.isReady
  }

  async close() {
    this.active = false;
    await this.output.destroy();
    await this.filter.destroy();
    await this.printer.destroy();
  }

  public isClosed() {
    return !this.active;
  }

  constructor(options: ILogger) {
    this.filter = options.filter
    this.output = options.output
    this.printer = options.printer

    if (options.level) {
      this.filter.level = options.level
    }

    const promise = Promise.all([this.printer.init(), this.output.init(), this.filter.init()])
    this.isReady = promise.then(() => this.active = true)
  }

  public async info(message: ESObject, error?: ESObject, stack?: ESObject): Promise<void> {
    return this.log({
      time: new Date(),
      level: hilog.LogLevel.INFO,
      message: message,
      error: error,
      stack: stack,
    })
  }

  public async warn(message: ESObject, error?: ESObject, stack?: ESObject): Promise<void> {
    return this.log({
      time: new Date(),
      level: hilog.LogLevel.WARN,
      message: message,
      error: error,
      stack: stack,
    })
  }

  public async debug(message: ESObject, error?: ESObject, stack?: ESObject): Promise<void> {
    return this.log({
      time: new Date(),
      level: hilog.LogLevel.DEBUG,
      message: message,
      error: error,
      stack: stack,
    })
  }

  public async error(message: ESObject, error?: ESObject, stack?: ESObject): Promise<void> {
    return this.log({
      time: new Date(),
      level: hilog.LogLevel.ERROR,
      message: message,
      error: error,
      stack: stack,
    })
  }

  public async fatal(message: ESObject, error?: ESObject, stack?: ESObject): Promise<void> {
    return this.log({
      time: new Date(),
      level: hilog.LogLevel.FATAL,
      message: message,
      error: error,
      stack: stack,
    })
  }

  public async log(options: ILogEvent): Promise<void> {
    await this.init()

    if (!this.active) {
      throw new Error('Logger has already been closed.');
    }

    const logEvent = new LogEvent({
      time: options.time,
      level: options.level,
      message: options.message,
      error: options.error,
      stack: options.stack,
    });

    if (this.filter.should(logEvent)) {
      const output = this.printer.print(logEvent);

      if (output.length > 0) {
        const outputEvent = new OutputEvent(
          logEvent,
          output
        );

        try {
          this.output.output(outputEvent);
        } catch (e) {
          /* e */
        }
      }
    }
  }
}

export interface ILogger {
  level?: hilog.LogLevel,
  filter: Filter,
  output: Output,
  printer: Printer,
}
