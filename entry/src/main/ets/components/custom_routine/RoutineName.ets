import {
  ArcButton,
  ArcButtonOptions,
  ArcButtonPosition,
  ArcButtonStatus,
  ArcButtonStyleMode,
  ColorMetrics
} from '@kit.ArkUI';
import { Exercise } from '../../model/Routine';
import { Rdb } from '../../rdb/Rdb';
import { Resolve } from '../../registry/ServiceRegistry';

@Component
export struct RoutineName {
  @Consume('navStack') private navStack: NavPathStack;
  @Resolve(Rdb)
  private rdb?: Rdb;
  @State private selectedExercises: Exercise[] = [];
  @State private routineName: string = '';
  private bottomOptions: ArcButtonOptions = new ArcButtonOptions({
    label: $r('app.string.confirm'),
    status: ArcButtonStatus.NORMAL,
    styleMode: ArcButtonStyleMode.CUSTOM,
    position: ArcButtonPosition.BOTTOM_EDGE,
    onClick: async () => {
      if (this.routineName.trim() !== '') {
        await this.rdb?.addRoutine(this.routineName, this.selectedExercises);
        this.navStack.popToName('/', { refresh: true });
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
      Flex({ justifyContent: FlexAlign.SpaceEvenly, wrap: FlexWrap.Wrap }) {
        Row() {
          Text($r('app.string.routine_name')).fontSize(16).textAlign(TextAlign.Center);
        }.alignItems(VerticalAlign.Center).margin({ bottom: 20 });

        TextInput()
          .borderWidth(2)
          .borderColor(Color.White)
          .width('90%')
          .onChange((input) => {
            this.routineName = input;
          });

        ArcButton({ options: this.bottomOptions }).padding({ top: 65 });
      }
      .padding({ top: 30 })
      .width('100%')
      .height('100%');
    }
    .onReady((context: NavDestinationContext) => {
      console.info(`RoutineName:onReady:context.param: ${JSON.stringify(context.pathInfo.param)}`);
      this.selectedExercises = context.pathInfo.param as Exercise[];
      console.info(`RoutineName:onReady:exercises: ${JSON.stringify(this.selectedExercises)}`);
    })
    .backgroundColor($r('app.color.background'))
    .hideTitleBar(true);
  }
}
