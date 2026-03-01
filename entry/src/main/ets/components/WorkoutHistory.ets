import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute, ComponentContent } from '@kit.ArkUI';
import { HistoryVM } from '../viewmodel/HistoryVM';
import { Analysis } from '../model/Analysis';

@Component
export struct WorkoutHistory {
  @ObjectLink historyVM: HistoryVM;
  @Consume('navStack') private navStack: NavPathStack;

  aboutToAppear(): void {
    this.historyVM.setExercises();
  }

  build() {
    if (this.historyVM.oldExercises === undefined) {
      Column() {
        LoadingProgress()
          .size({ width: 50, height: 50 })
          .color($r('app.color.main'));
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .size({ width: '100%', height: '100%' })
      .backgroundColor($r('app.color.background'));
    } else {
      ArcList({ header: new ComponentContent(this.getUIContext(), wrapBuilder(customHeader)) }) {
        if (this.historyVM.oldExercises.length === 0) {
          ArcListItem() {
            Text($r('app.string.not_found_exercise'))
              .fontColor(Color.Gray)
              .align(Alignment.Center)
              .fontSize(14);
          };
        } else {
          ForEach(this.historyVM.oldExercises, (analysis: Analysis) => {
            ArcListItem() {
              Column() {
                Text(analysis.name);
                Text(analysis.date?.toLocaleDateString())
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
            .width('90%')
            .padding(16)
            .margin({ top: 8 })
            .align(Alignment.Start)
            .borderRadius('50%')
            .backgroundColor($r('app.color.page_container'))
            .onClick(() => {
              this.navStack.pushPath({ name: 'HistoryDetail', param: analysis });
            });
          }, (analysis: Analysis) => JSON.stringify(analysis));
        }
      }
      .defaultFocus(true)
      .backgroundColor($r('app.color.background'))
      .size({ width: '100%', height: '100%' });
    }
  }
}

@Builder
function
customHeader() {
  Text($r('app.string.workout_history'))
    .fontSize(20)
    .padding({ top: 8 });
}
