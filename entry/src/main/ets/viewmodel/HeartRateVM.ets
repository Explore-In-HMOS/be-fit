import { sensor } from '@kit.SensorServiceKit';
import { Resolve } from '../registry/ServiceRegistry';
import { NotificationService } from '../util/NotificationService';

@Observed
export class HeartRateVM {
  rate?: number;
  @Resolve(NotificationService)
  private notifier?: NotificationService;
  private lastNotificationMoment?: number;
  private rateThreshold = 150;
  private notifInterval = 180000; // in milliseconds, 3 minutes

  startMeasure() {
    try {
      sensor.on(sensor.SensorId.HEART_RATE, (res) => {
        this.rate = res.heartRate;

        if (this.rate > this.rateThreshold &&
          (this.lastNotificationMoment === undefined ||
            Date.now() - this.lastNotificationMoment > this.notifInterval)) {
          console.info(this.rate.toString());
          console.info('sending notification');
          this.notifier?.sendInstantNotification('Slow down.', 'Your heart rate is too high.');
          this.lastNotificationMoment = Date.now();
        }
      });
    } catch (error) {
      console.info(`startMeasure: ${error}`);
    }
  }

  stopMeasure() {
    try {
      sensor.off(sensor.SensorId.HEART_RATE);
    } catch (error) {
      console.info(`stopMeasure: ${error}`);
    }
  }
}