import { getHomeDataApi } from '../api/home';
import type { INavList, IPlanList, ITileList } from '../model/homeData';
import { BannerListDataSource } from '../model/homeData';
import { PADDING } from '../constants/size';
import SwiperLayout from '../views/Home/SwiperLayout';
import SearchBar from '../views/Home/SearchBar';
import NavList from '../views/Home/NavList';
import TileList from '../views/Home/TileList';
import PlanList from '../views/Home/PlanList';
import Ad from '../views/Home/Ad';
import RoomRecommend from '../views/Home/RoomRecommend';

@Component
export default struct Home {
  // 首页数据
  // banner数据因为使用了lazyforeach所以要用固定的数据类型
  @State bannerList: BannerListDataSource = new BannerListDataSource();
  @State navList: INavList = [];
  @State tileList: ITileList = [];
  @State planList: IPlanList = [];
  @State adPicture: string = '';
  scrollY: number = 0;
  @State bgColor: string = 'rgba(255, 255, 255, 0)'
  @State fontColor: string = 'rgb(255, 255, 255)'

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

  // 处理滚动 每次触发滚动的事件
  handleScroll = (xOffset: number, yOffset: number) => {
    // xOffset 每次触发滚动时，x轴滚动距离（单个
    // yOffset 每次触发滚动时，y轴滚动距离（单个 下为正，上为负
    console.log(`${yOffset}`)
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
          SwiperLayout({ bannerList: this.bannerList })

          // 首页除轮播图外，有一个左右padding
          Column() {
            NavList({ navList: this.navList })
            TileList({ tileList: this.tileList })
            PlanList({ planList: this.planList })
            Ad({ adPicture: this.adPicture })

          }.padding({ left: PADDING, right: PADDING })

          RoomRecommend()

        }
        .justifyContent(FlexAlign.Start)
      }
      .height('100%')
      .align(Alignment.TopStart)
      .scrollBar(BarState.Off)
      .onDidScroll(this.handleScroll)

      // onWillScroll将要开始滚动
      // onDidScroll已经开始滚动


      SearchBar({ bgColor: this.bgColor, fontColor: this.fontColor })

    }.height("100%").alignContent(Alignment.TopStart)
  }
}