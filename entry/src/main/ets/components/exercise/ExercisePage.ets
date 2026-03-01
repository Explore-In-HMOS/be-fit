import { Exercise } from '../../model/Routine';
import { HeartRateVM } from '../../viewmodel/HeartRateVM';

@Component
export struct ExercisePage {
  @Consume('navStack') private navStack: NavPathStack;
  @State private hr: HeartRateVM = new HeartRateVM();
  @State private heartFontSize: number = 24;
  private exercise?: Exercise;
  @State private current: number = -1;
  @State private goal: number = -1;
  @State private kg: number = 10;
  @State private reps: number = 10;
  // constants
  private kgRange: string[] =
    Array.from({ length: 41 } as ArrayLike<number>, (_: number, i: number): string => (i * 2.5).toString());
  private repsRange: string[] =
    Array.from({ length: 20 } as ArrayLike<number>, (_: number, i: number): string => (i + 1).toString());
  private setVolumes: Map<number, number> = new Map();

  aboutToAppear(): void {
    this.hr.startMeasure();
    this.getUIContext().getFocusController().activate(true, false);
  }

  aboutToDisappear(): void {
    this.hr.stopMeasure();
    this.getUIContext().getFocusController().activate(false);
  }

  build() {
    NavDestination() {
      Column() {
        Row() {
          SymbolGlyph($r('sys.symbol.heart_fill'))
            .fontColor([Color.Red])
            .fontSize(this.heartFontSize)
            .aspectRatio(1)
            .height('100%')
            .animation({
              duration: 500,
              curve: Curve.Linear,
              iterations: -1,
              playMode: PlayMode.Alternate
            })
            .onAppear(() => {
              this.heartFontSize = 16;
            });

          Text(this.hr.rate ? `${this.hr.rate}` : '...')
            .textAlign(TextAlign.Start)
            .width('50%');
        }
        .justifyContent(FlexAlign.End)
        .width('100%')
        .height('15%');

        Column() {
          Text(this.exercise?.name);
          Text(`Set ${this.current} / ${this.goal}`).fontSize(12).fontColor(Color.Gray);
        }
        .alignItems(HorizontalAlign.Start)
        .width('70%');

        Row() {
          Column() {
            Text('KG')
            TextPicker({ range: this.kgRange, selected: 4 })
              .onChange((val) => {
                this.kg = Number.parseFloat(val as string);
              })
              .canLoop(false)
              .backgroundColor(Color.Transparent)
              .defaultPickerItemHeight(30)
              .selectedTextStyle({
                color: Color.White
              })
              .height(55)
              .gradientHeight(0)
              .borderWidth(1)
              .borderColor(Color.White)
              .borderRadius(8)
              .margin({ top: 2 });
          }
          .justifyContent(FlexAlign.Center)
          .width('50%')
          .height('100%')
          .margin({ right: 2 });

          Column() {
            Text('Reps')
            TextPicker({ range: this.repsRange, selected: 9 })
              .onChange((val) => {
                this.reps = Number.parseInt(val as string);
              })
              .canLoop(false)
              .backgroundColor(Color.Transparent)
              .defaultPickerItemHeight(30)
              .selectedTextStyle({
                color: Color.White
              })
              .height(55)
              .gradientHeight(0)
              .borderWidth(1)
              .borderColor(Color.White)
              .borderRadius(8)
              .margin({ top: 2 });
          }
          .justifyContent(FlexAlign.Center)
          .width('50%')
          .height('100%')
          .margin({ left: 2 });
        }
        .focusable(false)
        .width('70%')
        .layoutWeight(1);

        Row() {
          Button('<')
            .type(ButtonType.Circle)
            .backgroundColor(Color.Gray)
            .height('100%')
            .enabled(this.current !== 1)
            .onClick(() => {
              this.current--;

              if (this.current >= this.exercise!.goal!) {
                this.goal = this.current;
              }

              this.setVolumes.delete(this.current!);
            });

          Button('✓')
            .type(ButtonType.Capsule)
            .backgroundColor($r('app.color.main'))
            .fontColor($r('app.color.on_main'))
            .height('100%')
            .layoutWeight(1)
            .margin({ left: 4, right: 4 })
            .focusable(false)
            .onClick(() => {
              this.setVolumes.set(this.current, this.kg * this.reps);

              const volume = Array.from(this.setVolumes.values()).reduce((a, b) => a + b, 0);

              this.exercise!.current = this.current;
              this.exercise!.setVolumes = this.setVolumes;
              this.exercise!.volume = volume;

              console.info(`exercise volume: ${this.exercise?.volume}`);

              this.navStack.pop('');
            });

          Button('>')
            .type(ButtonType.Circle)
            .backgroundColor(Color.Gray)
            .height('100%')
            .defaultFocus(true)
            .onClick(() => {
              this.setVolumes.set(this.current, this.kg * this.reps);

              this.current!++;

              if (this.current > this.goal) {
                this.goal = this.current;
              }
            });
        }
        .size({ width: '70%', height: 40 })
        .margin({ bottom: '15%' });
      }
      .backgroundColor($r('app.color.background'))
      .size({ width: '100%', height: '100%' });
    }
    .hideTitleBar(true)
    .backgroundColor($r('app.color.background'))
    .onReady((context: NavDestinationContext) => {
      this.exercise = context.pathInfo.param as Exercise;
      this.current = this.exercise.current ?? 1;
      this.goal = this.current > this.exercise.goal! ? this.current : this.exercise.goal!;
      this.setVolumes = new Map<number, number>(this.exercise.setVolumes);

      console.info(`initial volumes: ${JSON.stringify(Array.from(this.setVolumes.entries()))}`);
    })
  }
}