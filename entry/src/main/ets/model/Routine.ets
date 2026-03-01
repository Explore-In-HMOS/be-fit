export interface Exercise {
  id: string;
  name: string;
  category: Muscle;
  goal?: number;
  current?: number;
  setVolumes?: Map<number, number>;
  volume?: number;
  description?: string;
}

export interface Routine {
  id: number;
  name: string;
  exercises: Exercise[];
  totalTime?: string;
}

type Muscle = 'Chest' | 'Back' | 'Shoulders' | 'Legs' | 'Triceps' | 'Biceps';