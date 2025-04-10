import { hilog } from "@kit.PerformanceAnalysisKit";

export class levels {
  static info = hilog.LogLevel.INFO;
  static warn = hilog.LogLevel.WARN;
  static debug = hilog.LogLevel.DEBUG;
  static error = hilog.LogLevel.ERROR;
  static fatal = hilog.LogLevel.FATAL;

  static proxy(level: hilog.LogLevel) {
    switch (level) {
      case levels.info: {
        return hilog.info
      }

      case levels.warn: {
        return hilog.warn
      }

      case levels.debug: {
        return hilog.debug
      }

      case levels.error: {
        return hilog.error
      }

      case levels.fatal: {
        return hilog.fatal
      }

      default: {
        return
      }
    }
  }

  static label(level: hilog.LogLevel) {
    switch (level) {
      case levels.info:
        return 'Info'

      case levels.warn:
        return 'Warn'

      case levels.debug:
        return 'Debug'

      case levels.error:
        return 'Error'

      case levels.fatal:
        return 'Fatal'

      default:
        return ''
    }
  }

  static check(level: hilog.LogLevel) {
    return (
      level === levels.info ||
        level === levels.warn ||
        level === levels.warn ||
        level === levels.error ||
        level === levels.fatal
    )
  }

  static every(fn: (level: hilog.LogLevel) => void) {
    if (typeof fn === 'function') {
      fn(levels.info)
      fn(levels.warn)
      fn(levels.debug)
      fn(levels.error)
      fn(levels.fatal)
    }
  }
}
