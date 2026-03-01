import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute } from '@ohos.arkui.ArcList';
import { ComponentContent } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';

@Component
export default struct NearByGyms {
  @Consume('navStack') navStack: NavPathStack;
  private header: ComponentContent<object> = new ComponentContent(this.getUIContext(), wrapBuilder(customHeader));

  build() {
    NavDestination() {
      ArcList({ header: this.header }) {
        ArcListItem() {
          Row() {
            Text('Star Gym')
              .textAlign(TextAlign.Start)
              .layoutWeight(1)
              .fontSize('14')

            Button('GO')
              .margin(5)
              .width('40%')
              .height('10%')
              .backgroundColor($r('app.color.main'))
              .fontColor($r('app.color.on_main'))
              .fontSize('14')
              .onClick(() => {
                openPetalMaps(this.getUIContext(), 41.02518451293842, 29.11610284719263)
              })
          }
        }
        .width('90%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 8 })
        .align(Alignment.Start)

        ArcListItem() {
          Row() {
            Text('Moon Gym')
              .textAlign(TextAlign.Start)
              .layoutWeight(1)
              .fontSize('14')

            Button('GO')
              .margin(5)
              .width('40%')
              .height('10%')
              .backgroundColor($r('app.color.main'))
              .fontColor($r('app.color.on_main'))
              .fontSize('14')
              .onClick(() => {
                openPetalMaps(this.getUIContext(), 41.02518451293842, 29.11610284719263)
              })
          }
        }
        .width('90%')
        .padding({ left: 16, right: 16 })
        .margin({ top: 8 })
        .align(Alignment.Start)

        ArcListItem() {
          Row() {
            Text('Mars Gym')
              .textAlign(TextAlign.Start)
              .layoutWeight(1)
              .fontSize('14')

            Button('GO')
              .margin(5)
              .width('40%')
              .height('10%')
              .backgroundColor($r('app.color.main'))
              .fontColor($r('app.color.on_main'))
              .fontSize('14')
              .onClick(() => {
                openPetalMaps(this.getUIContext(), 41.02410273988411, 29.11700855276439)
              })
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
  Text($r('app.string.near_gym'))
    .fontSize(20)
    .padding({ top: 8 });

}

function openPetalMaps(ability: UIContext, lat: number, long: number) {
  const petalMapWant: Want = {
    bundleName: 'com.huawei.hmos.maps.app',
    uri: 'maps://navigation',
    parameters: ({
      'linkSource': 'com.hmosdemos.wearable.befit',
      'destinationLatitude': lat,
      'destinationLongitude': long
      // vehicleType: 0,
      // coordinateType: 1
    })
  };

  const context = ability.getHostContext() as common.UIAbilityContext;
  context.startAbility(petalMapWant);

}