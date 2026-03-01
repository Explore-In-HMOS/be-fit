import {
  ArcButton,
  ArcButtonOptions,
  ArcButtonPosition,
  ArcButtonStatus,
  ArcButtonStyleMode,
  ColorMetrics,
  ComponentContent,
  ArcList,
  ArcListItem,
  ArcListAttribute,
  ArcListItemAttribute
} from '@kit.ArkUI';
import { Exercise, Routine } from '../../model/Routine';
import { PermissionHandler } from '../../util/PermissionHandler';
import { ReminderService } from '../../util/ReminderService';
import { Resolve } from '../../registry/ServiceRegistry';
import { common } from '@kit.AbilityKit';

@Component
export struct RoutineExercises {
  @Resolve(ReminderService)
  private workoutReminder?: ReminderService;
  @Consume('navStack') private navStack: NavPathStack;
  private routine?: Routine;
  @State private exercises: Exercise[] = [];
  private intervalId?: number;
  @State @Watch('updateHeader') private currentTime: number = 0; // The exercise time in seconds
  private header = new ComponentContent<ParamsInterface>(this.getUIContext(), wrapBuilder(customHeader),
    { routineName: this.routine?.name ?? '', currentTime: this.currentTime });
  private bottomOptions: ArcButtonOptions = new ArcButtonOptions({
    position: ArcButtonPosition.BOTTOM_EDGE,
    label: $r('app.string.finish'),
    status: ArcButtonStatus.NORMAL,
    styleMode: ArcButtonStyleMode.CUSTOM,
    onClick: () => {
      this.routine!.totalTime = secondsFormatter(this.currentTime);
      this.navStack.pushPath({ name: 'WorkoutAnalysis', param: this.routine });
    }
  });

  aboutToAppear(): void {
    try {
      this.bottomOptions.fontColor = ColorMetrics.resourceColor(Color.Black);
      this.bottomOptions.backgroundColor = ColorMetrics.resourceColor($r('app.color.main'));
    } catch (_) {
    }

    const context = this.getUIContext().getHostContext()! as common.UIAbilityContext;
    PermissionHandler.getNotificationPermission(context).then(() => {
      this.workoutReminder?.setReminder();
      PermissionHandler.checkPermission(context, ['ohos.permission.READ_HEALTH_DATA']).then(() => {
        this.intervalId = setInterval(() => {
          this.currentTime += 1;
        }, 1000);
      });
    });
  }

  aboutToDisappear(): void {
    clearInterval(this.intervalId);
  }

  updateHeader() {
    this.header.update({
      routineName: this.routine?.name ?? '',
      currentTime: this.currentTime
    });
  }

  build() {
    NavDestination() {
      Stack() {
        ArcList({ header: this.header }) {
          ForEach(this.exercises, (exercise: Exercise) => {
            ArcListItem() {
              Column() {
                Row() {
                  Text(exercise.name)
                    .layoutWeight(1)
                    .textAlign(TextAlign.Start);

                  SymbolGlyph($r('sys.symbol.questionmark_circle'))
                    .fontColor([$r('app.color.main')])
                    .fontSize(24)
                    .onClick(() => {
                      this.navStack.pushPath({
                        name: 'ExerciseDefinition',
                        param: exercise
                      });
                    });
                };

                Text(`${exercise.current ?? 0} / ${exercise.goal!}`)
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
              this.navStack.pushPath({
                name: 'ExercisePage',
                param: this.routine?.exercises.find((e) => e.id === exercise.id)!,
                onPop: () => {
                  this.exercises = this.routine?.exercises;
                }
              });
            });
          }, (exercise: Exercise) => JSON.stringify(exercise));
        }
        .defaultFocus(true)
        .backgroundColor($r('app.color.background'))
        .size({ width: '100%', height: '100%' });

        ArcButton({ options: this.bottomOptions })
      }
      .size({ width: '100%', height: '100%' })
      .alignContent(Alignment.Bottom)
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.background'))
    .onReady((context: NavDestinationContext) => {
      this.routine = context.pathInfo.param as Routine;
      this.exercises = this.routine.exercises;

      this.header.update({
        routineName: this.routine?.name ?? '',
        currentTime: this.currentTime
      });
    });
  }
}

@Builder
function customHeader(par: ParamsInterface) {
  Column() {
    Text(par.routineName)
      .margin({ bottom: 8 })
      .fontSize(24);

    Text(secondsFormatter(par.currentTime));
  };
}

interface ParamsInterface {
  routineName: string;
  currentTime: number;
}

function secondsFormatter(secs: number) {
  const seconds = (secs % 60).toString().padStart(2, '0');
  const minutes = Math.floor(secs / 60).toString().padStart(2, '0');
  const hours = Math.floor(secs / 3600).toString().padStart(2, '0');

  return `${hours}:${minutes}:${seconds}`;
}
