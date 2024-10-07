import router from '@ohos.router'

import NavBar from '../../views/RentRoomDetail/NavBar'
import NavSwiper from '../../views/RentRoomDetail/NavSwiper'

import ScrollContainer from '../../components/ScrollContainer'

import { getRentRoomDetailApi } from '../../api/rentRoom'
import type {
  IDiscountsList,
  IDistanceInfo,
  IHousePictureList,
  IMetaInfoList,
  IRentRoomDetail,
  IRentRoomDetailParams,
} from '../../model/RentRoomData'


@Entry
@Component
export default struct RentRoomDetail {
  @State housePictureList: IHousePictureList = []
  @State room: Partial<IRentRoomDetail> = {
    rentPriceListing: '',
    rentPriceUnit: ''
  }
  @State discountsList: IDiscountsList = []
  @State metaInfoList: IMetaInfoList = []
  @State distanceInfo: Partial<IDistanceInfo> = {}

  // @State tagList: ITagList = []

  aboutToAppear() {
    this.getRentRoomDetail()
  }

  async getRentRoomDetail() {
    const params = router.getParams() as IRentRoomDetailParams
    // this.room = await getRentRoomDetailApi(params.id)
    const room = await getRentRoomDetailApi('BJ1623160852024655872')
    this.room = room;
    this.housePictureList = room.housePicture
    this.discountsList = room.discounts
    this.metaInfoList = room.metaInfo
    this.distanceInfo = room.distance_info
    // this.tagList = room.tags
  }

  @Builder
  NavBarRender() {
    NavBar()
  }

  @Builder
  ContentRender() {
    Column() {
      NavSwiper({ housePictureList: this.housePictureList })

    }.height('100%').width('100%')
  }

  build() {
    Column() {
      ScrollContainer({
        contentBuilder: () => {
          this.ContentRender()
        },
        navBuilder: () => {
          this.NavBarRender()
        },
      })
    }.height('100%')
  }
}