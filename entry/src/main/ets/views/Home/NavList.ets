import type { INavItem, INavList } from '../../model/homeData'

@Component
export default struct NavList {
  // 父子组件双向数据绑定
  @Link navList: INavList

  build() {
    Grid() {
      ForEach(this.navList, (nav: INavItem) => {
        GridItem() {
          Column({ space: 8 }) {
            // space 是 image 和 text 的间距
            Image(nav.imageURL).width('100%').height(56).objectFit(ImageFit.Fill)
            Text(nav.title).fontSize(12)
          }
        }.width(58)
      }, (nav: INavItem) => nav.id + '')
    }
    .height(170)
    .margin({
      top: 24
    })
    .rowsTemplate('1fr 1fr') //两行
    .columnsTemplate('1fr 1fr 1fr 1fr') //四列
    .rowsGap(14) //行与行之间的间距
    .columnsGap(33) //列与列之间的间距，但因为给每个item设置了固定宽度58所以才看起来没有变化（小屏）
  }
}