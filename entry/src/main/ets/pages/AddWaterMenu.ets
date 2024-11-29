import { Utility } from '../model/Utility';
import router from '@ohos.router';

@Entry
@Component
struct AddWaterMenu {
  @State private bigGlassAmount: number = 0;
  @State private smallGlassAmount: number = 0;
  @State private customAmount: number = 0;
  @State private sumOfWater: number = 0;
  @StorageProp('water') private waterLevelInMilliLiters: number = 0;
  @StorageProp('big_glass_default') private defaultBigGlass: number = Utility.bigGlassDefaultValue;
  @StorageProp('small_glass_default') private defaultSmallGlass: number = Utility.smallGlassDefaultValue;

  private calculateWater() {
    this.sumOfWater =
      this.bigGlassAmount * this.defaultBigGlass
        + this.smallGlassAmount * this.defaultSmallGlass
        + this.customAmount;
  }

  private saveToDB() {
    this.waterLevelInMilliLiters = this.waterLevelInMilliLiters + this.sumOfWater;
    AppStorage.set(Utility.waterLevel, this.waterLevelInMilliLiters);
  }

  build() {
    Flex() {
      Column({ space: 30 }) {
        Row({ space: 10 }) {
          Text(this.bigGlassAmount.toString())
          Image($r('app.media.tallGlass'))
            .autoResize(true)
            .height("20%")
          Text($r('app.string.label_big_glass'))
          Button() {
            Text(' - ')
              .fontSize($r('app.integer.font_size_normal'))
          }.onClick(() => {
            if (this.bigGlassAmount > 0) {
              this.bigGlassAmount--;
              this.calculateWater();
            }
          })

          Button() {
            Text(" + ").fontSize($r('app.integer.font_size_normal'))

          }.onClick(() => {
            this.bigGlassAmount++;
            this.calculateWater();
          })
        }

        Row({ space: 10 }) {
          Text(this.smallGlassAmount.toString())
          Image($r('app.media.smallGlass'))
            .autoResize(true)
            .height("10%")
          Text($r('app.string.label_small_glass'))
          Button() {
            Text(' - ').fontSize($r('app.integer.font_size_normal'))

          }.onClick(() => {
            if (this.smallGlassAmount > 0) {
              this.smallGlassAmount--;
              this.calculateWater();
            }
          })

          Button() {
            Text(" + ").fontSize($r('app.integer.font_size_normal'))

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
            .width(70)
            .onChange((value: string) => {
              this.customAmount = Number.parseInt(value);
            })
          Button() {
            Text(' + ').fontSize($r('app.integer.font_size_normal'))
          }
          .onClick(() => {
            this.calculateWater();
          })
        }


        Divider().height(20)
        Row() {
          Button() {
            Text('Add ' + this.sumOfWater + 'ml of Water')
              .fontSize($r('app.integer.font_size_big'))
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