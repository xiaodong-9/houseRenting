import { BORDER_RADIUS_S } from '../../constants/size';
import { rvp } from '../../utils/responsive';
import type {
  ICityItem,
  ICityList,
  IDistrictItem,
  IProvinceItem,
  IProvinceList,
  LocationDataType
} from '../../model/RentRoomData';

import { getCityListApi, getDistrictListApi, getProvinceListApi } from '../../api/rentRoom';

import { globalEmitter } from '../../utils/emitter';

@Component
export default struct SearchFilter {
  @State searchTypeList: string[] = ['地区', '租金', '付款方式', '排序']
  @State currentSearchType: string = '' //当前选中的筛选项
  // 3. 地区数据
  @State locationData: LocationDataType = {
    provinceList: [],
    cityList: [],
    districtList: [],
    provinceCode: '',
    cityCode: '',
    districtCode: '',
    isSearch: false, //是否搜索
    searchProvinceCode: '',
    searchCityCode: '',
    searchDistrictCode: '',
    searchDistrictName: ''
  }

  // 展示筛选标题“地区” 或者 是确切的“北京市/东城区”
  getSearchTypeName(item: string) {
    if (item === '地区') {
      return this.locationData.searchDistrictName || item
    }
    return item
  }

  // 如果有确切的选择，筛选标题 就改变字体颜色
  getSearchTypeNameColor(item: string) {
    if (item === '地区') {
      return this.locationData.searchDistrictName ? $r('app.color.primary') : $r('app.color.black')
    }
    return item
  }

  // 筛选的点击事件
  chooseSearchType(searchType: string) {
    if (this.currentSearchType === searchType) {
      this.currentSearchType = ''
      return;
    }

    // 每个类型需要不同的处理
    // 选择地区筛选
    if (searchType === '地区') {
      this.locationData.isSearch = false // 不是搜索，只是打开
      this.locationClose()
      this.getProvinceList()
    }

    // 更新
    this.currentSearchType = searchType;
  }

  // 获取省市区数据方法
  async getProvinceList() {
    const provinceList: IProvinceList = await getProvinceListApi() //省列表
    this.locationData.provinceList = provinceList
    this.locationData.provinceCode = this.locationData.provinceCode || provinceList[0].code; //选中的项，默认第一个
    this.getCityList() //获取对应城市
  }

  // 获取对应城市
  async getCityList() {
    const cityList: ICityList = await getCityListApi(this.locationData.provinceCode)
    this.locationData.cityList = cityList;
    this.locationData.cityCode = this.locationData.cityCode || cityList[0].code; //选中的项，默认第一个
    this.getDistrictList() //获取对应区域
  }

  //获取对应区域
  async getDistrictList() {
    const districtList = await getDistrictListApi(this.locationData.cityCode)
    this.locationData.districtList = districtList
    this.locationData.districtCode = this.locationData.districtCode || districtList[0].code;
  }

  // 当地区-省份筛选的项发生改变时
  handleProvinceChange(provinceCode: string) {
    this.locationData.provinceCode = provinceCode;
    this.locationData.cityCode = ''
    this.locationData.districtCode = ''
    this.getCityList()
  }

  // 当地区-城市筛选的项发生改变时
  handleCityChange(cityCode: string) {
    this.locationData.cityCode = cityCode
    this.locationData.districtCode = ''
    this.getDistrictList()
  }

  // 当地区-区域筛选的项发生改变时
  handleDistrictChange(districtCode: string) {
    this.locationData.districtCode = districtCode;
  }

  // 点击查看房源
  locationSearch() {
    // 发出数据到公共
    globalEmitter.emit('searchOptionsChange', {
      provinceCode: this.locationData.provinceCode,
      cityCode: this.locationData.cityCode,
      districtCode: this.locationData.districtCode,
    })
    // 确认要进行搜索
    this.locationData.isSearch = true;
    this.locationClose()
  }

  // 搜索或点击关闭
  locationClose() {
    this.currentSearchType = ''
    if (this.locationData.isSearch) {
      // 点击查看房源 进行搜索
      console.log('11', JSON.stringify(this.locationData.provinceCode))
      this.locationData.searchProvinceCode = this.locationData.provinceCode
      this.locationData.searchCityCode = this.locationData.cityCode
      this.locationData.searchDistrictCode = this.locationData.districtCode
      this.locationData.searchDistrictName =
        this.locationData.districtList.find(item => item.code === this.locationData.districtCode)?.name || ''
    } else {
      // 存储选择项 比方说1先选择了天津河西区，2选择北京市东城区，3但不进行搜索，只点击空白区域关闭筛选项，4再次打开还是天津河西区
      this.locationData.provinceCode = this.locationData.searchProvinceCode
      this.locationData.cityCode = this.locationData.searchCityCode
      this.locationData.districtCode = this.locationData.searchDistrictCode
    }
  }

  // 重置筛选
  locationReset() {
    this.locationData.provinceCode = ''
    this.locationData.cityCode = ''
    this.locationData.districtCode = ''
    this.getProvinceList()
  }

  // 地区筛选的展示列表
  @Builder
  LocationRender() {
    Row() {
      // 省份
      List() {
        ForEach(this.locationData.provinceList, (item: IProvinceItem) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(16)
                .fontColor(item.code === this.locationData.provinceCode ? $r('app.color.primary') :
                $r('app.color.black')) //当前选中省份
            }
            .width('100%')
            .padding({
              left: rvp(16),
              right: rvp(16),
              top: rvp(6),
              bottom: rvp(6)
            })
          }.onClick(this.handleProvinceChange.bind(this, item.code))
        }, (item: IProvinceItem) => item.code)
      }.width(rvp(120)).height('100%').backgroundColor($r('app.color.bg_gray'))

      // 市级
      List() {
        ForEach(this.locationData.cityList, (item: ICityItem) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(16)
                .fontColor(item.code === this.locationData.cityCode ? $r('app.color.primary') : $r('app.color.black'))
            }
            .width('100%')
            .padding({
              left: rvp(16),
              right: rvp(16),
              top: rvp(6),
              bottom: rvp(6)
            })
          }.onClick(this.handleCityChange.bind(this, item.code))
        }, (item: ICityItem) => item.code)
      }.width(rvp(120)).height('100%').backgroundColor('#EBEBEB')

      // 区域
      List() {
        ForEach(this.locationData.districtList, (item: IDistrictItem) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(16)
                .fontColor(item.code === this.locationData.districtCode ? $r('app.color.primary') :
                $r('app.color.black'))
            }
            .width('100%')
            .padding({
              left: rvp(16),
              right: rvp(16),
              top: rvp(6),
              bottom: rvp(6)
            })
          }.onClick(this.handleDistrictChange.bind(this, item.code))
        }, (item: IDistrictItem) => item.code)
      }.width(rvp(120)).height('100%').backgroundColor('#E6E6E6')
    }.height(rvp(240)).width('100%').backgroundColor($r('app.color.white'))

    Row({ space: rvp(22) }) {
      Button('重置')
        .buttonStyles(rvp(95), '#F0F0F0', $r('app.color.gray_second')).onClick(this.locationReset.bind(this))
      Button('查看房源')
        .buttonStyles(rvp(211), '#67C0A8', $r('app.color.white'))
        .onClick(this.locationSearch.bind(this))
    }.height(rvp(58)).width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center)

    // 筛选列表下面的空白区域，用来绑定关闭事件
    Row() {
    }.width('100%').layoutWeight(1).backgroundColor('rgba(0, 0, 0, 0.7)').onClick(this.locationClose.bind(this))
  }

  // 租金筛选的展示列表
  @Builder
  RentPriceRender() {
    Text('RentPriceRender')
  }

  // 付款方式筛选的展示列表
  @Builder
  PaymentTypeRender() {
    Text('PaymentTypeRender')
  }

  // 排序筛选的展示列表
  @Builder
  SortRender() {
    Text('SortRender')
  }

  build() {
    Column() {
      // 筛选的正常展示
      Row() {
        ForEach(this.searchTypeList, (item: string) => {
          Row({ space: rvp(6) }) {
            Text(this.getSearchTypeName(item))
              .fontSize(16)
              .fontColor(this.getSearchTypeNameColor(item))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .constraintSize({
                maxWidth: rvp(60),
              })
            Image($r('app.media.arrow_down_3')).imageStyles()
          }.width('25%').height('100%').justifyContent(FlexAlign.Center).onClick(this.chooseSearchType.bind(this, item))
        }, (item: string) => item)
      }.width('100%').height(rvp(44)).justifyContent(FlexAlign.SpaceBetween)

      // 选中后展示
      if (this.currentSearchType === '地区') {
        this.LocationRender()
      }
      if (this.currentSearchType === '租金') {
        this.RentPriceRender()
      }
      if (this.currentSearchType === '付款方式') {
        this.PaymentTypeRender()
      }
      if (this.currentSearchType === '排序') {
        this.SortRender()
      }
    }
  }
}

@Extend(Image)
function imageStyles() {
  .width(rvp(12)).height(rvp(12)).objectFit(ImageFit.Fill)
}

@Extend(Button)
function buttonStyles(width: number, bgColor: string | Resource, fontColor: string | Resource) {
  .type(ButtonType.Normal)
  .width(width)
  .height(rvp(26))
  .borderRadius(rvp(BORDER_RADIUS_S))
  .fontSize(16)
  .backgroundColor(bgColor)
  .fontColor(fontColor)
}

@Extend(Text)
function textStyles(active: boolean) {
  .fontSize(16)
  .fontColor(active ? $r('app.color.white') : $r('app.color.gray_second'))
  .width(rvp(94))
  .height(rvp(26))
  .backgroundColor(active ? '#67C0A8' : $r('app.color.bg_gray'))
  .borderRadius(rvp(BORDER_RADIUS_S))
  .textAlign(TextAlign.Center)
}