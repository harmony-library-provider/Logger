### v1.2.7
1. 修复 SafeLogger API bug

   ```shell
      - get addWriteListener() {
      -   return this.writeFileOutput?.changeNotifier.addListener ?? (() => {});
      - }
      
      - get removeWriteListener() {
      -   return this.writeFileOutput?.changeNotifier.removeListener ?? (() => {});
      - }
   
      + public removeWriteListener(listener: VoidCallback) {
      +   if (this.writeFileOutput?.changeNotifier.removeListener) {
      +     this.writeFileOutput.changeNotifier.removeListener(listener)
      +   }
      + }
      
      + public addWriteListener(listener: VoidCallback) {
      +   if (this.writeFileOutput?.changeNotifier.addListener) {
      +     this.writeFileOutput.changeNotifier.addListener(listener)
      +   }
      + }
   ```

### v1.2.6
1. 修复 SafeWriteFileOutput API bug

   ```shell
      - this.timer = setTimeout(this.clearFileStream, this.time);
      + this.timer = setTimeout(() => this.clearFileStream(), this.time);
   ```

### v1.2.5
1. 支持 Map 类型数据 Key 键值为非基本数据

   ```shell
      # logger.warn(new Map([['name', '这是一个 Map 对象']]))
      # --------------------------------------------------------------
      ┌────────────────────────────────────────────────────────────────────────────────
      │ Warn | 2025-04-12 12:25:13.608 (+00:00:14.910)
      ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
      │ {
      │   "__type__": "Map",
      │   "__entries__": [
      │     [
      │       "name",
      │       "这是一个 Map 对象"
      │     ]
      │   ]
      │ }
      ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
      │ #0    at print (library/src/main/ets/service/printer.ets:259:45)
      │ #1    at print (library/src/main/ets/service/printer.ets:293:12)
      │ #2    at log (library/src/main/ets/abstract/logger.ets:154:22)
      └────────────────────────────────────────────────────────────────────────────────
   ```

### v1.2.4
1. 规范 Map、Set 日志序列化输出

   ```shell
      # logger.warn(new Map([['name', '这是一个 Map 对象']]))
      # --------------------------------------------------------------
      ┌────────────────────────────────────────────────────────────────────────────────
      │ Warn | 2025-04-10 11:04:24.127 (+00:00:05.072)
      ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
      │ {
      │   "__type__": "Map",
      │   "__value__": {
      │     "name": "这是一个 Map 对象"
      │   }
      │ }
      ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
      │ #0    at print (library/src/main/ets/service/printer.ets:268:45)
      │ #1    at print (library/src/main/ets/service/printer.ets:302:12)
      │ #2    at log (library/src/main/ets/abstract/logger.ets:154:22)
      └────────────────────────────────────────────────────────────────────────────────
   ```

### v1.2.3
1. 修复 Map 类型数据日志 bug, eg.

   ```shell
      # logger.warn(new Map([['name', '这是一个 Map 对象']]))
      # --------------------------------------------------------------
      ┌────────────────────────────────────────────────────────────────────────────────
      │ Warn | 2025-04-10 11:04:24.127 (+00:00:05.072)
      ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
      │ {
      │   "__type__": "Map",
      │   "value": {
      │     "name": "这是一个 Map 对象"
      │   }
      │ }
      ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
      │ #0    at print (library/src/main/ets/service/printer.ets:268:45)
      │ #1    at print (library/src/main/ets/service/printer.ets:302:12)
      │ #2    at log (library/src/main/ets/abstract/logger.ets:154:22)
      └────────────────────────────────────────────────────────────────────────────────
   ```

### v1.2.2

1. 支持复杂的数据类型，例如 Class、Map、Set 等
   ```shell
      # logger.warn(new Map([['name', '这是一个 Map 对象']]))
      # --------------------------------------------------------------
      ┌────────────────────────────────────────────────────────────────────────────────
      │ Warn | 2025-04-06 14:59:02.850 (+00:00:28.316)
      ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
      │ {
      │   "__type__": "Map",
      │   "value": [
      │     {
      │       "name": "这是一个 Map 对象"
      │     }
      │   ]
      │ }
      ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
      │ #0    at print (library/src/main/ets/service/printer.ets:268:45)
      │ #1    at print (library/src/main/ets/service/printer.ets:302:12)
      │ #2    at log (library/src/main/ets/abstract/logger.ets:154:22)
      └────────────────────────────────────────────────────────────────────────────────
   ```


### v1.2.1

1. 调整 SafeWriteFileOutput fileFormatter 选项默认值
   - change 'yyyyMMdd' to '[yyyyMMdd]'

### v1.2.0

1. 调整 compatibleSdkVersion: 5.0.0(12)
   - 适配 API12 版本

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

