import ScrollContainer from '../components//ScrollContainer'
import { PADDING } from '../constants/size'
import { rvp } from '../utils/responsive'
import NavBar from '../views/See/NavBar'
import FindRoom from '../views/See/FindRoom'

@Component
export default struct See {
  @Builder
  navBuilder() {
    NavBar()
  }

  @Builder
  contentBuilder() {
    Column() {
      FindRoom()
    }
    .width('100%')
    .height('100%')
    .padding({ left: rvp(PADDING), right: rvp(PADDING) })
    .linearGradient({
      angle: 180, //angle: 线性渐变的起始角度。 下 0 左 90 上 180 右 270
      direction: GradientDirection.Top, //线性渐变的方向
      colors: [
        ['#DEFBE5', 0],
        ['#ffffff', 0.3],
        ['#ffffff', 1],
      ],
      repeating: false, //为渐变的颜色重复着色 默认false
    })
  }

  build() {
    ScrollContainer({
      navBuilder: this.navBuilder,
      contentBuilder: this.contentBuilder
    })

  }
}