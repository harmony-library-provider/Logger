import { SafeLogger } from './src/main/ets/service/logger'
import { SafeFilter } from './src/main/ets/service/filter'
import { SafeMultiOutput } from './src/main/ets/service/output'
import { SafeConsoleOutput } from './src/main/ets/service/output'
import { SafeWriteFileOutput } from './src/main/ets/service/output'
import { SafePrettyPrinter } from './src/main/ets/service/printer'
import { SafeSimplePrinter } from './src/main/ets/service/printer'
import { SafeHybridPrinter } from './src/main/ets/service/printer'


/**
 * logger
 */
export const logger = new SafeLogger({
  printer: new SafeHybridPrinter(new SafePrettyPrinter(), { debug: new SafeSimplePrinter() }),
  output: new SafeMultiOutput([new SafeConsoleOutput(), new SafeWriteFileOutput()]),
  filter: new SafeFilter(),
})


/**
 * Service
 */
export { Filter } from './src/main/ets/abstract/filter'

export { Printer } from './src/main/ets/abstract/printer'

export { IFormatOptions } from './src/main/ets/abstract/printer'

export { ChangeNotifier } from './src/main/ets/abstract/notifier'

export { VoidCallback } from './src/main/ets/abstract/notifier'

export { OutputEvent } from './src/main/ets/abstract/output'

export { ILogEvent } from './src/main/ets/abstract/output'

export { LogEvent } from './src/main/ets/abstract/output'

export { Output } from './src/main/ets/abstract/output'

export { OutputCallback } from './src/main/ets/abstract/logger'

export { LogCallback } from './src/main/ets/abstract/logger'

export { ILogger } from './src/main/ets/abstract/logger'

export { Logger } from './src/main/ets/abstract/logger'


/**
 * Service
 */
export { SafeChangeNotifier } from './src/main/ets/service/notifier'

export { SafeDateTimeFormat } from './src/main/ets/service/printer'

export { ISafePrettyPrinter } from './src/main/ets/service/printer'

export { ISafeHybridPrinter } from './src/main/ets/service/printer'

export { SafePrettyPrinter } from './src/main/ets/service/printer'

export { SafeHybridPrinter } from './src/main/ets/service/printer'

export { SafeSimplePrinter } from './src/main/ets/service/printer'

export { SafeWriteFileOutput } from './src/main/ets/service/output'

export { SafeConsoleOutput } from './src/main/ets/service/output'

export { SafeMultiOutput } from './src/main/ets/service/output'

export { ISafeFileOutput } from './src/main/ets/service/output'

export { IConsoleOutput } from './src/main/ets/service/output'

export { IRequestFile } from './src/main/ets/service/output'

export { IArrayBuffer } from './src/main/ets/service/output'

export { IString } from './src/main/ets/service/output'

export { ISafeFilter } from './src/main/ets/service/filter'

export { SafeFilter } from './src/main/ets/service/filter'

export { SafeLogger } from './src/main/ets/service/logger'