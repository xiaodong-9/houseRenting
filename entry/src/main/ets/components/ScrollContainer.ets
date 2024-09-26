import { IColor } from '../model/homeData';
import { getWindowBottomHeight, getWindowTopHeight } from '../utils/responsive';

@Component
export default struct ScrollContainer {
  // 初始化的时候给一个空函数
  @BuilderParam contentBuilder: () => void = this.defaultBuilder
  @BuilderParam navBuilder: ($$: IColor) => void = this.defaultBuilder
  scrollY: number = 0;
  @State bgColor: string = 'rgba(255, 255, 255, 0)'
  @State fontColor: string = 'rgb(255, 255, 255)'

  @Builder
  defaultBuilder() {
  }

  // 处理滚动 每次触发滚动的事件
  handleScroll = (xOffset: number, yOffset: number) => {
    // xOffset 每次触发滚动时，x轴滚动距离（单个
    // yOffset 每次触发滚动时，y轴滚动距离（单个 下为正，上为负
    this.scrollY += yOffset;
    // 因为获取的是单个滚动距离，所以需要相加
    if (this.scrollY < 0) {
      this.scrollY = 0;
    }
    this.calcColor()
  }
  // 计算颜色
  calcColor = () => {
    // 滚动计算的 scrollY 的值到达顶部可能不是 0，给点误差
    if (this.scrollY < 10) {
      this.bgColor = 'rgba(255, 255, 255, 0)'
      this.fontColor = 'rgb(255, 255, 255,1)'
    } else if (this.scrollY <= 50) {
      // 渐变中（0->1）
      const colorOpacty = (this.scrollY - 10) / (50 - 10)
      this.bgColor = `rgba(255, 255, 255, ${colorOpacty})`
      this.fontColor = `rgb(0, 0, 0, ${colorOpacty})`
    } else {
      // 这里也要给透明度，要不然就会不展示
      this.bgColor = 'rgba(255, 255, 255,1)'
      this.fontColor = 'rgb(0, 0, 0,1)'
    }
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          // 渲染内容
          this.contentBuilder()
        }.align(Alignment.TopStart)
      }
      .height('100%')
      .scrollBar(BarState.Off)
      .align(Alignment.TopStart)
      .backgroundColor($r('app.color.bg_gray_second'))
      .padding({ bottom: 10 })
      .onDidScroll(this.handleScroll)

      Column() {
        // 渲染头部导航
        this.navBuilder({ fontColor: this.fontColor, bgColor: this.bgColor })
      }.backgroundColor(this.bgColor).padding({ top: getWindowTopHeight(), bottom: getWindowBottomHeight() })

    }.height('100%').alignContent(Alignment.TopStart)

  }
}