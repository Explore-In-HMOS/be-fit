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
import { CONST_EXERCISES } from '../../rdb/Rdb';
import { Exercise } from '../../model/Routine';

@Component
export struct ExerciseList {
  @Consume('navStack') private navStack: NavPathStack;
  @State private selectedExercises: Exercise[] = [];
  private bottomOptions: ArcButtonOptions = new ArcButtonOptions({
    label: $r('app.string.confirm'),
    status: ArcButtonStatus.NORMAL,
    styleMode: ArcButtonStyleMode.CUSTOM,
    position: ArcButtonPosition.BOTTOM_EDGE,
    onClick: () => {
      console.info(`ExerciseList.pop.selected: ${JSON.stringify(this.selectedExercises)}`);
      this.navStack.pop(this.selectedExercises);
    }
  });
  private header: ComponentContent<object> = new ComponentContent(this.getUIContext(), wrapBuilder(customHeader));

  aboutToAppear(): void {
    try {
      this.bottomOptions.fontColor = ColorMetrics.resourceColor(Color.Black);
      this.bottomOptions.backgroundColor = ColorMetrics.resourceColor($r('app.color.main'));
    } catch (_) {
    }
  }

  isExerciseSelected(id: string): boolean {
    return this.selectedExercises.some(item => item.id === id);
  }

  toggleSelection(exercise: Exercise) {
    if (this.isExerciseSelected(exercise.id)) {
      this.selectedExercises = this.selectedExercises.filter(item => item.id !== exercise.id);
    } else {
      this.selectedExercises = [...this.selectedExercises, exercise];
    }
    console.info(`after toggle ${JSON.stringify(this.selectedExercises)}`);
  }

  build() {
    NavDestination() {
      Stack() {
        ArcList({
          header: this.header
        }) {
          ForEach(CONST_EXERCISES, (item: Exercise) => {
            ArcListItem() {
              Row() {
                Column() {
                  Text(item.name).fontSize(16).fontWeight(FontWeight.Medium);
                  Text(item.category).fontSize(12).fontColor(Color.Gray);
                }.alignItems(HorizontalAlign.Start).layoutWeight(1);

                Checkbox({ name: item.id })
                  .select(this.isExerciseSelected(item.id))
                  .enabled(false)
                  .selectedColor($r('sys.color.brand'));
              }
              .borderColor(Color.White)
              .borderWidth(1)
              .width('90%')
              .height('30%')
              .padding(16)
              .margin({ top: 8 })
              .align(Alignment.Start)
              .borderRadius('50%')
              .backgroundColor($r('app.color.page_container'))
              .backgroundColor(this.isExerciseSelected(item.id) ? $r('app.color.page_container') : Color.Black)
              .onClick(() => {
                this.toggleSelection(item);
              });
            };
          }, (item: Exercise) => item.id);
        }
        .width('100%')
        .height('100%')

        ArcButton({ options: this.bottomOptions });
      }
      .alignContent(Alignment.Bottom)
      .width('100%')
      .height('100%')
    }
    .onReady((context: NavDestinationContext) => {
      console.info(`ExerciseList:onReady:context.param: ${JSON.stringify(context.pathInfo.param)}`);
      this.selectedExercises = context.pathInfo.param as Exercise[];
      console.info(`ExerciseList:onReady:exercises: ${JSON.stringify(this.selectedExercises)}`);
    })
    .backgroundColor($r('app.color.background'))
    .hideTitleBar(true);
  }
}

@Builder
function
customHeader() {
  Text($r('app.string.exercises'))
    .fontSize(24)
    .margin({ bottom: 8 });
}
