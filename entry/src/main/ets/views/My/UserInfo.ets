import router from '@ohos.router'
import Avatar from '../../components/Avatar'

import { rvp } from '../../utils/responsive'

@Component
export default struct UserInfo {
  @State avatarSrc: string = ''

  goLoginPhone() {
    router.pushUrl({ url: 'pages/Login/LoginPhone' })
  }

  build() {
    Row({ space: rvp(10) }) {
      Avatar({ src: this.avatarSrc, avatarSize: rvp(60) }).onClick(this.goLoginPhone.bind(this))
      Column({ space: rvp(4) }) {
        Text('登录/注册').fontSize(18).fontColor($r('app.color.white')).fontWeight(700)
        Text('点击登录注册').fontSize(14).fontColor($r('app.color.white'))
      }.alignItems(HorizontalAlign.Start).onClick(this.goLoginPhone.bind(this))
    }.margin({ top: rvp(11) }).width('100%')
  }
}