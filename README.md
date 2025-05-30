## Logger

Logger 是一个简单、美观、实用的HarmonyOS应用程序日志框架...

- 支持 多种数据格式，如基本数据类型、对象、Class、Map、Set 等支持 JSON.stringify 序列化数据
- 支持 自定义日志行为，如本地文件读写 (定期自动清理)、云端日志上报等
- 支持 堆栈信息输出
- 支持 API12+

### 示例

```bash
  # file: 20250406.log
  # logger.info('Test logger.info...')
  # logger.warn('Test logger.warn...')
  # logger.warn(new Map([['name', '这是一个 Map 对象']]))
  # ------------------------------------------------------
  ┌────────────────────────────────────────────────────────────────────────────────
  │ Info | 2025-04-06 14:58:59.810 (+00:00:25.276)
  ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  │ Test logger.info...
  ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  │ #0    at print (library/src/main/ets/service/printer.ets:235:45)
  │ #1    at print (library/src/main/ets/service/printer.ets:269:12)
  │ #2    at log (library/src/main/ets/abstract/logger.ets:114:22)
  └────────────────────────────────────────────────────────────────────────────────
  ┌────────────────────────────────────────────────────────────────────────────────
  │ Warn | 2025-04-06 14:59:01.820 (+00:00:27.286)
  ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  │ Test logger.warn...
  ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
  │ #0    at print (library/src/main/ets/service/printer.ets:235:45)
  │ #1    at print (library/src/main/ets/service/printer.ets:269:12)
  │ #2    at log (library/src/main/ets/abstract/logger.ets:114:22)
  └────────────────────────────────────────────────────────────────────────────────
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

<br/>

### 安装

```shell
  ohpm install logger
```

<br/>

### 使用

#### 1. 预设了 logger

```typescript
  // 目前已预设 logger
  export const logger = new SafeLogger({
    printer: new SafeHybridPrinter(new SafePrettyPrinter(), { debug: new SafeSimplePrinter() }),
    output: new SafeMultiOutput([new SafeConsoleOutput(), new SafeWriteFileOutput()]),
    filter: new SafeFilter(),
  })
  
  // 可按需自定义, eg. file = context.filesDir + '/logger/output/cache/test-cache.20250408.txt'
  // 更多配置选项，可参考下面 【预设 logger】章节
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

#### 2. 相关使用说明

```typescript
  // 触发 hilog[level]
  logger.debug('...[debug] message...')
  logger.info('...[info] message...')
  logger.warn('...[warn] message...')
  logger.error('...[error] message...')
  logger.fatal('...[fatal] message...')
  
  // 读取日志文件, 可用来上传、或文本显示
  const file = await logger.readAsRequestFile() // IRequestFile 类型 (适配 request.File)
  const file = await logger.readAsRequestFiles() // IRequestFile[] 类型 (适配 request.File)
  
  const file = await logger.readAsArrayBuffers() // IArrayBuffer[] 类型 (适配 axios FormData)
  const file = await logger.readAsArrayBuffer() // IArrayBuffer 类型 (适配 axios FormData)
  
  const file = await logger.readAsStrings() // IString[] 类型 (文本内容)
  const file = await logger.readAsString() // IString 类型 (文本内容)
```

<br/>

### 相关 API

| 抽象API   | 描述     | 目前已实现                                                 |
|:--------|--------|:------------------------------------------------------|
| Filter  | 日志过滤条件 | SafeFilter                                            |
| Output  | 日志输出流  | SafeMultiOutput、SafeConsoleOutput、SafeWriteFileOutput |
| Printer | 日志内容格式 | SafePrettyPrinter、SafeHybridPrinter、SafeSimplePrinter |
| Logger  | 日志触发执行 | SafeLogger                                            |

<br/>

#### SafeFilter - 日志过滤条件

| 参数    | 类型             | 描述                               |
|:------|----------------|:---------------------------------|
| level | hilog.LogLevel | 日志过滤级别, 默认值 hilog.LogLevel.DEBUG | 

<br/>

#### SafeLogger - 日志触发执行器

| 参数      | 类型              | 描述                   |
|:--------|-----------------|:---------------------|
| level   | hilog.LogLevel  | 修改 this.filter.level | 
| filter  | 	Filter (必选项)   | 日志过滤条件               |
| output  | 	Output (必选项) 	 | 日志输出流                |
| printer | 	Printer (必选项)	 | 日志内容格式               |

<br/>

#### SafeSimplePrinter - 简单日志格式，适用于 debug 调试

| 参数 | 类型 | 描述 |
|:---|----|:---|
| /  | /  | /  |

<br/>

#### SafePrettyPrinter - 美化日志格式，适用于本地文件写入

| 参数                   | 类型                             | 描述                                                                |
|:---------------------|--------------------------------|:------------------------------------------------------------------|
| excludeBox           | 	Map<hilog.LogLevel, boolean>	 | 指定哪些日志级别 不 使用边框（Box）包装日志内容                                        |
| includeBox	          | Map<hilog.LogLevel, boolean>	  | 指定哪些日志级别 要 使用边框（Box）包装日志内容                                        |
| stackTraceBeginIndex | 	number	                       | 控制堆栈跟踪（StackTrace）的起始索引，跳过前面的堆栈信息(如框架内部调用)，默认值 0                  |
| noBoxingByDefault    | 	boolean	                      | 如果为 true，默认禁用所有日志级别的边框(除非 includeBox 或 excludeBox 显式设置)，默认值 false |
| errorMethodCount	    | number	                        | 控制 错误级别（Error） 日志的堆栈跟踪显示的方法数量，默认值 10                              |
| methodCount	         | number	                        | 控制 非错误级别（非 Error） 日志的堆栈跟踪显示的方法数量，默认值 5                            |
| lineLength           | 	number                        | 	设置日志边框的视觉宽度(字符数)，默认值 80                                          |
| minifyCode	          | boolean                        | 	是否在 JSON.stringify 序列化中消除空白缩进字符，默认值 false                        |
| printTime	           | boolean                        | 	是否在日志中显示时间戳，默认值 true                                             |

<br/>

#### SafeHybridPrinter - 适配不同日志级别的日志格式

| 参数    | 类型        | 描述                                     |
|:------|-----------|:---------------------------------------|
| info  | 	Printer	 | 指定 INFO 级别日志使用的打印机实例，未设置时使用默认 printer  |
| warn  | 	Printer  | 指定 WARN 级别日志使用的打印机实例，未设置时使用默认 printer  |
| debug | 	Printer	 | 指定 DEBUG 级别日志使用的打印机实例，未设置时使用默认 printer |
| error | 	Printer	 | 指定 ERROR 级别日志使用的打印机实例，未设置时使用默认 printer |
| fatal | 	Printer	 | 指定 FATAL 级别日志使用的打印机实例，未设置时使用默认 printer |

<br/>

#### SafeWriteFileOutput - 本地文件读写流

| 参数            | 类型             | 描述                                                                            |
|:--------------|----------------|:------------------------------------------------------------------------------|
| level         | hilog.LogLevel | 日志过滤级别, 默认值 hilog.LogLevel.INFO                                               | 
| count         | number         | 储存本地文件数量，超出会自动清理，默认值为 3                                                       | 
| enable        | boolean        | 是否启用 SafeWriteFileOutput, 默认值 true                                            | 
| storage       | string         | 文件储存路径 (context.filesDir + ${storage}), 默认值 'ohpm.package.logger/output/file' | 
| encoding      | string         | 文件读写编码，默认值 'utf-8'                                                            | 
| isOverride    | boolean        | 是否允许日志内容覆盖写入，默认值为 false, 即 追加模式                                               |
| fileFormatter | string         | 文件名格式，默认值为 '[yyyyMMdd]', (如 20250406.log), 中括号内会尝试解析转换                        | 
| fileSuffix    | string         | 文件名后缀，默认值为 'log'                                                              | 
| filePrefix    | string         | 文件名前缀，默认值为 ''                                                                 | 

<br/>

#### SafeConsoleOutput - 命令行输出流

| 参数     | 类型             | 描述                               |
|:-------|----------------|:---------------------------------|
| level  | hilog.LogLevel | 日志过滤级别, 默认值 hilog.LogLevel.DEBUG | 
| prefix | string         | 日志前缀, 默认值 'Logger'               | 
| domain | number         | 日志域, 默认值 0xFFCC                  | 
| enable | boolean        | 是否启用 ConsoleOutput, 默认值 true     | 

<br/>

#### SafeMultiOutput - 适配多个输出流

| 参数 | 类型 | 描述 |
|:---|----|:---|
| /  | /  | /  | 

<br/>

### 预设 logger

| 分类        | 方法                    | 说明                 | 返回类型                              |
|:----------|:----------------------|:-------------------|-----------------------------------|
| **自定义选项** | `reset`               | 自定义日志配置            | `Promise<void>`                   |
| **日志记录**  | `debug`               | 记录 DEBUG 级别日志      | `Promise<void>`                   |
|           | `info`                | 记录 INFO 级别日志       | `Promise<void>`                   |
|           | `warn`                | 记录 WARN 级别日志       | `Promise<void>`                   |
|           | `error`               | 记录 ERROR 级别日志      | `Promise<void>`                   |
|           | `fatal`               | 记录 FATAL 级别(最高级)日志 | `Promise<void>`                   |
| **文件读取**  | `readAsRequestFile`   | 读取最新日志文件（文件完整路径）   | `Promise<IRequestFile \| null>`   |
|           | `readAsRequestFiles`  | 读取近期日志文件（文件完整路径）   | `Promise<IRequestFile[] \| null>` |
|           | `readAsArrayBuffer`   | 读取最新日志文件（文件二进制数据）  | `Promise<IArrayBuffer \| null>`   |
|           | `readAsArrayBuffers`  | 读取近期日志文件（文件二进制数据）  | `Promise<IArrayBuffer[] \| null>` |
|           | `readAsString`        | 读取最新日志文件（文件文本内容）   | `Promise<IString \| null>`        |
|           | `readAsStrings`       | 读取近期日志文件（文件文本内容）   | `Promise<IString[] \| null>`      |
| **事件监听**  | `addWriteListener`    | 注册日志写入事件的监听器       | `void`                            |
|           | `removeWriteListener` | 移除日志写入事件的监听器       | `void`                            |
| **清理日志**  | `clearHistory`        | 清除过期的日志文件          | `Promise<void>`                   |
|           | `clearAll`            | 清除所有日志文件(包括当前日志)   | `Promise<void>`                   |
| **检查日志**  | `isEmpty`             | 检查日志文件是否为空 (即不存在)  | `Promise<boolean>`                |

```typescript
  // TS 类型说明

  export interface IString {
    content: string; // 文件内容
    filename: string; // 文件名 如 '20250410.log'
    type: string; // 文件类型 如 'text/plain'
  }
  
  export interface IArrayBuffer {
    buffer: ArrayBuffer; // 文件内容 (字节)
    filename: string; // 文件名 如 '20250410.log'
    type: string; // 文件类型 如 'text/plain'
  }
  
  export interface IRequestFile {
    name: string; // 文件名 (不含后缀) 如 '20250410'
    filename: string; // 文件名 (含后缀) 如 '20250410.log'
    uri: string; // 文件完整路径 如 context.filesDir + '/xxxx/20250410/.log'
    type: string; // 文件后缀，如 'log'
  }
```

<br/>

### License

Apache-2.0