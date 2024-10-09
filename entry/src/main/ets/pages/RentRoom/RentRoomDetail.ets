import router from '@ohos.router';
import NavBar from '../../views/RentRoomDetail/NavBar';
import NavSwiper from '../../views/RentRoomDetail/NavSwiper';
import RentPrice from '../../views/RentRoomDetail/RentPrice';
import DiscountsList from '../../views/RentRoomDetail/DiscountsList';
import MetaInfo from '../../views/RentRoomDetail/MetaInfo';
import TagList from '../../views/RentRoomDetail/TagList';
import RentTerm from '../../views/RentRoomDetail/RentTerm';
import RentInfo from '../../views/RentRoomDetail/RentInfo';
import HouseholdItem from '../../views/RentRoomDetail/HouseholdItem';
import SupportList from '../../views/RentRoomDetail/SupportList';
import Book from '../../views/RentRoomDetail/Book';

import ScrollContainer from '../../components/ScrollContainer';
import { rvp } from '../../utils/responsive';
import { PADDING } from '../../constants/size';
import { getRentRoomDetailApi } from '../../api/rentRoom';
import type {
  IDiscountsList,
  IDistanceInfo,
  IHouseholdList,
  IHousePictureList,
  IMetaInfoList,
  IRentInfoList,
  IRentRoomDetail,
  IRentRoomDetailParams,
  IRentTerm,
  ISupportList,
  ITagList
} from '../../model/RentRoomData';


@Entry
@Component
export default struct RentRoomDetail {
  @State housePictureList: IHousePictureList = []
  @State room: Partial<IRentRoomDetail> = {
    rentPriceUnitListing: '',
    rentPriceUnit: ''
  }
  @State discountsList: IDiscountsList = []
  @State metaInfoList: IMetaInfoList = []
  @State distanceInfo: Partial<IDistanceInfo> = {}
  @State tagList: ITagList = []
  @State rentTerm: Partial<IRentTerm> = {}
  @State rentInfoList: IRentInfoList = []
  @State householdList: IHouseholdList = []
  @State supportList: ISupportList = []

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
    this.tagList = room.tags
    this.rentTerm = room.rentTerm
    this.rentInfoList = room.rentInfo
    this.householdList = room.householdItem
    this.supportList = room.support

  }

  @Builder
  NavBarRender() {
    NavBar()
  }

  @Builder
  ContentRender() {
    NavSwiper({ housePictureList: this.housePictureList })
    Column() {
      RentPrice({ rentPriceListing: this.room.rentPriceUnitListing, rentPriceUnit: this.room.rentPriceUnit })
      DiscountsList({ discountsList: this.discountsList })
      MetaInfo({ metaInfoList: $metaInfoList, distanceInfo: $distanceInfo })
      TagList({ tagList: $tagList })
      RentTerm({ rentTerm: $rentTerm })
      RentInfo({ rentInfoList: $rentInfoList })
      HouseholdItem({ householdList: $householdList })
      SupportList({ supportList: $supportList })
      Button('查看全部内容')
        .type(ButtonType.Normal)
        .width('100%')
        .height(rvp(44))
        .fontSize(14)
        .fontColor('#ABA9AC')
        .margin({ top: rvp(25) })
        .backgroundColor($r('app.color.white'))
        .border({ width: 1, color: '#F5F5F5', radius: rvp(4) })
    }.padding({ left: rvp(PADDING), right: rvp(PADDING) })
  }

  build() {
    Stack() {
      ScrollContainer({
        contentBuilder: () => {
          this.ContentRender()
        },
        navBuilder: () => {
          this.NavBarRender()
        },
      })
      Book()

    }.height('100%').alignContent(Alignment.Bottom) //布局-后面的组件留在底部
  }
}