import router from '@ohos.router'
import NavBar from '../../components/NavBar'

import { rvp } from '../../utils/responsive'
import { PHONE_REG } from '../../constants/regs'
import showToast from '../../utils/showToast'

@Entry
@Component
struct LoginPhone {
  @State phone: string = '' // 手机号功能
  @State isPhoneValid: boolean = false //手机号格式是否正确
  @State isAgree: boolean = false // 用户协议功能
  @State isBtnActive: boolean = false; // 获取验证码按钮功能-是否高亮

  // 手机号输入 双向绑定
  handleInputChange(val: string) {
    this.phone = val;
    this.isPhoneValid = PHONE_REG.test(val);
    // 判断 验证码按钮是否高亮
    this.handleBtnActive()
  }

  // 点击协议事件
  handleAgree() {
    this.isAgree = !this.isAgree;
    // 判断 验证码按钮是否高亮
    this.handleBtnActive()
  }

  // 当手机号输入了且用户协议同意，获取验证码按钮即高亮
  handleBtnActive() {
    if (this.isAgree && this.phone) {
      this.isBtnActive = true
    } else {
      this.isBtnActive = false
    }
  }

  // 点击跳转LoginCode页面
  goLoginCode() {
    // 获取验证码按钮功能-是否高亮
    if (!this.isBtnActive) {
      return;
    }
    // 手机号是否符合格式
    if (!this.isPhoneValid) {
      showToast('手机号不符合格式')
      return;
    }
    // 验证码在下一个页面发送
    router.pushUrl({ url: 'pages/Login/LoginCode', params: { phone: this.phone } })
  }

  @Builder
  LoginPhoneForm() {
    Column() {
      Stack() {
        TextInput({ placeholder: '请输入手机号' }).inputStyles().onChange(this.handleInputChange.bind(this))
        if (this.isPhoneValid) {
          Image($r('app.media.success')).width(rvp(12)).height(rvp(8)).margin({ right: rvp(5) })
        }
      }.alignContent(Alignment.End)

      Divider().color('#C4EDCE')
      Row() {
        Image(this.isAgree ? $r('app.media.radio_active') : $r('app.media.radio'))
          .width(rvp(14))
          .height(rvp(14))
          .onClick(this.handleAgree.bind(this))
        Text() {
          Span('同意').fontSize(14).fontColor('#C1C1C1')
          Span('《用户协议》').fontSize(14).fontColor($r('app.color.primary'))
          Span('和').fontSize(14).fontColor('#C1C1C1')
          Span('《隐私政策》').fontSize(14).fontColor($r('app.color.primary'))
        }.margin({ left: rvp(6) })
      }.margin({ top: rvp(16) }).width('100%')

      Button('获取验证码')
        .margin({ top: rvp(40) })
        .backgroundColor(this.isBtnActive ? $r('app.color.primary') : '#F0F0F0')
        .fontSize(14)
        .fontColor(this.isBtnActive ? $r('app.color.white') : '#C1C1C1')
        .padding({
          top: rvp(12),
          bottom: rvp(12),
          left: rvp(15),
          right: rvp(15)
        })
        .onClick(this.goLoginCode.bind(this))
    }.margin({ top: rvp(47) }).padding({ left: rvp(37), right: rvp(37) }).alignItems(HorizontalAlign.End)
  }

  build() {
    Column() {
      NavBar({ title: '验证码登录' })
      this.LoginPhoneForm()
    }
    .width('100%').height('100%').linearGradient({
      angle: 180,
      colors: [
        ['#DEFBE5', 0],
        ['#ffffff', 0.3],
        ['#ffffff', 1],
      ]//渐变色
    })
  }
}

@Styles
function pressedStyles() {
  // 无法实现点击时，完全透明
  .backgroundColor('rgba(255, 255, 255, 0)')
  .borderRadius(0)
}

@Extend(TextInput)
function inputStyles() {
  .padding({
    left: 0,
    right: 0,
    top: 0,
    bottom: rvp(8)
  })
  .backgroundColor(Color.Transparent)
  .placeholderColor('#C1C1C1')
  .placeholderFont({ size: 18 })
  .caretColor('#C1C1C1')
  .type(InputType.PhoneNumber)
  .maxLength(11)
  .stateStyles({
    pressed: pressedStyles,
    clicked: pressedStyles
  })
}