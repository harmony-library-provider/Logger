import { Filter } from '../abstract/filter';
import { LogEvent } from '../abstract/output';
import { hilog } from '@kit.PerformanceAnalysisKit';

export interface ISafeFilter {
  level?: hilog.LogLevel
}

export class SafeFilter extends Filter {
  public level: hilog.LogLevel = hilog.LogLevel.DEBUG

  constructor(options: ISafeFilter = {}) {
    super()
    this.level = options.level ?? this.level
  }

  should(event: LogEvent) {
    return event.level >= this.level;
  }
}
