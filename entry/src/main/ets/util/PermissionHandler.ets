import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { notificationManager } from '@kit.NotificationKit';

export class PermissionHandler {
  public static async checkPermission(context: Context, permissions: Permissions[]) {
    const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();

    let granted = false;
    try {
      granted =
        (await atManager.requestPermissionsFromUser(context, permissions)).authResults.every((res) => res === 0);
    } catch (e) {
      console.info(`PermissionHandler.checkPermission: ${e}`);
    }

    return granted;
  }

  public static async getNotificationPermission(context: common.UIAbilityContext) {
    try {
      await notificationManager.requestEnableNotification(context);
    } catch (error) {
      console.info(`PermissionHandler.getNotificationPermission: ${error}`);
    }
  }
}