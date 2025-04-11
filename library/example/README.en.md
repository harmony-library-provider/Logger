### Related API

| API     | Description           | Currently Implemented                                 |
|:--------|-----------------------|:------------------------------------------------------|
| Filter  | Log filter conditions | SafeFilter                                            |
| Output  | Log output stream     | SafeMultiOutput、SafeConsoleOutput、SafeWriteFileOutput |
| Printer | Log content format    | SafePrettyPrinter、SafeHybridPrinter、SafeSimplePrinter |
| Logger  | Log trigger execution | SafeLogger                                            |

<br/>

#### SafeFilter - Log filter conditions

| Parameter | Type           | Description                                          |
|:----------|----------------|:-----------------------------------------------------|
| level     | hilog.LogLevel | Log filtering level, default is hilog.LogLevel.DEBUG |

<br/>

#### SafeLogger - Log Trigger Executor

| Parameter | Type               | Description                  |
|:----------|--------------------|:-----------------------------|
| level     | hilog.LogLevel     | Modifies `this.filter.level` |
| filter    | Filter (Required)  | Log filtering conditions     |
| output    | Output (Required)  | Log output stream            |
| printer   | Printer (Required) | Log content format           |

<br/>

#### SafeSimplePrinter - Simple log format, suitable for debug purposes

| Parameter | Type | Description |
|:----------|------|:------------|
| /         | /    | /           |

<br/>

#### SafePrettyPrinter - Beautified log format, suitable for local file writing

| Parameter            | Type                         | Description                                                                                                              |
|:---------------------|------------------------------|:-------------------------------------------------------------------------------------------------------------------------|
| excludeBox           | Map<hilog.LogLevel, boolean> | Specifies which log levels should NOT use box wrapping for log content                                                   |
| includeBox           | Map<hilog.LogLevel, boolean> | Specifies which log levels SHOULD use box wrapping for log content                                                       |
| stackTraceBeginIndex | number                       | Controls the starting index of stack traces (skipping framework calls), default 0                                        |
| noBoxingByDefault    | boolean                      | If true, disables box wrapping for all levels by default (unless explicitly set in includeBox/excludeBox), default false |
| errorMethodCount     | number                       | Controls how many stack trace methods to show for ERROR level logs, default 10                                           |
| methodCount          | number                       | Controls how many stack trace methods to show for non-ERROR logs, default 5                                              |
| lineLength           | number                       | Sets the visual width (in characters) of log boxes, default 80                                                           |
| minifyCode           | boolean                      | Whether to remove whitespace in JSON.stringify serialization, default false                                              |
| printTime            | boolean                      | Whether to display timestamps in logs, default true                                                                      |

<br/>

#### SafeHybridPrinter - Adapts log formats for different log levels

| Parameter | Type    | Description                                                            |
|:----------|---------|:-----------------------------------------------------------------------|
| info      | Printer | Printer instance for INFO level logs, uses default printer if not set  |
| warn      | Printer | Printer instance for WARN level logs, uses default printer if not set  |
| debug     | Printer | Printer instance for DEBUG level logs, uses default printer if not set |
| error     | Printer | Printer instance for ERROR level logs, uses default printer if not set |
| fatal     | Printer | Printer instance for FATAL level logs, uses default printer if not set |

<br/>

#### SafeWriteFileOutput - Local file read/write stream

| Parameter     | Type           | Description                                                                                           |
|:--------------|----------------|:------------------------------------------------------------------------------------------------------|
| level         | hilog.LogLevel | Log filtering level, default value: hilog.LogLevel.INFO                                               |
| count         | number         | Maximum number of local files to store (older files will be auto-cleaned), default: 3                 |
| enable        | boolean        | Whether to enable SafeWriteFileOutput, default: true                                                  |
| storage       | string         | File storage path (context.filesDir + ${storage}), default: 'ohpm.package.logger/output/file'         |
| encoding      | string         | File encoding for read/write operations, default: 'utf-8'                                             |
| isOverride    | boolean        | Whether to allow log overwriting (false means append mode), default: false                            |
| fileFormatter | string         | File name format pattern, default: '[yyyyMMdd]' (e.g. 20250406.log) - brackets content will be parsed |
| fileSuffix    | string         | File name suffix, default: 'log'                                                                      |
| filePrefix    | string         | File name prefix, default: ''                                                                         |

<br/>

#### SafeConsoleOutput - Command line output stream

| Parameter | Type           | Description                                        |
|:----------|----------------|:---------------------------------------------------|
| level     | hilog.LogLevel | Log filtering level, default: hilog.LogLevel.DEBUG |
| prefix    | string         | Log prefix, default: 'Logger'                      |
| domain    | number         | Log domain, default: 0xFFCC                        |
| enable    | boolean        | Whether to enable ConsoleOutput, default: true     |

<br/>

#### SafeMultiOutput - Adapts to multiple output streams

| Parameter | Type | Description |
|:----------|------|:------------|
| /         | /    | /           |

<br/>

### Preset logger

| Category            | Method                | Description                                 | Return Type                       |
|:--------------------|:----------------------|:--------------------------------------------|:----------------------------------|
| **Custom Options**  | `reset`               | Customize log configuration                 | `Promise<void>`                   |
| **Logging**         | `debug`               | Log DEBUG level message                     | `Promise<void>`                   |
|                     | `info`                | Log INFO level message                      | `Promise<void>`                   |
|                     | `warn`                | Log WARN level message                      | `Promise<void>`                   |
|                     | `error`               | Log ERROR level message                     | `Promise<void>`                   |
|                     | `fatal`               | Log FATAL level (highest) message           | `Promise<void>`                   |
| **File Reading**    | `readAsRequestFile`   | Read latest log file (full path)            | `Promise<IRequestFile \| null>`   |
|                     | `readAsRequestFiles`  | Read recent log files (full paths)          | `Promise<IRequestFile[] \| null>` |
|                     | `readAsArrayBuffer`   | Read latest log file (binary data)          | `Promise<IArrayBuffer \| null>`   |
|                     | `readAsArrayBuffers`  | Read recent log files (binary data)         | `Promise<IArrayBuffer[] \| null>` |
|                     | `readAsString`        | Read latest log file (text content)         | `Promise<IString \| null>`        |
|                     | `readAsStrings`       | Read recent log files (text content)        | `Promise<IString[] \| null>`      |
| **Event Listeners** | `addWriteListener`    | Register log write event listener           | `void`                            |
|                     | `removeWriteListener` | Remove log write event listener             | `void`                            |
| **Log Cleanup**     | `clearHistory`        | Clear expired log files                     | `Promise<void>`                   |
|                     | `clearAll`            | Clear all log files (including current)     | `Promise<void>`                   |
| **Log Inspection**  | `isEmpty`             | Check if log files are empty (non-existent) | `Promise<boolean>`                |

```typescript
  // TypeScript description
  
  export interface IString {
    content: string; // Text content
    filename: string; // File name, eg. '20250410.log'
    type: string; // Mime, eg. 'text/plain'
  }

  export interface IArrayBuffer {
    buffer: ArrayBuffer; // Text content (byte)
    filename: string; // File name, eg. '20250410.log'
    type: string; // Mime, eg. 'text/plain'
  }

  export interface IRequestFile {
    name: string; // File name (without suffix) eg. '20250410'
    filename: string; // File name (with suffix) eg. '20250410.log'
    uri: string; // File fullpath eg. context.filesDir + '/xxxx/20250410/.log'
    type: string; // File suffix，eg. 'log'
  }
```

<br/>
