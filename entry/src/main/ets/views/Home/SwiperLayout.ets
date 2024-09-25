// 轮播图
import type { BannerListDataSource, IBannerItem } from '../../model/homeData'

@Component
export default struct SwiperLayout {
  // 大概是因为绕了一层homeData，index获取数据-homeData处理数据-这里使用数据，所以需要使用ObjectLink
  @ObjectLink bannerList: BannerListDataSource

  build() {
    Swiper() {
      LazyForEach(this.bannerList, (banner: IBannerItem) => {
        Image(banner.imageURL).width("100%").height(175)
      }, (item: IBannerItem) => item.id + "")
    }
    .loop(true)
    .indicator(
      Indicator.dot()// 设置圆形导航点样式
        .color('#CCCBCB')
        .selectedColor($r('app.color.primary'))
    )

    // .autoPlay(true)
    // .interval(1000)
  }
}