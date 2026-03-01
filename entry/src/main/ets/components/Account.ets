import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute } from '@ohos.arkui.ArcList';
import { ComponentContent } from '@kit.ArkUI';

@Component
export struct Account {
  @Consume('navStack') navStack: NavPathStack;
  private header: ComponentContent<object> = new ComponentContent(this.getUIContext(), wrapBuilder(customHeader));

  build() {
    NavDestination() {
      ArcList({ header: this.header }) {
        ArcListItem() {
          Row() {
            Text('Name')
              .textAlign(TextAlign.Start)
              .layoutWeight(1)
              .fontColor(Color.Gray)

            Text('George')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
        }
        .width('90%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 8 })
        .align(Alignment.Start)

        ArcListItem() {

          Row() {
            Text('Surname')
              .textAlign(TextAlign.Start)
              .layoutWeight(1)
              .fontColor(Color.Gray)

            Text('Michael')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }

        }
        .width('90%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 8 })
        .align(Alignment.Start)

        ArcListItem() {
          Row() {
            Text('Weight')
              .textAlign(TextAlign.Start)
              .layoutWeight(1)
              .fontColor(Color.Gray)

            Text('79 kg')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
        }
        .width('90%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 8 })
        .align(Alignment.Start)

        ArcListItem() {
          Row() {
            Text('Height')
              .textAlign(TextAlign.Start)
              .layoutWeight(1)
              .fontColor(Color.Gray)

            Text('188 cm')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
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
  Text($r('app.string.account'))
    .fontSize(20)
    .padding({ top: 8 });
}
