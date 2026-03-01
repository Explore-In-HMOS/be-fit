import {
  ArcButton,
  ArcButtonOptions,
  ArcButtonPosition,
  ArcButtonStatus,
  ArcButtonStyleMode,
  ArcList,
  ArcListItem,
  ArcListAttribute,
  ArcListItemAttribute,
  ColorMetrics,
  ComponentContent
} from '@kit.ArkUI';
import { Analysis, CategoryVolume } from '../../model/Analysis';
import { Routine } from '../../model/Routine';
import { Rdb } from '../../rdb/Rdb';
import { Resolve } from '../../registry/ServiceRegistry';

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
export struct WorkoutAnalysis {
  @Resolve(Rdb)
  private rdb?: Rdb;
  @Consume('navStack') private navStack: NavPathStack;
  @State private selectedLevel: number = 1;
  private levels: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  private header: ComponentContent<object> = new ComponentContent(this.getUIContext(), wrapBuilder(customHeader));
  private routine?: Routine;
  @State private analysis?: Analysis = undefined;

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
                    .fontColor(level === this.selectedLevel ? Color.Black :
                      $r('app.color.main'))
                }
                .borderWidth(1)
                .borderColor(level <= this.selectedLevel ? $r('app.color.main') :
                  Color.White)
                .onClick(() => {
                  this.selectedLevel = level;
                })
                .width(16)
                .height(20 + level * 5)
                .backgroundColor(level === this.selectedLevel ? $r('app.color.main') :
                  $r('app.color.background'))
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

        ArcButton({
          options: new ArcButtonOptions({
            label: 'Confirm',
            fontColor: ColorMetrics.resourceColor(Color.Black),
            status: ArcButtonStatus.NORMAL,
            backgroundColor: ColorMetrics.resourceColor($r('app.color.main')),
            styleMode: ArcButtonStyleMode.CUSTOM,
            position: ArcButtonPosition.BOTTOM_EDGE,
            onClick: async () => {
              this.analysis!.effort = this.selectedLevel;
              this.analysis!.date = new Date();
              await this.rdb?.addWorkout(this.analysis!);
              this.navStack.popToName('/', { refresh: true });
            }
          })
        }).padding({ top: 2 })
      }
      .alignContent(Alignment.Bottom)
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.background'))
    .onReady((context: NavDestinationContext) => {
      this.routine = context.pathInfo.param as Routine;

      this.setAnalysis();
    })
  }

  private setAnalysis() {
    const exercises = this.routine?.exercises;
    if (exercises === undefined) {
      return;
    }

    let totalVolume = 0;
    for (let index = 0; index < exercises.length; index++) {
      totalVolume += exercises[index].volume ?? 0;
    }

    const categoryVolumesRecord: Record<string, number> = {};
    if (totalVolume !== 0) {
      for (let index = 0; index < exercises.length; index++) {
        const ex = exercises[index];
        const vol = ex.volume ?? 0;
        if (vol !== 0) {
          if (!categoryVolumesRecord[ex.category]) {
            categoryVolumesRecord[ex.category] = vol;
          } else {
            categoryVolumesRecord[ex.category] += vol;
          }
        }
      }
    }

    const categoryVolumes = Object.keys(categoryVolumesRecord).map(cat => {
      return {
        category: cat,
        volume: Math.round((categoryVolumesRecord[cat] / totalVolume) * 100)
      } as CategoryVolume;
    });

    this.analysis = {
      name: this.routine?.name ?? '-|-',
      totalVolume: totalVolume,
      categoryVolumes: categoryVolumes,
      time: this.routine?.totalTime ?? '-|-'
    };

    console.info(`Final Analysis: ${JSON.stringify(this.analysis)}`);
  }
}

@Builder
function
customHeader() {
  Text($r('app.string.workout_analysis'))
    .fontSize(20)
    .padding({ top: 8 });
}