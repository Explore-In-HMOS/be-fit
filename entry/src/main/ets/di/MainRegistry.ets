import { Rdb } from '../rdb/Rdb';
import { Register, ServiceRegistry } from '../registry/ServiceRegistry';
import { UiRegistry } from '../registry/UIRegistry';
import { NotificationService } from '../util/NotificationService';
import { PersistentStorageService } from '../util/PersistentStorageService';
import { ReminderService } from '../util/ReminderService';
import { VibrationService } from '../util/VibrationService';

export class MainRegistry extends ServiceRegistry implements UiRegistry {
  context: Context;

  private constructor(context: Context) {
    super();
    this.context = context;
  }

  public static build(context: Context): MainRegistry {
    const instance = new MainRegistry(context);
    instance.initialize();
    return instance;
  }

  @Register(NotificationService)
  public registerNotificationService(): NotificationService {
    return new NotificationService();
  }

  @Register(VibrationService)
  public registerVibrationService(): VibrationService {
    return new VibrationService();
  }

  @Register(PersistentStorageService)
  public registerPersistentStorageService(): PersistentStorageService {
    return new PersistentStorageService();
  }

  @Register(ReminderService)
  public registerReminderService(): ReminderService {
    return new ReminderService();
  }

  @Register(Rdb)
  public registerRdb(): Rdb {
    return new Rdb(this.context);
  }
}
