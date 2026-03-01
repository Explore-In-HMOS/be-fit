import { Injectable } from '../registry/Injectable';

export class PersistentStorageService extends Injectable {
  onDispose?(): void {
  }

  init() {
    PersistentStorage.persistProp('reminderId', undefined);
  }

  set(key: string, value: number) {
    AppStorage.set(key, value);
  }

  read(key: string): number | undefined {
    return AppStorage.get(key);
  }
}