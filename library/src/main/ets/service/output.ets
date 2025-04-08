import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { hilog } from "@kit.PerformanceAnalysisKit";
import { SafeChangeNotifier } from '../service/notifier';
import { OutputEvent } from '../abstract/output';
import { AsyncMutex } from '../service/locker';
import { Output } from '../abstract/output';
import { levels } from '../service/level';

export interface IRequestFile {
  filename: string;
  name: string;
  uri: string;
  type: string;
}

export interface IConsoleOutput {
  level?: hilog.LogLevel;
  enable?: boolean;
  domain?: number;
  prefix?: string;
}

export interface ISafeFileOutput {
  level?: hilog.LogLevel;
  count?: number;
  enable?: boolean;
  storage?: string;
  encoding?: string;
  isOverride?: boolean;
  fileFormatter?: string;
}

export class SafeMultiOutput extends Output {
  private outputs: Output[] = [];

  constructor(outputs?: Output[]) {
    super()
    this.outputs = this.normalizeOutputs(outputs);
  }

  public findTargetOutput<T>(fn: (_: Output) => boolean) {
    const result = this.outputs.find(fn) ?? null
    return result as T | null
  }

  public normalizeOutputs(outputs?: Output[]) {
    const normalizedOutputs: Output[] = [];

    if (outputs != null) {
      for (const output of outputs) {
        if (output instanceof Output) {
          normalizedOutputs.push(output);
        }
      }
    }

    return normalizedOutputs;
  }

  public output(event: OutputEvent) {
    for (const o of this.outputs) {
      o.output(event);
    }
  }

  async destroy() {
    await Promise.all(this.outputs.map((e) => e.destroy()));
  }

  async init() {
    await Promise.all(this.outputs.map((e) => e.init()));
  }
}

export class SafeConsoleOutput extends Output {
  public level: hilog.LogLevel = hilog.LogLevel.DEBUG
  public prefix: string = 'Logger';
  public domain: number = 0xFFCC;
  public enable: boolean = true

  constructor(options: IConsoleOutput = {}) {
    super()
    this.level = options.level ?? this.level
    this.domain = options.domain ?? this.domain
    this.prefix = options.prefix ?? this.prefix
    this.enable = options.enable ?? this.enable
  }

  output(event: OutputEvent) {
    if (this.enable !== true) {
      return
    }

    if (event.level < this.level) {
      return
    }

    event.lines.forEach((line) => {
      const proxy = levels.proxy(event.level)
      const isFn = typeof proxy === 'function'

      if (isFn) {
        proxy(this.domain, this.prefix, '%{public}s', line)
      }
    });
  }
}

export class SafeWriteFileOutput extends Output {
  private fileFormatter = 'yyyyMMdd'
  private isOverride = false
  private encoding = 'utf-8'
  private time = 180000;
  private count = 3
  private lock = new AsyncMutex();
  private timer: number | null = null
  private fileDir: string | null = null
  private fileName: string | null = null
  private fileStream: fileIo.Stream | null = null
  public changeNotifier = new SafeChangeNotifier()
  public storage = 'ohpm.package.logger/output/file'
  public level = hilog.LogLevel.INFO
  public enable = true

  constructor(options: ISafeFileOutput = {}) {
    super()
    this.level = options.level ?? this.level
    this.count = options.count ?? this.count
    this.enable = options.enable ?? this.enable
    this.storage = options.storage ?? this.storage
    this.encoding = options.encoding ?? this.encoding
    this.isOverride = options.isOverride ?? this.isOverride
    this.fileFormatter = options.fileFormatter ?? this.fileFormatter
  }

  async init() {
    this.clearHistory();
  }

  async destroy() {
    return this.lock.synchronized(() => {
      this.clearFileStream();
    });
  }

  async output(event: OutputEvent) {
    try {
      if (this.enable !== true) {
        return
      }

      if (event.level < this.level) {
        return;
      }

      clearTimeout(this.timer);

      this.timer = setTimeout(this.clearFileStream, this.time);

      await this.lock.synchronized(async () => {
        if (this.fileStream == null || await this.createFileName() != this.fileName) {
          await this.clearFileStream();
          await this.createFileStream();
        }

        if (this.fileStream == null || this.fileName == null) {
          await this.clearFileStream();
          return;
        }

        this.fileStream!.writeSync(event.lines.join('\n'));
      });

      this.changeNotifier.notifyListeners();
    } catch (e) {
      await this.clearFileStream();
    }
  }

  async getSortedFiles(): Promise<string[] | null> {
    const dir = this.fileDir ?? await this.getFileDirectory();
    const list = fileIo.listFileSync(dir).map(name => dir + '/' + name);
    const files = list.filter(file => fileIo.lstatSync(file).isFile() && file.endsWith('.log'))

    if (files.length > 0) {
      files.sort((aFile, bFile) => {
        const aPath = aFile.split('/').pop() ?? ''
        const bPath = bFile.split('/').pop() ?? ''
        const aName = aPath.replace(/\D/g, '');
        const bName = bPath.replace(/\D/g, '');
        const aNumber = Number.parseInt(aName)
        const bNumber = Number.parseInt(bName)

        if (Number.isInteger(aNumber) && Number.isInteger(bNumber)) {
          return bNumber - aNumber
        }

        if (Number.isInteger(bNumber)) {
          return 1;
        }

        return -1
      });

      return files;
    }

    return null;
  }

  async readAsRequestFile(): Promise<IRequestFile | null> {
    return this.lock.synchronized(async () => {
      if (await this.isEmpty()) {
        return null;
      }

      if (this.fileStream != null) {
        await this.clearFileStream()
      }

      const files = await this.getSortedFiles();
      const uri = files?.[0] ?? null

      if (uri === null) {
        return null;
      }

      const filename = uri.split('/').pop()!
      const name = filename.replace(/\.log$/, '')
      const type = 'log'

      const file:IRequestFile = {
        filename: filename,
        name: name,
        type: type,
        uri: uri
      }

      return file;
    });
  }

  async readAsRequestFiles(): Promise<IRequestFile[] | null> {
    return this.lock.synchronized(async () => {
      if (await this.isEmpty()) {
        return null;
      }

      if (this.fileStream != null) {
        await this.clearFileStream()
      }

      const files:IRequestFile[] = []
      const uris = await this.getSortedFiles();

      if (uris == null || uris.length === 0) {
        return null;
      }

      for (const uri of uris) {
        const filename = uri.split('/').pop()!
        const name = filename.replace(/\.log$/, '')
        const type = 'log'

        const file:IRequestFile = {
          filename: filename,
          name: name,
          type: type,
          uri: uri
        }

        files.push(file);
      }

      return files;
    });
  }

  async readAsArrayBuffers(): Promise<ArrayBuffer[] | null> {
    return this.lock.synchronized(async () => {
      if (await this.isEmpty()) {
        return null;
      }

      if (this.fileStream != null) {
        await this.clearFileStream()
      }

      const bufArr: ArrayBuffer[] = []
      const files = await this.getSortedFiles();

      if (files == null || files.length === 0) {
        return null;
      }

      for (const path of files) {
        const stat = fileIo.lstatSync(path)
        const file = fileIo.openSync(path, fileIo.OpenMode.READ_ONLY)
        const buf = new ArrayBuffer(stat.size)

        fileIo.readSync(file.fd, buf);

        bufArr.push(buf)
      }

      return bufArr;
    });
  }

  async readAsArrayBuffer(): Promise<ArrayBuffer | null> {
    return this.lock.synchronized(async () => {
      if (await this.isEmpty()) {
        return null;
      }

      if (this.fileStream != null) {
        await this.clearFileStream()
      }

      const files = await this.getSortedFiles();
      const path = files?.[0] ?? null

      if (path === null) {
        return null;
      }

      const stat = fileIo.lstatSync(path)
      const file = fileIo.openSync(path, fileIo.OpenMode.READ_ONLY)
      const buf = new ArrayBuffer(stat.size)

      fileIo.readSync(file.fd, buf);

      return buf;
    });
  }

  async readAsStrings(): Promise<string[] | null> {
    return this.lock.synchronized(async () => {
      if (await this.isEmpty()) {
        return null;
      }

      if (this.fileStream != null) {
        await this.clearFileStream()
      }

      const logs: Array<string> = [];
      const files = await this.getSortedFiles();

      if (files == null || files.length === 0) {
        return null;
      }

      for (const file of files) {
        logs.push(fileIo.readTextSync(file, { encoding: this.encoding }));
      }

      return logs;
    });
  }

  async readAsString(): Promise<string | null> {
    return this.lock.synchronized(async () => {
      if (await this.isEmpty()) {
        return null;
      }

      if (this.fileStream != null) {
        await this.clearFileStream()
      }

      const files = await this.getSortedFiles();

      if (files == null || files.length === 0) {
        return null;
      }

      return fileIo.readTextSync(files[0], { encoding: this.encoding })
    });
  }

  async getFileDirectory(): Promise<string> {
    const context = getContext(this) as common.UIAbilityContext;
    const fileDir = context.filesDir + this.storage.replace(/^\/*/, '/')

    if (!fileIo.accessSync(fileDir)) {
      fileIo.mkdirSync(fileDir, true)
    }

    return fileDir
  }

  async createFileName(): Promise<string> {
    const date = new Date()
    const format = this.fileFormatter
    const filename = format.replace(/YYYY|MM?|DD?|HH?|mm?|ss/gi, type => {
      switch (type) {
        case 'YYYY':
          return String(date.getFullYear())
        case 'yyyy':
          return String(date.getFullYear())
        case 'MM':
          return String(date.getMonth() >= 9 ? date.getMonth() + 1 : '0' + (date.getMonth() + 1))
        case 'M':
          return String(date.getMonth() + 1)
        case 'DD':
          return String(date.getDate() > 9 ? date.getDate() : '0' + date.getMonth())
        case 'dd':
          return String(date.getDate() > 9 ? date.getDate() : '0' + date.getMonth())
        case 'D':
          return String(date.getDate())
        case 'd':
          return String(date.getDate())
        case 'HH':
          return String(date.getHours() > 9 ? date.getHours() : '0' + date.getHours())
        case 'hh':
          return String(date.getHours() > 9 ? date.getHours() : '0' + date.getHours())
        case 'H':
          return String(date.getHours())
        case 'h':
          return String(date.getHours())
        case 'mm':
          return String(date.getMinutes() > 9 ? date.getMinutes() : '0' + date.getMinutes())
        case 'm':
          return String(date.getMinutes())
        case 'ss':
          return String(date.getSeconds() > 9 ? date.getSeconds() : '0' + date.getSeconds())
      }
      return type
    })

    return `${filename}.log`
  }

  async createFileStream(): Promise<void> {
    const fileDir = await this.getFileDirectory();
    const fileName = await this.createFileName();
    const filePath = fileDir + '/' + fileName;

    this.fileStream = fileIo.createStreamSync(filePath, this.isOverride ? 'w+' : 'a+')
    this.fileName = fileName;
    this.fileDir = fileDir
  }

  async clearFileStream(): Promise<void> {
    clearTimeout(this.timer);

    if (this.fileStream != null) {
      this.fileStream.flushSync();
      this.fileStream.closeSync();
    }

    this.fileStream = null;
    this.fileName = null;
    this.fileDir = null;
    this.timer = null;
  }

  async clearDirectory(): Promise<void> {
    const dir = await this.getFileDirectory();

    if (fileIo.accessSync(dir)) {
      fileIo.rmdirSync(dir)
    }
  }

  async clearHistory(): Promise<void> {
    try {
      const files = await this.getSortedFiles();
      const limit = files != null && files.length > Math.max(this.count, 1);
      const array = limit ? files.filter((_, index) => index >= this.count) : null;

      if (array == null || array.length === 0) {
        return;
      }

      for (const file of array) {
        try {
          if (fileIo.lstatSync(file).isFile()) {
            fileIo.unlinkSync(file);
          }
        } catch (e) { /* e */
        }
      }
    } catch (e) { /* e */
    }
  }

  async clearAll(): Promise<void> {
    return this.lock.synchronized(async () => {
      try {
        await this.clearFileStream();
        await this.clearDirectory();
      } catch (e) { /* e */
      }
    });
  }

  async isEmpty(): Promise<boolean> {
    try {
      await this.clearHistory();

      const dir = this.fileDir ?? await this.getFileDirectory();

      if (!fileIo.lstatSync(dir).isDirectory()) {
        return true;
      }

      if (fileIo.listFileSync(dir).length > 0) {
        return false
      }
    } catch (e) {
      /* e */
    }

    return true;
  }
}
