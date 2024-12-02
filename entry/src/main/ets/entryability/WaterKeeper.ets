import data_preferences from '@ohos.data.preferences';
import { Utility } from '../model/Utility';
import intl from '@ohos.intl';

export class WaterKeeper {
  private currentDate: string;
  private dataPreferences: data_preferences.Preferences = null;
  private storage: LocalStorage;

  constructor(context: Context, storage: LocalStorage) {
    this.storage = storage;
    data_preferences.getPreferences(context, Utility.preferencesName)
    .then((pref) => {
      this.dataPreferences = pref;
      this.preparePersistence();
    })

    this.currentDate = this.prepareDateForUID();
  }

  private prepareDateForUID(): string {
    let dateFormat = new intl.DateTimeFormat('en-GB', {
      dateStyle: 'short'
    });
    return dateFormat.format(new Date()).toString();
  }

  private preparePersistence(): void {
    this.dataPreferences.get(Utility.bigGlassDefaultName, Utility.bigGlassDefaultValue).then((value) => {
      this.storage.setOrCreate(Utility.bigGlassDefaultName, value);
    })

    this.dataPreferences.get(Utility.smallGlassDefaultName, Utility.smallGlassDefaultValue).then((value) => {
      this.storage.setOrCreate(Utility.smallGlassDefaultName, value);
    })

    this.dataPreferences.get(this.currentDate, 0).then((value) => {
      this.storage.setOrCreate(Utility.waterLevel, value)
    })
  }

  getWaterLevel(): number {
    return this.storage.get(Utility.waterLevel);
  }

  saveToPersistence() {
    this.dataPreferences.put(Utility.bigGlassDefaultName, this.storage.get(Utility.bigGlassDefaultName))
      .then(() => {
        this.dataPreferences.flush();
      });

    this.dataPreferences.put(Utility.smallGlassDefaultName, this.storage.get(Utility.smallGlassDefaultName))
      .then(() => {
        this.dataPreferences.flush();
      });

    this.dataPreferences.put(this.currentDate, this.storage.get(Utility.waterLevel))
      .then(() => {
        this.dataPreferences.flush();
      });
  }
}