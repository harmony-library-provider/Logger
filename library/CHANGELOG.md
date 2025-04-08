### v1.1.2

1. 优化 SafeWriteFileOutput 文件读取 API
   ```text
      - readAsRequestFile: 返回类型 { filename: string; name: string; uri: string; type: string; }
      - readAsRequestFiles: 返回类型 { filename: string; name: string; uri: string; type: string; }[]
      - readAsArrayBuffers: 返回类型 { filename: string; buffer: ArrayBuffer; type: string; }[]
      - readAsArrayBuffer: 返回类型 { filename: string; buffer: ArrayBuffer; type: string; }
      - readAsStrings: 返回类型 { filename: string; content: string; type: string; }[]
      - readAsString: 返回类型 { filename: string; content: string; type: string; }
   ```

### v1.1.1

1. 扩展 SafeWriteFileOutput API 选项 (fileFormatter、filePrefix、fileSuffix)

   ```typescript
      logger.reset({
         output: new SafeMultiOutput([
            new SafeWriteFileOutput({
               storage: 'logger/output/cache',
               fileFormatter: 'cache.[yyyyMMdd]',
               filePrefix: 'test-',
               fileSuffix: 'txt'
            }),
            new SafeConsoleOutput()
         ])
      })
   ```

### v1.1.0

1. 增加 IRequestFile TS类型
2. 完成 Logger 所有核心 API 验证

### v1.0.3

1. 修复 SafeWriteFileOutput API bug (isEmpty、clearHistory、getSortedFiles 循环调用)

### v1.0.2

1. 预设的 logger 支持自定义选项 (reset API)

   ```typescript
     logger.reset({
       printer: new SafeHybridPrinter(new SafePrettyPrinter(), { debug: new SafeSimplePrinter() }),
       output: new SafeMultiOutput([new SafeConsoleOutput(), new SafeWriteFileOutput()]),
       // filter: new SafeFilter(),
     })
   ```

### v1.0.1

1. 测试 logger API (debug、info、readAsArrayBuffer、readAsString...)  
2. 完善 example of Logger (Console、ReadAs)  
3. 更新 keywords of oh-package.json  

### v1.0.0

1. 定义 抽象类 API
   ```text
     - Filter (过滤)
     - Output (输出)
     - Logger (触发)
     - Printer (格式)
   ```
   
2. 实现 核心功能
   ```text
     - Logger: SafeLogger
     - Filter: SafeFilter
     - Output: SafeMultiOutput、SafeConsoleOutput、SafeWriteFileOutput
     - Printer: SafePrettyPrinter、SafeHybridPrinter、SafeSimplePrinter
   ```
  
3. 预设 logger (new SafeLogger)
     ```typescript
       export const logger = new SafeLogger({
         printer: new SafeHybridPrinter(new SafePrettyPrinter(), { debug: new SafeSimplePrinter() }),
         output: new SafeMultiOutput([new SafeConsoleOutput(), new SafeWriteFileOutput()]),
         filter: new SafeFilter(),
       })
     ```

