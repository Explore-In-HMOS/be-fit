import { Analysis } from '../model/Analysis';
import { Rdb } from '../rdb/Rdb';
import { Resolve } from '../registry/ServiceRegistry';

@Observed
export class HistoryVM {
  oldExercises?: Analysis[];
  @Resolve(Rdb)
  private rdb?: Rdb;

  async setExercises() {
    this.oldExercises = await this.rdb?.getAllWorkouts();
  }
}