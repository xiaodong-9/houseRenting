import router from '@ohos.router'
import NavBar from '../../components/NavBar'
import { rvp } from '../../utils/responsive'
import { loginApi, sendSMSCodeApi } from '../../api/user'
import showToast from '../../utils/showToast'
import { CODE_REG } from '../../constants/regs'
import type { sendSMSCodeParms } from '../../model/loginCodeData'

@Entry
@Component
struct LoginCode {
  @StorageLink('token') token: string = '' //全局存储，双向绑定
  // 发送验证码
  @State phone: string = ''
  // 倒计时
  @State isSendCode: boolean = false
  @State time: number = 61;
  timeId: number = 0
  // 高亮
  @State code: string = ''
  @State isBtnActive: boolean = false

  // 进入页面请求接口获取验证码
  aboutToAppear() {
    const parms = router.getParams() as sendSMSCodeParms
    this.phone = parms.phone;
    this.sendSMSCode()
  }

  // 请求验证码
  async sendSMSCode() {
    this.startCountDown()
    this.isSendCode = true
    const code = await sendSMSCodeApi(this.phone)
    showToast(code)
  }

  // 定时器
  startCountDown() {
    this.time--
    this.timeId = setInterval(() => {
      this.time--
      if (this.time <= 0) {
        this.time = 61
        clearInterval(this.timeId)
      }
    }, 1000)
  }

  // 离开页面清除定时器
  aboutToDisappear() {
    clearInterval(this.timeId)
  }

  // 验证码双向绑定
  handleInputChange(val: string) {
    this.code = val;
    // 验证
    this.isBtnActive = CODE_REG.test(val);
  }

  // 登录
  async login() {
    try {
      const loginReturn = await loginApi(this.phone, this.code);
      // 持久化存储 token
      this.token = loginReturn.token
      // 跳转回去
      router.pushUrl({ url: 'pages/Index', params: { currentTabBarIndex: 0 } })
    } catch {
      showToast('验证码不正确')
    }
  }

  @Builder
  LoginCodeForm() {
    Column() {
      Stack() {
        TextInput({ placeholder: '请输入验证码' }).inputStyles().onChange(this.handleInputChange.bind(this))
        if (this.time <= 60) {
          Text(`${this.time}s`).fontSize(18).fontColor($r('app.color.primary'))
        } else if (this.isSendCode) {
          Text(`重新发送`).fontSize(14).fontColor($r('app.color.primary')).onClick(this.sendSMSCode.bind(this))
        }
      }.alignContent(Alignment.End)

      Divider().color('#C4EDCE')
      Button('确认')
        .margin({ top: rvp(40) })
        .backgroundColor(this.isBtnActive ? $r('app.color.primary') : '#F0F0F0')
        .fontSize(14)
        .width(rvp(100))
        .fontColor(this.isBtnActive ? $r('app.color.white') : '#C1C1C1')
        .padding({ top: rvp(12), bottom: rvp(12) })
        .enabled(this.isBtnActive)
        .onClick(this.login.bind(this))
    }.margin({ top: rvp(47) }).padding({ left: rvp(37), right: rvp(37) }).alignItems(HorizontalAlign.End)
  }

  build() {
    Column() {
      NavBar({ title: '验证码登录' })
      this.LoginCodeForm()
    }
    .width('100%').height('100%').linearGradient({
      angle: 180,
      colors: [
        ['#DEFBE5', 0],
        ['#ffffff', 0.3],
        ['#ffffff', 1],
      ]
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