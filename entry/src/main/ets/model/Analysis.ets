export interface Analysis {
  name: string,
  totalVolume: number,
  time: string,
  categoryVolumes: CategoryVolume[],
  effort?: number,
  date?: Date
}

export interface CategoryVolume {
  category: string;
  volume: number;
}