import { Utility } from '../model/Utility';
import router from '@ohos.router';

let storage = LocalStorage.getShared();

@Entry(storage)
@Component
struct AddWaterMenu {
  @State private bigGlassAmount: number = 0;
  @State private smallGlassAmount: number = 0;
  @State private customAmount: number = 0;
  @State private sumOfWater: number = 0;
  @LocalStorageLink('water_level') private waterLevelInMilliLiters: number = 0;
  @LocalStorageLink('small_glass_default') private defaultSmallGlass: number = Utility.smallGlassDefaultValue;
  @LocalStorageLink('big_glass_default') private bigGlassDefault: number = Utility.bigGlassDefaultValue;

  private calculateWater() {
    this.sumOfWater =
      this.bigGlassAmount * this.bigGlassDefault
        + this.smallGlassAmount * this.defaultSmallGlass
        + this.customAmount;
  }

  private saveToDB() {
    this.waterLevelInMilliLiters = this.waterLevelInMilliLiters + this.sumOfWater;
    storage.set(Utility.waterLevel, this.waterLevelInMilliLiters);
  }

  build() {
    Flex() {
      Column({ space: 30 }) {
        Row({ space: 10 }) {
          Text(this.bigGlassAmount.toString())
          Image($r('app.media.tallGlass'))
            .autoResize(true)
            .height("30%")
          Text($r('app.string.label_big_glass'))

          Button() {
            Text($r('app.string.minus'))
              .fontSize($r('app.integer.font_size_big'))
          }.onClick(() => {
            if (this.bigGlassAmount > 0) {
              this.bigGlassAmount--;
              this.calculateWater();
            }
          })

          Button() {
            Text($r('app.string.plus')).fontSize($r('app.integer.font_size_big'))

          }.onClick(() => {
            this.bigGlassAmount++;
            this.calculateWater();
          })
        }

        Row({ space: 10 }) {
          Text(this.smallGlassAmount.toString())
          Image($r('app.media.smallGlass'))
            .autoResize(true)
            .height("30%")
          Text($r('app.string.label_small_glass'))
          Button() {
            Text($r('app.string.minus')).fontSize($r('app.integer.font_size_big'))

          }.onClick(() => {
            if (this.smallGlassAmount > 0) {
              this.smallGlassAmount--;
              this.calculateWater();
            }
          })

          Button() {
            Text($r('app.string.plus')).fontSize($r('app.integer.font_size_big'))

          }.onClick(() => {
            this.smallGlassAmount++;
            this.calculateWater();
          })
        }

        Row({ space: 10 }) {
          Text(this.customAmount.toString())
          Text($r('app.string.label_custom'))
          TextInput()
            .type(InputType.Number)
            .width($r("app.integer.input_width"))
            .onChange((value: string) => {
              this.customAmount = Number.parseInt(value);
            })
          Button() {
            Text($r('app.string.plus')).fontSize($r('app.integer.font_size_big'))
          }
          .onClick(() => {
            this.calculateWater();
          })
        }


        Divider().height(20)
        Row() {
          Button() {
            Text('Add ' + this.sumOfWater + 'ml of Water')
              .fontSize($r('app.integer.font_size_large'))
              .fontWeight(FontWeight.Bold)
              .backgroundColor(Color.Orange)
          }.alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            if (this.sumOfWater > 0) {
              this.saveToDB();
            }
            router.back();
          })
        }
      }
    }
    .height('100%')
    .width('100%')
  }
}