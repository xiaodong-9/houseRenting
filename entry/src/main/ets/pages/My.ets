import ScrollContainer from '../components/ScrollContainer'
import Bg from '../views/My/Bg'
import NavBar from '../views/My/NavBar'
import UserInfo from '../views/My/UserInfo'
import TimePlan from '../views/My/TimePlan'
import Order from '../views/My/Order'
import PlanList from '../views/My/PlanList'

import { rvp } from '../utils/responsive'
import { PADDING } from '../constants/size'

import { getUserInfoApi } from '../api/user'
import type { IUserInfo } from '../model/UserData'

@Component
export default struct My {
  @Prop @Watch('handleIsActiveTabChange') isActiveTab: boolean
  @StorageProp('token') token: string = ''; //应用全局的UI状态存储
  @State userInfo: IUserInfo = {
    id: 0,
    avatar: '',
    nickname: ''
  }

  // 进入“我的”页面，如果是高亮选择默认请求用户数据
  aboutToAppear() {
    // 1、先执行这个页面的aboutToAppear，此时isActiveTab为false，
    // 2、index页面的currentTabBarIndex变为4
    // 这里面负责，首页-我的-登陆-登陆成功-请求用户信息
    if (this.isActiveTab) {
      this.getUserInfo()
    }
  }

  // 如果isActiveTab为高亮，并且有token就获取用户信息
  async handleIsActiveTabChange() {
    // 这里负责：首次进入页面不请求，只有后续切换页面的时候才会请求
    if (this.isActiveTab && this.token) {
      this.getUserInfo()
    }
  }

  async getUserInfo() {
    const value = await getUserInfoApi()
    console.log(JSON.stringify(value))
    this.userInfo = value
  }

  @Builder
  NavBarRender() {
    NavBar()
  }

  @Builder
  ContentRender() {
    Stack() {
      Bg()
      Column() {
        UserInfo({ userInfo: $userInfo })
        TimePlan()
        Order()
        PlanList()
      }.padding({ left: rvp(PADDING), right: rvp(PADDING), top: rvp(44) })
    }.width('100%').alignContent(Alignment.TopStart)
  }

  build() {
    ScrollContainer({
      contentBuilder: () => {
        this.ContentRender()
      },
      navBuilder: this.NavBarRender,
    })
  }
}




