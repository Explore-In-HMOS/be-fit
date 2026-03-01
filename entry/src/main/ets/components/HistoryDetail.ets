import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute, ComponentContent } from '@kit.ArkUI';
import { Analysis, CategoryVolume } from '../model/Analysis';

@Component
@Reusable
struct WorkedPart {
  @Prop progressValue: number = 0;
  @Prop categoryName: string;

  build() {
    Row({ space: 10 }) {
      Text(this.categoryName).width('65%').textAlign(TextAlign.Start)
      Progress({ value: this.progressValue, total: 100, type: ProgressType.Capsule })
        .width('35%')
        .height(20)
        .color($r('app.color.main'))
        .borderColor(Color.White)
        .borderWidth(2)
        .borderRadius(15)
    }
  }
}

@Component
export struct HistoryDetail {
  @Consume('navStack') navStack: NavPathStack;
  private levels: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  private header: ComponentContent<object> = new ComponentContent(this.getUIContext(), wrapBuilder(customHeader));
  private analysis?: Analysis;

  build() {
    NavDestination() {
      Stack() {
        ArcList({ header: this.header }) {
          ArcListItem() {
            Text(this.analysis?.name).fontSize(20)
          }
          .width('90%')
          .padding({ left: 16 })
          .margin({ top: 8 })
          .align(Alignment.Start)

          ArcListItem() {
            Text(`Time: ${this.analysis?.time}`)
          }
          .width('90%')
          .padding({ left: 16 })
          .margin({ top: 8 })
          .align(Alignment.Start)

          ArcListItem() {
            Text(`Total Volume: ${this.analysis?.totalVolume}`)
          }
          .width('90%')
          .padding({ left: 16 })
          .margin({ top: 8 })
          .align(Alignment.Start)

          ForEach(this.analysis?.categoryVolumes, (item: CategoryVolume) => {
            ArcListItem() {
              WorkedPart({ categoryName: item.category, progressValue: item.volume })
            }
            .width('90%')
            .padding({ left: 16, right: 16 })
            .margin({ top: 8 })
          }, (item: CategoryVolume) => item.category)

          ArcListItem() {
            Row({ space: 1 }) {
              ForEach(this.levels, (level: number) => {
                Button({ buttonStyle: ButtonStyleMode.NORMAL }) {
                  Text(level.toString())
                    .fontSize(14)
                    .fontColor(level === this.analysis!.effort ? Color.Black :
                      $r('app.color.main'))
                }
                .borderWidth(1)
                .borderColor(level <= this.analysis!.effort! ? $r('app.color.main') : Color.White)
                .width(16)
                .height(20 + level * 5)
                .backgroundColor(level === this.analysis!.effort ? $r('app.color.main') : $r('app.color.background'))
                .margin(2)
              }, (level: number) => level.toString())
            }.alignItems(VerticalAlign.Bottom)
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
      .alignContent(Alignment.Bottom)
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.background'))
    .onReady((context: NavDestinationContext) => {
      this.analysis = context.pathInfo.param as Analysis;
    })
  }
}

@Builder
function
customHeader() {
  Text($r('app.string.workout_analysis'))
    .fontSize(20)
    .padding({ top: 8 });

}