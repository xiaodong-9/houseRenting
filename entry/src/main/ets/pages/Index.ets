import Home from './Home';
import See from './See';
import Service from './Service';
import Discover from './Discover';
import My from './My';
import { getWindowBottomHeight, rvp } from '../utils/responsive';
import type { IColors } from '../model/ColorsData';
import router from '@ohos.router';
import type { currentTabBarIndexType } from '../model/loginCodeData';

// 必须放在入口页面
PersistentStorage.persistProp('token', '')

@Entry
@Component
struct Index {
  @StorageLink('navBarFontColor') navBarFontColor: string = ''
  @StorageLink('navBarBgColor') navBarBgColor: string = ''
  @State currentTabBarIndex: number = 0; //当前高亮的下标
  colors: IColors = []

  // 进入页面获取当前高亮的下标
  aboutToAppear() {
    const params = router.getParams() as currentTabBarIndexType
    if (params) {
      this.currentTabBarIndex = params.currentTabBarIndex
    }
  }

  @Builder
  TabBuilder(image: Resource, activeImage: Resource, text: string, index: number) {
    Column() {
      Image(this.currentTabBarIndex === index ? activeImage : image).width(rvp(28)).height(28)
      Text(text)
        .fontSize(rvp(10))
        .fontColor(this.currentTabBarIndex === index ? $r('app.color.black') : $r('app.color.gray_text'))
        .height(rvp(15))

    }
  }

  build() {
    // index 设置默认当前为哪个页面
    Tabs({ barPosition: BarPosition.End, index: this.currentTabBarIndex }) {
      TabContent() {
        Home()
      }.tabBar(this.TabBuilder($r('app.media.tabbar_home'), $r('app.media.tabbar_home_active'), '首页', 0))

      TabContent() {
        See()
      }.tabBar(this.TabBuilder($r('app.media.tabbar_see'), $r('app.media.tabbar_see_active'), '想看', 1))


      TabContent() {
        Service()
      }.tabBar(this.TabBuilder($r('app.media.tabbar_service'), $r('app.media.tabbar_service_active'), '服务', 2))

      TabContent() {
        Discover()
      }.tabBar(this.TabBuilder($r('app.media.tabbar_discover'), $r('app.media.tabbar_discover_active'), '发现', 3))

      TabContent() {
        My({ isActiveTab: this.currentTabBarIndex === 4 })
      }.tabBar(this.TabBuilder($r('app.media.tabbar_my'), $r('app.media.tabbar_my_active'), '我的', 4))
    }
    .vertical(false)
    // 设置tabbar在竖直方向，默认为false
    .barMode(BarMode.Fixed) //用于控制导航栏是否可以滚动，比方说超出可以左滑看别的item
    .scrollable(false) //
    .barHeight(rvp(50) + getWindowBottomHeight()) // 设置 tab 导航栏的高度，默认 56
    .onChange((index) => {
      // 将上个页面color存储起来
      this.colors[this.currentTabBarIndex] = {
        navBarBgColor: this.navBarBgColor,
        navBarFontColor: this.navBarFontColor
      }
      // 将当前页面的color赋值上去
      this.navBarFontColor = this.colors[index]?.navBarFontColor || 'rgb(255, 255, 255)'
      this.navBarBgColor = this.colors[index]?.navBarBgColor || 'rgba(255, 255, 255, 0)'

      this.currentTabBarIndex = index
    })
    .backgroundColor($r('app.color.white'))

  }
}