## CHANGELOG

### v1.0.0

1. 定义 抽象类 API
     - Filter (过滤)
     - Output (输出)
     - Logger (触发)
     - Printer (格式)
     - 
   
2. 实现 核心功能
     - Filter: SafeFilter
     - Logger: SafeLogger
     - Printer: SafePrettyPrinter、SafeHybridPrinter、SafeSimplePrinter
     - Output: SafeMultiOutput、SafeConsoleOutput、SafeWriteFileOutput
     -
  
3. 预设 logger (new SafeLogger)
     ```typescript
       export const logger = new SafeLogger({
         printer: new SafeHybridPrinter(new SafePrettyPrinter(), { debug: new SafeSimplePrinter() }),
         output: new SafeMultiOutput([new SafeConsoleOutput(), new SafeWriteFileOutput()]),
         filter: new SafeFilter(),
       })
     ```

