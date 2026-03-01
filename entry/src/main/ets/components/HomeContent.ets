import { ArcSwiper, ArcSwiperAttribute } from '@kit.ArkUI';
import { HistoryVM } from '../viewmodel/HistoryVM';
import { RoutinesVM } from '../viewmodel/RoutinesVM';
import { Profile } from './Profile';
import { Routines } from './Routines';
import { WorkoutHistory } from './WorkoutHistory';

interface RefreshParam {
  refresh: boolean;
}

@Builder
export function HomeContentBuilder() {
  HomeContent();
}

@Component
export struct HomeContent {
  @State private historyVM: HistoryVM = new HistoryVM();
  @State private routinesVM: RoutinesVM = new RoutinesVM();

  build() {
    NavDestination() {
      ArcSwiper() {
        WorkoutHistory({ historyVM: this.historyVM });
        Routines({ routinesVM: this.routinesVM });
        Profile();
      }
      .index(1)
      .backgroundColor($r('app.color.background'))
      .size({ width: '100%', height: '100%' });
    }
    .backgroundColor($r('app.color.background'))
    .hideTitleBar(true)
    .onResult((param: Object) => {
      if (param !== undefined) {
        console.info(`HomeContent:onresult:param: ${JSON.stringify(param)}`);
        const refresh = param as RefreshParam;
        console.info(`HomeContent:onresult:data: ${JSON.stringify(refresh)}`);
        if (refresh.refresh) {
          this.routinesVM.setRoutines();
          this.historyVM.setExercises();
        }
      }
    });
  }
}