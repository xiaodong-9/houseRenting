import { getHomeDataApi } from '../api/home';
import type { INavList, IPlanList, ITileList } from '../model/homeData';
import { BannerListDataSource } from '../model/homeData';
import { PADDING } from '../constants/size';
import SwiperLayout from '../views/Home/SwiperLayout';
import SearchBar from '../views/Home/SearchBar';
import NavList from '../views/Home/NavList';

@Component
export default struct Home {
  // 首页数据
  // banner数据因为使用了lazyforeach所以要用固定的数据类型
  @State bannerList: BannerListDataSource = new BannerListDataSource();
  @State navList: INavList = [];
  @State tileList: ITileList = [];
  @State planList: IPlanList = [];
  @State adPicture: string = '';

  async getHomeData() {
    const homeData = await getHomeDataApi()
    // banner数据因为使用了lazyforeach 使用lazy需要的数据存储类型 -处理
    this.bannerList.setList(homeData.bannerList)

    this.navList = homeData.navList;
    this.tileList = homeData.tileList;
    this.planList = homeData.planList;
    this.adPicture = homeData.adPicture;
  }

  aboutToAppear(): void {
    this.getHomeData()
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          SwiperLayout({ bannerList: this.bannerList })

          // 首页除轮播图外，都有一个左右padding
          Column() {
            NavList({ navList: this.navList })
          }.padding({ left: PADDING, right: PADDING })
        }
        .justifyContent(FlexAlign.Start)
      }
      .height('100%')
      .align(Alignment.TopStart)

      SearchBar()

    }.height("100%").alignContent(Alignment.TopStart)
  }
}