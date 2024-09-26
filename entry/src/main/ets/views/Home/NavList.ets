// nav商品
import type { INavItem, INavList } from '../../model/homeData';
import { rvp } from '../../utils/responsive';

@Component
export default struct NavList {
  // 父子组件双向数据绑定
  @Link navList: INavList

  build() {
    Grid() {
      ForEach(this.navList, (nav: INavItem) => {
        GridItem() {
          Column({ space: rvp(8) }) {
            // space 是 image 和 text 的间距
            Image(nav.imageURL).width('100%').height(rvp(56)).objectFit(ImageFit.Fill)
            Text(nav.title).fontSize(rvp(12))
          }
        }.width(rvp(58))
      }, (nav: INavItem) => nav.id + '')
    }
    .height(rvp(170))
    .margin({
      top: rvp(24)
    })
    .rowsTemplate('1fr 1fr') //两行
    .columnsTemplate('1fr 1fr 1fr 1fr') //四列
    .rowsGap(rvp(14)) //行与行之间的间距
    .columnsGap(rvp(33)) //列与列之间的间距，但因为给每个item设置了固定宽度58所以才看起来没有变化（小屏）
  }
}