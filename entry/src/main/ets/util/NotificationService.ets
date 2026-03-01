import { Injectable } from '../registry/Injectable';
import { notificationManager } from '@kit.NotificationKit';

export class NotificationService extends Injectable {
  onDispose?(): void {
  }

  async sendInstantNotification(title: string, txt: string) {
    try {
      await notificationManager.publish({
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
          normal: {
            title: title,
            text: txt
          }
        }
      });
    } catch (error) {
      console.info(`sendInstantNotification: ${error}`);
    }
  }
}