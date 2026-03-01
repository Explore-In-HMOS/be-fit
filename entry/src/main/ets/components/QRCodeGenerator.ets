@Builder
export function QRGenerateComponentPageBuilder() {
  QRGenerateComponentPage();
}

@Component
struct QRGenerateComponentPage {
  @Consume('navStack') navStack: NavPathStack;
  @State qrCodeInput: string = 'ScanMe!';

  aboutToAppear(): void {
    this.qrCodeInput = this.navStack.getParamByName('QRGenerateComponentPage')[0] as string;
  }

  build() {
    NavDestination() {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Column({ space: 10 }) {
          Text('Entry QR')
            .fontColor(Color.White)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
          Row() {
            QRCode(this.qrCodeInput)
              .color(Color.Green)
              .backgroundColor(Color.Black)
              .width('50%')
              .aspectRatio(1)
          }
          .padding(2)
          .backgroundColor(Color.Green)

          Text('Scan Me')
            .fontColor(Color.White)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
        }
        .width('100%')
        .height('100%')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
      .backgroundColor(Color.Black)
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}