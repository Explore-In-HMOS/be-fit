import { ComponentContent, ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute } from '@kit.ArkUI';
import { Routine } from '../model/Routine';
import { RoutinesVM } from '../viewmodel/RoutinesVM';

@Component
export struct Routines {
  @Consume('navStack') private navStack: NavPathStack;
  @ObjectLink routinesVM: RoutinesVM;

  aboutToAppear(): void {
    this.routinesVM.setRoutines();
  }

  build() {
    if (this.routinesVM.routines === undefined) {
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
      ArcList({
        header: new ComponentContent(this.getUIContext(), wrapBuilder(customHeader), () => {
          this.navStack.pushPath({ name: 'CustomRoutine' });
        })
      }) {
        if (this.routinesVM.routines.length === 0) {
          ArcListItem() {
            Text($r('app.string.empty_routines'))
              .fontColor(Color.Gray)
              .align(Alignment.Center)
              .fontSize(14);
          };
        } else {
          ForEach(this.routinesVM.routines, (routine: Routine) => {
            ArcListItem() {
              Text(routine.name);
            }
            .width('90%')
            .padding(16)
            .margin({ top: 8 })
            .align(Alignment.Start)
            .borderRadius('50%')
            .backgroundColor($r('app.color.page_container'))
            .onClick(() => {
              this.navStack.pushPath({ name: 'RoutineExercises', param: JSON.parse(JSON.stringify(routine)) });
            });
          }, (routine: Routine) => JSON.stringify(routine));
        }
      }
      .defaultFocus(true)
      .backgroundColor($r('app.color.background'))
      .size({ width: '100%', height: '100%' });
    }
  }
}

@Builder
function customHeader(event: (event: ClickEvent) => void) {
  Column() {
    Text($r('app.string.routines'))
      .fontSize(24)
      .margin({ bottom: 8 });

    Button($r('app.string.plus_new'))
      .fontColor($r('app.color.on_main'))
      .width('60%')
      .align(Alignment.Center)
      .borderRadius('50%')
      .backgroundColor($r('app.color.main'))
      .onClick(event);
  };
}