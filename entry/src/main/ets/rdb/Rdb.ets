import { relationalStore as rs } from '@kit.ArkData';
import { Analysis } from '../model/Analysis';
import { Exercise, Routine } from '../model/Routine';
import { Injectable } from '../registry/Injectable';

export class Rdb extends Injectable {
  private readonly _db: Promise<rs.RdbStore>;

  async onDispose(): Promise<void> {
    const db = await this._db;
    db.close().catch((err: BusinessError) => {
      console.info(`Failed to close Rdb. Code:${err.code}, message:${err.message}`);
    });
  }

  constructor(context: Context) {
    super();
    this._db = this.initRdb(context)
      .then((store) => {
        console.info(`Succeeded in getting RdbStore, version: ${store.version}`);
        return store;
      })
      .catch((err: BusinessError) => {
        const message = `Failed to get RdbStore. Code:${err.code}, message:${err.message}`;
        console.info(message);
        throw new Error(message);
      });
  }

  /**
   * Initializes the relational database (RDB) store for the application.
   *
   * On first run (version 0), creates the required schema and sets the database
   * version to 1. On subsequent runs, skips initialization and opens the
   * existing store.
   * @param context - The application context used to obtain the RDB store.
   * @throws { BusinessError }
   * @returns A promise that resolves to the initialized {@link rs.RdbStore} instance.
   */
  private async initRdb(context: Context): Promise<rs.RdbStore> {
    const DB_CONFIG: rs.StoreConfig = {
      name: 'main.db',
      securityLevel: rs.SecurityLevel.S4,
      encrypt: true
    };

    const _database = await rs.getRdbStore(context, DB_CONFIG);
    if (_database.version === 0) {
      await _database.executeSql('CREATE TABLE IF NOT EXISTS routines(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, exerciseIds TEXT, exerciseGoals TEXT);');
      await _database.executeSql('CREATE TABLE IF NOT EXISTS workouts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, totalVolume INTEGER, time TEXT, categoryVolumes TEXT, effort INTEGER, date INTEGER);');
      _database.version = 1;
      console.info('RDB initialized');
    } else {
      console.info('RDB already initialized');
    }
    return _database;
  }

  async addRoutine(name: string, exercises: Exercise[]) {
    const routine: rs.ValuesBucket = {
      'name': name,
      'exerciseIds': exercises.map(e => e.id).join(','),
      'exerciseGoals': exercises.map(e => e.goal).join(',')
    };

    const db = await this._db;

    try {
      await db.insert('routines', routine);
    } catch (e) {
      console.info(`Error adding routine: ${e.code} | ${e.message}`);
    }
  }

  async getAllRoutines(): Promise<Routine[]> {
    const db = await this._db;

    const res: Routine[] = [];
    let pre: rs.ResultSet | undefined = undefined;
    try {
      pre = await db.querySql('select * from routines');
      while (pre.goToNextRow()) {
        const routine: Routine = {
          id: pre.getDouble(pre.getColumnIndex('id')),
          name: pre.getString(pre.getColumnIndex('name')),
          exercises: pre.getString(pre.getColumnIndex('exerciseIds'))
            .split(',')
            .map(id => CONST_EXERCISES.find(e => e.id === id)!)
        };

        const goals: number[] = pre.getString(pre.getColumnIndex('exerciseGoals'))
          .split(',')
          .map(g => Number.parseInt(g));

        for (let index = 0; index < routine.exercises.length; index++) {
          routine.exercises[index].goal = goals[index];
        }
        ;

        res.push(routine);
      }
    } catch (e) {
      console.info(`Error getting all routines: ${e.code} | ${e.message}`);
    } finally {
      pre?.close();
    }

    return res;
  }

  async addWorkout(workout: Analysis) {
    const work: rs.ValuesBucket = {
      'name': workout.name,
      'totalVolume': workout.totalVolume,
      'time': workout.time,
      'categoryVolumes': JSON.stringify(workout.categoryVolumes),
      'effort': workout.effort!,
      'date': workout.date!.getTime()
    };

    const db = await this._db;

    try {
      await db.insert('workouts', work);
    } catch (e) {
      console.info(`Error adding workout: ${e.code} | ${e.message}`);
    }
  }

  async getAllWorkouts(): Promise<Analysis[]> {
    const db = await this._db;

    const res: Analysis[] = [];
    let pre: rs.ResultSet | undefined = undefined;
    try {
      pre = await db.querySql('select * from workouts');
      while (pre.goToNextRow()) {
        const workout: Analysis = {
          name: pre.getString(pre.getColumnIndex('name')),
          totalVolume: pre.getDouble(pre.getColumnIndex('totalVolume')),
          time: pre.getString(pre.getColumnIndex('time')),
          categoryVolumes: JSON.parse(pre.getString(pre.getColumnIndex('categoryVolumes'))),
          effort: pre.getDouble(pre.getColumnIndex('effort')),
          date: new Date(pre.getDouble(pre.getColumnIndex('date')))
        };

        res.push(workout);
      }
    } catch (e) {
      console.info(`Error getting all workouts: ${e.code} | ${e.message}`);
    } finally {
      pre?.close();
    }

    return res;
  }
}

export const CONST_EXERCISES: Exercise[] = [
  // Chest
  {
    id: '1',
    name: 'Bench Press',
    category: 'Chest',
    description: 'Lie on a flat bench and press the barbell upward until your arms are fully extended. Lower it slowly to your chest with control.'
  },
  {
    id: '2',
    name: 'Incline Bench Press',
    category: 'Chest',
    description: 'Perform a bench press on an incline bench to target the upper chest. Lower the bar to your upper chest and press upward.'
  },
  {
    id: '3',
    name: 'Chest Fly',
    category: 'Chest',
    description: 'With dumbbells, open your arms wide at chest level and bring them together in a hugging motion. Keep a slight bend in your elbows.'
  },
  {
    id: '14',
    name: 'Dumbbell Press',
    category: 'Chest',
    description: 'Press two dumbbells upward while lying on a bench. Lower them slowly until elbows are at chest level.'
  },
  {
    id: '15',
    name: 'Decline Bench Press',
    category: 'Chest',
    description: 'Lie on a decline bench and press the barbell upward. Focus on engaging the lower chest during the movement.'
  },
  // Back
  {
    id: '4',
    name: 'Lat Pulldown',
    category: 'Back',
    description: 'Pull the bar down toward your upper chest while seated. Squeeze your shoulder blades together at the bottom.'
  },
  {
    id: '5',
    name: 'Barbell Row',
    category: 'Back',
    description: 'Bend at the hips and pull the barbell toward your lower chest. Keep your back straight throughout the movement.'
  },
  {
    id: '6',
    name: 'Deadlift',
    category: 'Back',
    description: 'Lift the barbell from the ground by extending your hips and knees. Keep the bar close to your body and back neutral.'
  },
  {
    id: '7',
    name: 'Pull Up',
    category: 'Back',
    description: 'Hang from a bar and pull your body upward until your chin passes the bar. Lower yourself in a controlled manner.'
  },
  {
    id: '16',
    name: 'Close Grip Row',
    category: 'Back',
    description: 'Using a close grip handle, pull toward your torso while seated. Focus on squeezing the middle back.'
  },
  {
    id: '17',
    name: 'Wide Grip Row',
    category: 'Back',
    description: 'Use a wide grip to pull the handle toward your chest. Keep your chest up and shoulders back.'
  },
  // Shoulders
  {
    id: '8',
    name: 'Shoulder Press',
    category: 'Shoulders',
    description: 'Press dumbbells or a barbell overhead until arms are extended. Lower slowly to shoulder level.'
  },
  {
    id: '9',
    name: 'Lateral Raise',
    category: 'Shoulders',
    description: 'Raise dumbbells to the sides until arms are parallel to the floor. Lower them slowly with control.'
  },
  {
    id: '18',
    name: 'Rear Delt Fly',
    category: 'Shoulders',
    description: 'Bend slightly forward and raise dumbbells out to the sides. Focus on contracting the rear shoulders.'
  },
  {
    id: '19',
    name: 'Overhead Press',
    category: 'Shoulders',
    description: 'Press the barbell or dumbbells straight overhead. Keep your core tight and avoid arching your back.'
  },
  {
    id: '20',
    name: 'Seated Smith Machine Press',
    category: 'Shoulders',
    description: 'Sit under the Smith machine bar and press it overhead. Lower the bar slowly to shoulder height.'
  },
  {
    id: '21',
    name: 'Front Raises',
    category: 'Shoulders',
    description: 'Lift dumbbells in front of you to shoulder height. Lower them slowly to the starting position.'
  },
  // Legs
  {
    id: '10',
    name: 'Squat',
    category: 'Legs',
    description: 'Lower your hips back and down until thighs are parallel to the floor. Push through your heels to stand up.'
  },
  {
    id: '11',
    name: 'Leg Press',
    category: 'Legs',
    description: 'Push the platform away using your feet while seated. Lower it slowly until knees are bent at 90 degrees.'
  },
  {
    id: '22',
    name: 'Leg Curl',
    category: 'Legs',
    description: 'Bend your knees to bring your heels toward your glutes. Control the movement on the way back.'
  },
  {
    id: '23',
    name: 'Leg Extension',
    category: 'Legs',
    description: 'Extend your legs forward until fully straight. Lower the weight slowly to the starting position.'
  },
  // Arms
  {
    id: '12',
    name: 'Biceps Curl',
    category: 'Biceps',
    description: 'Curl the dumbbells upward by bending your elbows. Lower them slowly without swinging.'
  },
  {
    id: '13',
    name: 'Triceps Extension',
    category: 'Triceps',
    description: 'Extend your arms to straighten the elbows while holding a weight. Lower it slowly behind your head.'
  },
  {
    id: '24',
    name: 'Preacher Curl',
    category: 'Biceps',
    description: 'Rest your arms on a preacher bench and curl the bar upward. Lower slowly for full stretch.'
  },
  {
    id: '25',
    name: 'Overhead Triceps Extension',
    category: 'Triceps',
    description: 'Hold a dumbbell overhead and extend your arms fully. Lower it behind your head with control.'
  }
];