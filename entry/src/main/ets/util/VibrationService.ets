import { Injectable } from '../registry/Injectable';
import { vibrator } from '@kit.SensorServiceKit';

export class VibrationService extends Injectable {
  onDispose?(): void {
  }

  async vibrate(duration: number = 200) {
    try {
      await vibrator.startVibration({ type: 'time', duration: duration }, { usage: 'physicalFeedback' });
    } catch (error) {
      console.info(`vibrate: ${error}`);
    }
  }
}