import { Utility } from '../model/Utility';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

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
        Text($r('app.string.label_edit_defaults')).fontSize($r('app.integer.font_size_small'))
        Divider().strokeWidth(this.defaultSpacing).color($r('app.color.divider_colour'))
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
            promptAction.showToast({
              message: $r('app.string.saved'),
              duration: 1000
            })
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
            promptAction.showToast({
              message: $r('app.string.saved'),
              duration: 1000
            })
          })
        }

        Button() {
          Text($r('app.string.button_close')).fontSize($r('app.integer.font_size_medium')).margin(this.defaultSpacing)
        }.onClick(() => {
          router.back()
        })
      }
    }
  }
}