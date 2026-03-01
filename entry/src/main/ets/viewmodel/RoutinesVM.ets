import { Routine } from '../model/Routine';
import { Rdb } from '../rdb/Rdb';
import { Resolve } from '../registry/ServiceRegistry';

@Observed
export class RoutinesVM {
  routines?: Routine[];
  @Resolve(Rdb)
  private rdb?: Rdb;

  async setRoutines() {
    this.routines = await this.rdb?.getAllRoutines();
    console.info(this.routines?.length.toString());
  }
}