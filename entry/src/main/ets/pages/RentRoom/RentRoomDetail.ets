import router from '@ohos.router';
import NavBar from '../../views/RentRoomDetail/NavBar';
import NavSwiper from '../../views/RentRoomDetail/NavSwiper';
import RentPrice from '../../views/RentRoomDetail/RentPrice';
import DiscountsList from '../../views/RentRoomDetail/DiscountsList';
import MetaInfo from '../../views/RentRoomDetail/MetaInfo';
import TagList from '../../views/RentRoomDetail/TagList';

import ScrollContainer from '../../components/ScrollContainer';
import { rvp } from '../../utils/responsive';
import { PADDING } from '../../constants/size';
import { getRentRoomDetailApi } from '../../api/rentRoom';
import type {
  IDiscountsList,
  IDistanceInfo,
  IHousePictureList,
  IMetaInfoList,
  IRentRoomDetail,
  IRentRoomDetailParams,
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
    }.padding({ left: rvp(PADDING), right: rvp(PADDING) })
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