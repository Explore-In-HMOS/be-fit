import {
  ComponentContent,
  ArcButton,
  ArcButtonOptions,
  ArcButtonPosition,
  ArcButtonStatus,
  ArcButtonStyleMode,
  ColorMetrics,
  ArcList,
  ArcListItem,
  ArcListAttribute,
  ArcListItemAttribute
} from '@kit.ArkUI';
import { Exercise } from '../../model/Routine';

@Component
export struct CustomRoutine {
  @Consume('navStack') private navStack: NavPathStack;
  @State private selectedExercises: Exercise[] = [];
  private kgRange: string[] =
    Array.from({ length: 6 } as ArrayLike<number>, (_: number, i: number): string => (i + 1).toString());
  private bottomOptions: ArcButtonOptions = new ArcButtonOptions({
    label: $r('app.string.next'),
    status: ArcButtonStatus.NORMAL,
    styleMode: ArcButtonStyleMode.CUSTOM,
    position: ArcButtonPosition.BOTTOM_EDGE,
    onClick: () => {
      if (this.selectedExercises.length !== 0) {
        this.navStack.pushPath({ name: 'RoutineName', param: this.selectedExercises });
      }
    }
  });

  aboutToAppear(): void {
    try {
      this.bottomOptions.fontColor = ColorMetrics.resourceColor(Color.Black);
      this.bottomOptions.backgroundColor = ColorMetrics.resourceColor($r('app.color.main'));
    } catch (_) {
    }
  }

  build() {
    NavDestination() {
      Stack() {
        ArcList({
          header: new ComponentContent(this.getUIContext(), wrapBuilder(customHeader), () => {
            this.navStack.pushPath({ name: 'ExerciseList', param: this.selectedExercises });
          })
        }) {
          if (this.selectedExercises.length === 0) {
            ArcListItem() {
              Text($r('app.string.empty_exercise'))
                .fontColor(Color.Gray)
                .align(Alignment.Center)
                .fontSize(14);
            };
          } else {
            ForEach(this.selectedExercises, (item: Exercise) => {
              ArcListItem() {
                Row() {
                  Column() {
                    Text(item.name)
                      .fontSize(16)
                      .fontWeight(FontWeight.Medium);

                    Text(item.category)
                      .fontSize(12)
                      .fontColor(Color.Gray);
                  }.alignItems(HorizontalAlign.Start);

                  TextPicker({
                    range: this.kgRange,
                    selected: item.goal ? this.kgRange.indexOf(item.goal.toString()) : 0
                  })
                    .borderRadius('50%')
                    .canLoop(false)
                    .backgroundColor(Color.Transparent)
                    .defaultPickerItemHeight(30)
                    .selectedTextStyle({
                      color: ($r('app.color.main'))
                    })
                    .onChange((selectedSet: string | string[]) => {
                      const value = Array.isArray(selectedSet) ? selectedSet[0] : selectedSet;

                      item.goal = Number.parseInt(value);
                    })
                    .height(30)
                    .width(50)
                    .gradientHeight(0)
                    .borderWidth(1)
                    .borderColor(Color.White)
                    .margin({ top: 2 });
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .borderColor(Color.White)
                .borderWidth(1)
                .width('90%')
                .padding(16)
                .margin({ top: 8 })
                .align(Alignment.Start)
                .borderRadius('50%')
                .backgroundColor($r('app.color.page_container'));
              };
            }, (item: Exercise) => item.id);
          }
        }
        .backgroundColor($r('app.color.background'))
        .width('100%')
        .height('100%')
        .layoutWeight(1);

        ArcButton({ options: this.bottomOptions });
      }
      .alignContent(Alignment.Bottom)
      .width('100%')
      .height('100%');
    }
    .onResult((param: Object) => {
      if (param !== undefined) {
        console.info(`customroutine:onresult:param: ${JSON.stringify(param)}`);
        const data = param as Exercise[];
        console.info(`customroutine:onresult:data: ${JSON.stringify(data)}`);
        this.selectedExercises = data;
        console.info(`customroutine:onresult:selected: ${JSON.stringify(this.selectedExercises)}`);

        for (let index = 0; index < this.selectedExercises.length; index++) {
          if (this.selectedExercises[index].goal === undefined) {
            this.selectedExercises[index].goal = 1;
          }
        }
      }
    })
    .backgroundColor($r('app.color.background'))
    .hideTitleBar(true);
  }
}

@Builder
function customHeader(onBtnClicked: () => void) {
  Button($r('app.string.add_exercise'))
    .fontColor($r('app.color.on_main'))
    .width('60%')
    .align(Alignment.Center)
    .borderRadius('50%')
    .backgroundColor($r('app.color.main'))
    .onClick(onBtnClicked);
}

