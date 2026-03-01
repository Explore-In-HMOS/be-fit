import { ExerciseDefinitionBuilder } from '../components/exercise/ExerciseDefinition';
import { ExercisePage } from '../components/exercise/ExercisePage';
import { RoutineExercises } from '../components/exercise/RoutineExercises';
import { ExerciseList } from '../components/custom_routine/ExerciseList';
import { CustomRoutine } from '../components/custom_routine/CustomRoutine';
import { RoutineName } from '../components/custom_routine/RoutineName';
import { Resolve } from '../registry/ServiceRegistry';
import { PersistentStorageService } from '../util/PersistentStorageService';
import { WorkoutAnalysis } from '../components/exercise/WorkoutAnalysis';
import { HistoryDetail } from '../components/HistoryDetail';
import { HomeContent, HomeContentBuilder } from '../components/HomeContent';
import { QRGenerateComponentPageBuilder } from '../components/QRCodeGenerator';
import { MembershipInformation } from '../components/MembershipInformation';
import NearByGyms from '../components/NearByGyms';
import { Account } from '../components/Account';

@Entry
@Component
struct Index {
  @Provide('navStack') navStack: NavPathStack = new NavPathStack();
  @Resolve(PersistentStorageService)
  private strg?: PersistentStorageService;

  aboutToAppear(): void {
    this.strg?.init();
  }

  onDidBuild(): void {
    this.navStack.pushPath({ name: '/' });
  }

  build() {
    Navigation(this.navStack) {
    }
    .backgroundColor($r('app.color.background'))
    .navDestination(this.pageMap)
    .hideNavBar(true)
    .hideTitleBar(true)
  }

  @Builder
  pageMap(name: string) {
    if (name === 'ExercisePage') {
      ExercisePage();
    } else if (name === 'RoutineExercises') {
      RoutineExercises();
    } else if (name === 'ExerciseDefinition') {
      ExerciseDefinitionBuilder();
    } else if (name === 'CustomRoutine') {
      CustomRoutine();
    } else if (name === 'ExerciseList') {
      ExerciseList();
    } else if (name === 'RoutineName') {
      RoutineName();
    } else if (name === 'WorkoutAnalysis') {
      WorkoutAnalysis()
    } else if (name === 'HistoryDetail') {
      HistoryDetail()
    } else if (name === 'QRGenerateComponentPage') {
      QRGenerateComponentPageBuilder();
    } else if (name === 'MembershipInformation') {
      MembershipInformation();
    } else if (name === 'NearByGyms') {
      NearByGyms();
    } else if (name === 'Account') {
      Account();
    } else if (name === '/') {
      HomeContentBuilder();
    }
  }
}

