import data_preferences from '@ohos.data.preferences';
import { Utility } from '../model/Utility';
import intl from '@ohos.intl';

export class WaterKeeper {
  private bigGlassDefaultLink: SubscribedAbstractProperty<number> | null = null;
  private smallGlassDefaultLink: SubscribedAbstractProperty<number> | null = null;
  private waterLevelLink: SubscribedAbstractProperty<number> | null = null;
  private currentDate: string;
  private dataPreferences: data_preferences.Preferences = null;

  constructor(context: Context) {


    let promise = data_preferences.getPreferences(context, 'water');
    promise.then((pref) => {
      this.dataPreferences = pref;
      this.preparePersistence();
    })

    this.currentDate = this.prepareDateForUID();
  }

  private prepareDateForUID(): string {
    let dateFormat = new intl.DateTimeFormat('en-GB', {
      dateStyle: 'short'
    });
    console.log("AAA date = " + dateFormat.format(new Date()).toString())
    return dateFormat.format(new Date()).toString();
  }

  private preparePersistence(): void {
    this.getValuesFromPreferences(this.dataPreferences, Utility.bigGlassDefaultName, Utility.bigGlassDefaultValue);
    this.getValuesFromPreferences(this.dataPreferences, Utility.smallGlassDefaultName, Utility.smallGlassDefaultValue)

    this.bigGlassDefaultLink = AppStorage.link(Utility.bigGlassDefaultName);
    this.smallGlassDefaultLink = AppStorage.link(Utility.smallGlassDefaultName);

    if (!this.dataPreferences.hasSync(this.currentDate)) {
      AppStorage.setOrCreate(Utility.waterLevel, 0);
    } else {
      AppStorage.setOrCreate(Utility.waterLevel, this.dataPreferences.getSync(this.currentDate, 0));
    }
    this.waterLevelLink = AppStorage.link(Utility.waterLevel);
  }

  private getValuesFromPreferences(dataPreferences: data_preferences.Preferences, name: string, value: number) {
    if (!dataPreferences.hasSync(name)) {
      AppStorage.setOrCreate(name, value);
    } else {
      AppStorage.setOrCreate(name,
        Number(dataPreferences.getSync(name, 0)));
    }

  }

  saveToPersistence() {
    console.log("AAA water " + this.waterLevelLink?.get());
    this.dataPreferences.putSync(Utility.bigGlassDefaultName, Number(this.bigGlassDefaultLink?.get()));
    this.dataPreferences.putSync(Utility.smallGlassDefaultName, Number(this.smallGlassDefaultLink?.get()));
    this.dataPreferences.putSync(this.currentDate, Number(this.waterLevelLink?.get()));
    this.dataPreferences.flush();
  }
}