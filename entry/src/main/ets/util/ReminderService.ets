import { Injectable } from '../registry/Injectable';
import { Resolve } from '../registry/ServiceRegistry';
import { PersistentStorageService } from './PersistentStorageService';
import { reminderAgentManager } from '@kit.BackgroundTasksKit';
import { notificationManager } from '@kit.NotificationKit';

export class ReminderService extends Injectable {
  onDispose?(): void {
  }

  @Resolve(PersistentStorageService)
  private strg?: PersistentStorageService;

  async setReminder() {
    console.info('set reminder');
    try {
      let reminderId = this.strg?.read('reminderId');

      if (reminderId !== undefined) {
        // remove old
        await this.removeReminder(reminderId);
      }

      // create reminder
      const now = new Date();
      const targetReminderAgent: reminderAgentManager.ReminderRequestAlarm = {
        reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM,
        hour: now.getHours(),
        minute: now.getMinutes(),
        daysOfWeek: [1, 2, 3, 4, 5, 6, 7], // Days of a week when the reminder repeats.
        actionButton: [
          {
            title: 'close',
            type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
          }
        ],
        wantAgent: {
          pkgName: 'com.hmosdemos.wearable.befit',
          abilityName: 'EntryAbility'
        },
        ringDuration: 5,
        title: 'Wanna be fit?',
        content: 'Let\'s workout for a better life.',
        notificationId: 1,
        slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION
      };

      reminderId = await reminderAgentManager.publishReminder(targetReminderAgent);

      this.strg?.set('reminderId', reminderId);
    } catch (e) {
      console.info(`setReminder: ${e} | ${JSON.stringify(e)}`);
    }
  }

  private async removeReminder(reminderId: number) {
    await reminderAgentManager.cancelReminder(reminderId).then(() => {
      console.info(`Succeeded in canceling reminder. ${reminderId}`);
    }).catch((err: BusinessError) => {
      console.info(`Failed to cancel reminder. Code: ${err.code}, message: ${err.message}`);
    });
  }
}