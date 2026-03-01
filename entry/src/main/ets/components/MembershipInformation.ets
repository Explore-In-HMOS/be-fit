import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute } from '@ohos.arkui.ArcList';
import { ComponentContent } from '@kit.ArkUI';

@Component
export struct MembershipInformation {
  @Consume('navStack') navStack: NavPathStack;
  private header: ComponentContent<object> = new ComponentContent(this.getUIContext(), wrapBuilder(customHeader));

  build() {
    NavDestination() {
      ArcList({ header: this.header }) {
        ArcListItem() {
          Row() {
            Text('Status')
              .textAlign(TextAlign.Start)
              .layoutWeight(1)

            Text('Active')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Green)
          }
        }
        .width('90%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 8 })
        .align(Alignment.Start)

        ArcListItem() {

          Row() {
            Text('Days Left')
              .textAlign(TextAlign.Start)
              .layoutWeight(1)

            Text('182')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Green)
          }

        }
        .width('90%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 8 })
        .align(Alignment.Start)

        ArcListItem() {
          Row() {
            Text('Expires')
              .textAlign(TextAlign.Start)
              .layoutWeight(1)

            Text('25/08/2026')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Green)
          }
        }
        .width('90%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 8 })
        .align(Alignment.Start)
      }
      .defaultFocus(true)
      .backgroundColor($r('app.color.background'))
      .size({ width: '100%', height: '100%' });
    }
    .backgroundColor($r('app.color.background'))
    .hideTitleBar(true)

  }
}

@Builder
function
customHeader() {
  Text('Subscription')
    .fontSize(20)
    .padding({ top: 8 });
}
