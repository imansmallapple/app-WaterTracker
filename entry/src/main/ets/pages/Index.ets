import router from '@ohos.router';
import { Utility } from '../model/Utility';

let AlignRue: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
  'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
  'right': { 'anchor': '__container__', 'align': HorizontalAlign.Center }
}
const perc = "50%"
let storage = LocalStorage.getShared();

@Entry(storage)
@Component
struct Index {
  @State private glassState: number = 0;
  @LocalStorageProp('water_level') private waterState: number = 0;

  onPageShow(): void {
    this.calculateWateredState(); //recalculate the watered state to update the graphic
  }

  private calculateWateredState(): void {
    let currTime = new Date().getTime();
    let morning = new Date().setHours(6, 0, 0, 0);
    let timeDifInHours = (currTime - morning) / 3600000; //we assume 6 AM to be start of the day
    let wateredCoefficient = this.waterState / timeDifInHours;
    if (wateredCoefficient < Utility.unWateredState) {
      this.glassState = Utility.sadGlass;
    } else if (wateredCoefficient < Utility.midWateredState) {
      this.glassState = Utility.neutralGlass;
    } else {
      this.glassState = Utility.happyGlass;
    }
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Navigator({ target: 'pages/SettingsMenu', type: NavigationType.Push }) {
          Image($r('app.media.menu'))
            .id('settings')
            .autoResize(true)
            .height('10%')
            .padding(10)
        }
        .zIndex(5)

        Column() {
          if (this.glassState == 0) {
            Image($r('app.media.sadGlass'))
              .height(perc)
          } else if (this.glassState == 1) {
            Image($r('app.media.mediumGlass'))
              .height(perc)
          } else {
            Image($r('app.media.happyGlass'))
              .height(perc)
          }
        }
        .padding(20)
        .width('100%')
        .alignRules(AlignRue)
      }

      Divider().strokeWidth(20).color($r('app.color.water_background'))

      Button() {
        Text($r('app.string.button_drink_add'))
          .fontSize($r('app.integer.font_size_medium'))
          .margin(10)
          .fontWeight(FontWeight.Bold)
      }
      .onClick(() => {
        router.pushUrl({
          url: 'pages/AddWaterMenu'
        })
      })
      .backgroundColor(Color.Yellow)
      .alignRules({
        top: { anchor: "glass_image", align: VerticalAlign.Bottom },
        middle: { anchor: "__container__", align: HorizontalAlign.Center }
      })

      Divider().strokeWidth(20).color($r('app.color.water_background'))

      Text("Drank " + this.waterState + " milliliters of water today!")
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.water_background'))

  }
}