import { SafeLogger } from './src/main/ets/service/logger'
import { SafeFilter } from './src/main/ets/service/filter'
import { SafeMultiOutput } from './src/main/ets/service/output'
import { SafeConsoleOutput } from './src/main/ets/service/output'
import { SafeWriteFileOutput } from './src/main/ets/service/output'
import { SafePrettyPrinter } from './src/main/ets/service/printer'
import { SafeSimplePrinter } from './src/main/ets/service/printer'
import { SafeHybridPrinter } from './src/main/ets/service/printer'

export const logger = new SafeLogger({
  printer: new SafeHybridPrinter(new SafePrettyPrinter(), { debug: new SafeSimplePrinter() }),
  output: new SafeMultiOutput([new SafeConsoleOutput(), new SafeWriteFileOutput()]),
  filter: new SafeFilter(),
})

export * from './src/main/ets/abstract/notifier'
export * from './src/main/ets/abstract/printer'
export * from './src/main/ets/abstract/output'
export * from './src/main/ets/abstract/filter'
export * from './src/main/ets/abstract/logger'

export * from './src/main/ets/service/notifier'
export * from './src/main/ets/service/printer'
export * from './src/main/ets/service/output'
export * from './src/main/ets/service/filter'
export * from './src/main/ets/service/logger'