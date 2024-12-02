import { Utility } from '../model/Utility';
import router from '@ohos.router';

let storage = LocalStorage.getShared();

@Entry(storage)
@Component
struct SettingsMenu {
  @LocalStorageLink('small_glass_default') private defaultSmallGlass: number = Utility.smallGlassDefaultValue;
  @LocalStorageLink('big_glass_default') private defaultBigGlass: number = Utility.bigGlassDefaultValue;
  private tempBigGlass: number = 0;
  private tempSmallGlass: number = 0;
  private defaultSpacing = 10;

  build() {
    Flex() {
      Column({ space: this.defaultSpacing }) {
        Text($r('app.string.label_edit_defaults'))
        Divider().strokeWidth(8).color('#F1F3F5')
        Row({ space: this.defaultSpacing }) {
          Text($r('app.string.label_big_glass_volume'))
          TextInput({ placeholder: this.defaultBigGlass.toString() })
            .type(InputType.Number)
            .width($r("app.integer.input_width"))
            .onChange((value: string) => {
              this.tempBigGlass = Number.parseInt(value);
            })
          Button() {
            Text($r('app.string.label_save')).fontSize($r("app.integer.font_size_small")).margin(this.defaultSpacing)
          }.onClick(() => {
            this.defaultBigGlass = this.tempBigGlass;
          })
        }

        Row({ space: this.defaultSpacing }) {
          Text($r('app.string.label_small_glass_volume'))
          TextInput({ placeholder: this.defaultSmallGlass.toString() })
            .type(InputType.Number)
            .width($r("app.integer.input_width"))
            .onChange((value: string) => {
              this.tempSmallGlass = Number.parseInt(value);
            })
          Button() {
            Text($r('app.string.label_save')).fontSize($r("app.integer.font_size_small")).margin(this.defaultSpacing)
          }.onClick(() => {
            this.defaultSmallGlass = this.tempSmallGlass;
          })
        }

        Button() {
          Text($r('app.string.button_close')).fontSize(30).margin(this.defaultSpacing)
        }.onClick(() => {
          router.back()
        })
      }
    }
  }
}