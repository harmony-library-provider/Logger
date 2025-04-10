import { levels } from '../service/level'
import { Printer } from '../abstract/printer';
import { LogEvent } from "../abstract/output";
import { hilog } from "@kit.PerformanceAnalysisKit";
import { IFormatOptions } from '../abstract/printer';

export interface ISafePrettyPrinter {
  excludeBox?: Map<hilog.LogLevel, boolean>;
  includeBox?: Map<hilog.LogLevel, boolean>;
  stackTraceBeginIndex?: number;
  noBoxingByDefault?: boolean;
  errorMethodCount?: number;
  methodCount?: number;
  lineLength?: number;
  minifyCode?: boolean;
  printTime?: boolean;
}

export interface ISafeHybridPrinter {
  info?: Printer;
  warn?: Printer;
  debug?: Printer;
  error?: Printer;
  fatal?: Printer;
}

export class SafePrettyPrinter extends Printer {
  static readonly middleCorner = '├';
  static readonly singleDivider = '┄';
  static readonly doubleDivider = '─';
  static readonly topLeftCorner = '┌';
  static readonly verticalCorner = '│';
  static readonly bottomLeftCorner = '└';
  static readonly startDate = new Date();
  includeBox: Map<hilog.LogLevel, boolean> = new Map();
  excludeBox: Map<hilog.LogLevel, boolean> = new Map();
  stackTraceBeginIndex: number = 0
  noBoxingByDefault: boolean = false
  errorMethodCount: number = 10
  methodCount: number = 5;
  lineLength: number = 80;
  printTime: boolean = true
  minifyCode: boolean = false
  _bottomBorder: string = '';
  _middleBorder: string = '';
  _topBorder: string = '';

  constructor(options: ISafePrettyPrinter = {}) {
    super()

    this.printTime = options.printTime ?? this.printTime
    this.minifyCode = options.minifyCode ?? this.minifyCode
    this.lineLength = options.lineLength ?? this.lineLength
    this.methodCount = options.methodCount ?? this.methodCount
    this.errorMethodCount = options.errorMethodCount ?? this.errorMethodCount
    this.noBoxingByDefault = options.noBoxingByDefault ?? this.noBoxingByDefault
    this.stackTraceBeginIndex = options.stackTraceBeginIndex ?? this.stackTraceBeginIndex

    const singleDivider = SafePrettyPrinter.singleDivider.repeat(this.lineLength)
    const doubleDivider = SafePrettyPrinter.doubleDivider.repeat(this.lineLength)

    this._bottomBorder = `${SafePrettyPrinter.bottomLeftCorner}${doubleDivider}`;
    this._middleBorder = `${SafePrettyPrinter.middleCorner}${singleDivider}`;
    this._topBorder = `${SafePrettyPrinter.topLeftCorner}${doubleDivider}`;

    if (SafePrettyPrinter.startDate.getTime() > 0) {
    }

    if (this.includeBox instanceof Map) {
      levels.every((level: ESObject) => this.includeBox[level] = !this.noBoxingByDefault)
    }

    if (options.includeBox) {
      for (const ref of options.includeBox) {
        const key = ref[0]
        const state = ref[1]

        if (levels.check(key)) {
          this.includeBox[key] = !!state;
        }
      }
    }

    if (options.excludeBox) {
      for (const ref of options.excludeBox) {
        const key = ref[0]
        const state = ref[1]

        if (levels.check(key)) {
          this.includeBox[key] = !state;
        }
      }
    }
  }

  discardStacktrace(line?: string | undefined | null): boolean {
    return !line;
  }

  formatStackTrace(stack: Object | null, methodCount: number): string | null {
    const lines = stack?.toString().split('\n') ?? [];
    const traces = [...lines.filter((line) => !this.discardStacktrace(line))];
    const formatted: string[] = [];

    for (let count = 0; count < Math.min(traces.length, methodCount); count++) {
      const line = traces[count];

      if (count < this.stackTraceBeginIndex) {
        continue;
      }

      if (!new RegExp('^\\S+').test(line)) {
        formatted.push(`#${count}${line.replace(/^#\d+\s+/, '')}`);
      }

      if (new RegExp('^\\S+').test(line)) {
        formatted.push(`#${count} ${line.replace(/^#\d+\s+/, '')}`);
      }
    }

    if (formatted.length > 0) {
      return formatted.join('\n');
    }

    return null;
  }

  formatSerialize(message?: Object): Object | undefined | null {
    if (message instanceof Set) {
      return Object({ __type__: 'Set', __value__:  Array.from(message) })
    }

    if (message instanceof Map) {
      return Object({
        __type__: 'Map',
        __value__: Array.from(message, (arr: [string, Object]) => {
          const obj: Record<string, Object> = Object({})
          const val: Object = arr[1]
          const key: string = arr[0]
          obj[key] = val
          return obj
        })[0]
      })
    }

    return message
  }

  formatMessage(message?: Object): string | null {
    const replacer = (_: string, v: object) => this.formatSerialize(v)

    if (message === undefined || message === null) {
      return null;
    }

    if (typeof message === 'function') {
      message = message()
    }

    if (typeof message === 'number') {
      return `${message}`
    }

    if (typeof message === 'string') {
      return `${message}`
    }

    if (typeof message === 'object') {
      return JSON.stringify(message, replacer, !this.minifyCode ? 2 : undefined)
    }

    return null;
  }

  formatError(error?: Object): string | null {
    if (error != undefined && error != null) {
      return error.toString();
    }

    return null;
  }

  formater(options: IFormatOptions) {
    let border = false;

    const time = options.time
    const level = options.level
    const stack = options.stack
    const error = options.error
    const message = options.message

    const verticalLine: string = this.includeBox[level] == true ? `${SafePrettyPrinter.verticalCorner} ` : '';
    const included: boolean = this.includeBox[level] == true;
    const buffer: string[] = [];

    if (included) {
      buffer.push(this._topBorder);
    }

    if (time != null) {
      buffer.push(`${verticalLine}${levels.label(level)} | ${time}`);
      border = true;
    }

    if (!!message) {
      if (border && included) {
        buffer.push(this._middleBorder);
      }

      for (const line of message.split('\n')) {
        buffer.push(`${verticalLine}${line}`);
      }

      border = true;
    }

    if (!!error) {
      if (border && included) {
        buffer.push(this._middleBorder);
      }

      for (const line of error.split('\n')) {
        buffer.push(`${verticalLine}${line}`);
      }

      border = false;
    }

    if (!!stack) {
      if (border && included) {
        buffer.push(this._middleBorder);
      }

      for (const line of stack.split('\n')) {
        buffer.push(`${verticalLine}${line}`);
      }

      border = true;
    }

    if (included) {
      buffer.push(this._bottomBorder);
    }

    if (buffer) {
      buffer.push('')
    }

    return buffer;
  }

  print(origin: LogEvent) {
    let timeStr: string | null = null;
    let stackTraceStr: string | null = null;

    const level = origin.level;
    const isError = level == levels.error;
    const errorStr = this.formatError(origin.error);
    const messageStr = this.formatMessage(origin.message);

    if (origin.stack != null) {
      const count = Math.max(isError ? this.errorMethodCount : this.methodCount, 1);
      stackTraceStr = this.formatStackTrace(origin.stack ?? null, count);
    }

    if (origin.stack == null) {
      const count = Math.max(isError ? this.errorMethodCount : this.methodCount, 1);
      stackTraceStr = this.formatStackTrace(new Error().stack ?? null, count);
    }

    if (this.printTime == true) {
      timeStr = SafeDateTimeFormat.dateTimeAndSinceStart(origin.time);
    }

    const result = this.formater({
      stack: stackTraceStr ?? undefined,
      message: messageStr ?? undefined,
      error: errorStr ?? undefined,
      time: timeStr ?? undefined,
      level: level,
    });

    return result;
  }
}

export class SafeHybridPrinter extends Printer {
  printerMap: Map<hilog.LogLevel, Printer> = new Map();

  constructor(printer: Printer, options: ISafeHybridPrinter = {}) {
    super()
    this.printerMap = new Map([
      [levels.info, options.info ?? printer],
      [levels.warn, options.warn ?? printer],
      [levels.debug, options.debug ?? printer],
      [levels.error, options.error ?? printer],
      [levels.fatal, options.fatal ?? printer],
    ])
  }

  public print(event: LogEvent): string[] {
    return this.printerMap.get(event.level)?.print(event) ?? []
  }
}

export class SafeSimplePrinter extends Printer {
  print(event: LogEvent): string[] {
    let message: Object = event.message != null ? event.message : ''
    let time: string = `[${event.time.toISOString()}] =>`

    if (typeof message === 'function') {
      message = message()
    }

    if (typeof message !== 'string') {
      message = JSON.stringify(message)
    }

    return [`${time} ${message}`]
  }
}

export class SafeDateTimeFormat {
  static dateTimeAndSinceStart(t?: Date): string {
    const now = t ?? new Date();
    const onlyDate = SafeDateTimeFormat.onlyDate
    const onlyTime = SafeDateTimeFormat.onlyTime
    const onlySinceStart = SafeDateTimeFormat.onlySinceStart
    return `${onlyDate(now)} ${onlyTime(now)} (+${onlySinceStart(now)})`;
  }

  static onlyDateAndSinceStart(t?: Date): string {
    const now = t ?? new Date();
    const onlyDate = SafeDateTimeFormat.onlyDate
    const onlySinceStart = SafeDateTimeFormat.onlySinceStart
    return `${onlyDate(now)} (+${onlySinceStart(now)})`;
  }

  static onlyTimeAndSinceStart(t?: Date): string {
    const now = t ?? new Date();
    const onlyTime = SafeDateTimeFormat.onlyTime
    const onlySinceStart = SafeDateTimeFormat.onlySinceStart
    return `${onlyTime(now)} (+${onlySinceStart(now)})`;
  }

  static onlySinceStart(t?: Date): string {
    const now = t?.getTime() ?? Date.now();
    const start = SafePrettyPrinter.startDate.getTime()
    const padStart = (num: number, length: number = 2) => `${num}`.padStart(length, '0')

    if (now <= start) {
      return '00:00:00.000'
    }

    const totalMs = now - start;
    const totalSeconds = Math.floor(totalMs / 1000);
    const totalMinutes = Math.floor(totalSeconds / 60);
    const hours = padStart(Math.floor(totalMinutes / 60), 2);
    const minutes = padStart(totalMinutes % 60, 2);
    const seconds = padStart(totalSeconds % 60, 2);
    const millis = padStart(totalMs % 1000, 3);

    return `${hours}:${minutes}:${seconds}.${millis}`;
  }

  static dateAndTime(t?: Date): string {
    const now = t ?? new Date();
    const onlyDate = SafeDateTimeFormat.onlyDate
    const onlyTime = SafeDateTimeFormat.onlyTime
    return `${onlyDate(now)} ${onlyTime(now)}`;
  }

  static onlyDate(t?: Date): string {
    const now = t ?? new Date();
    const isoDate = now.toISOString()
    return isoDate.substring(0, isoDate.indexOf("T"));
  }

  static onlyTime(t?: Date): string {
    const now = t ?? new Date();

    const twoDigits = (n: number) => {
      return n >= 10 ? `${n}` : `0${n}`;
    }

    const threeDigits = (n: number) => {
      if (n >= 100) {
        return `${n}`;
      }
      if (n >= 10) {
        return `0${n}`;
      }
      return `00${n}`;
    }

    const hour = twoDigits(now.getHours());
    const min = twoDigits(now.getMinutes());
    const sec = twoDigits(now.getSeconds());
    const ms = threeDigits(now.getMilliseconds());

    return `${hour}:${min}:${sec}.${ms}`;
  }
}
