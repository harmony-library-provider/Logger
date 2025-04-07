import { Logger } from "../abstract/logger";
import { SafeMultiOutput } from "../service/output";
import { SafeWriteFileOutput } from "../service/output";

export class SafeLogger extends Logger {
  get writeFileOutput() {
    if (this.output instanceof SafeWriteFileOutput) {
      return this.output
    }

    if (this.output instanceof SafeMultiOutput) {
      return this.output.findTargetOutput<SafeWriteFileOutput>(output => output instanceof SafeWriteFileOutput)
    }

    return null
  }

  get addWriteListener() {
    return this.writeFileOutput?.changeNotifier.addListener ?? (() => {});
  }

  get removeWriteListener() {
    return this.writeFileOutput?.changeNotifier.removeListener ?? (() => {});
  }

  async readAsRequestFile() {
    try {
      return this.writeFileOutput?.readAsRequestFile() ?? null;
    } catch (e) {
      return null;
    }
  }

  async readAsRequestFiles() {
    try {
      return this.writeFileOutput?.readAsRequestFiles() ?? null;
    } catch (e) {
      return null;
    }
  }

  async readAsArrayBuffers() {
    try {
      return this.writeFileOutput?.readAsArrayBuffers() ?? null;
    } catch (e) {
      return null;
    }
  }

  async readAsArrayBuffer() {
    try {
      return this.writeFileOutput?.readAsArrayBuffer() ?? null;;
    } catch (e) {
      return null;
    }
  }

  async readAsStrings() {
    try {
      return this.writeFileOutput?.readAsStrings() ?? null;;
    } catch (e) {
      return null;
    }
  }

  async readAsString() {
    try {
      return this.writeFileOutput?.readAsString() ?? null;;
    } catch (e) {
      return null;
    }
  }

  async clearHistory() {
    try {
      return this.writeFileOutput?.clearHistory();
    } catch (e) {
      return;
    }
  }

  async clearAll() {
    try {
      return this.writeFileOutput?.clearAll();
    } catch (e) {
      return;
    }
  }

  async isEmpty() {
    try {
      return this.writeFileOutput?.isEmpty() ?? true;
    } catch (e) {
      return true
    }
  }
}
