import { ComponentContent, ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';

@Component
export struct Profile {
  header: ComponentContent<object> = new ComponentContent(this.getUIContext(), wrapBuilder(customHeader))
  @Consume('navStack') private navStack: NavPathStack;

  build() {
    Flex({ wrap: FlexWrap.Wrap }) {
      ArcList({ header: this.header }) {

        ArcListItem() {
          Row() {
            Button($r('app.string.account'))
              .margin(5)
              .width('85%')
              .backgroundColor($r('app.color.main'))
              .fontColor($r('app.color.on_main'))
              .onClick(() => {
                this.navStack.pushPath({ name: 'Account' });
              })
          }
        }

        ArcListItem() {
          Row() {
            Button($r('app.string.gym_subscription'))
              .margin(5)
              .width('85%')
              .backgroundColor($r('app.color.main'))
              .fontColor($r('app.color.on_main'))
              .onClick(() => {
                this.navStack.pushPath({ name: 'MembershipInformation' });
              })
          }
        }

        ArcListItem() {
          Row() {
            Button($r('app.string.EntryQR'))
              .backgroundColor($r('app.color.main'))
              .margin(5)
              .width('85%')
              .fontColor($r('app.color.on_main'))
              .onClick(() => {
                this.navStack.pushPathByName('QRGenerateComponentPage', 'ScanMe', true);
              })
          }
        }

        ArcListItem() {
          Row() {
            Button($r('app.string.near_gym'))
              .margin(5)
              .width('85%')
              .backgroundColor($r('app.color.main'))
              .fontColor($r('app.color.on_main'))
              .onClick(() => {
                this.navStack.pushPath({ name: 'NearByGyms' });
              })
          }
        }
      }.width('100%')
      .height('100%')
    }
  }
}

@Builder
function
customHeader() {
  Text($r('app.string.profile'))
    .fontSize(24)
    .margin({ bottom: 8 });
}