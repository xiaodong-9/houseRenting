import { getHomeDataApi } from '../api/home';
import { IBannerList } from '../model/homeData';
import SwiperLayout from '../views/Home/SwiperLayout';

@Component
export default struct Home {
  @State bannerList: IBannerList = [];
  getHomeData = async () => {
    const homeData = await getHomeDataApi()
    console.log(JSON.stringify(homeData))
    this.bannerList = homeData.bannerList;
  }

  aboutToAppear(): void {
    this.getHomeData()
  }

  build() {
    Column() {
      SwiperLayout({ bannerList: this.bannerList })
    }.width('100%').height('100%').align(Alignment.TopStart)
  }
}