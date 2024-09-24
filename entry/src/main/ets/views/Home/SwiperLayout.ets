import type { IBannerItem, IBannerList } from '../../model/homeData'

@Component
export default struct SwiperLayout {
  @Prop bannerList: IBannerList

  build() {
    Swiper() {
      ForEach(this.bannerList, (banner: IBannerItem) => {
        Image(banner.imageURL).width('100%').height(175)
      }, (item: IBannerItem) => item.id + '')
    }
    .loop(true)
    .indicator(
      Indicator.dot()// 设置圆形导航点样式
        .color('#CCCBCB')
        .selectedColor($r('app.color.primary'))
    )
    .autoPlay(true)
    .interval(1000)
  }
}