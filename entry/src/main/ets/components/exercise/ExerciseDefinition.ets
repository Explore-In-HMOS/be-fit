import { Exercise } from '../../model/Routine'

@Builder
export function ExerciseDefinitionBuilder() {
  ExerciseDefinition();
}

@Component
 struct ExerciseDefinition {
  private exercise?: Exercise;

  build() {
    NavDestination() {
      Column() {
        Text(this.exercise?.name)
          .fontSize(24)
          .width('100%');
      }
      .width('70%')
      .margin({ top: '15%' });

      Scroll() {
        Text(this.exercise?.description)
          .width('70%')
          .padding({ bottom: '15%' });
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1);
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.background'))
    .onReady((context: NavDestinationContext) => {
      this.exercise = context.pathInfo.param as Exercise;
    });
  }
}