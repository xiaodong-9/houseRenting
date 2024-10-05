import { BORDER_RADIUS_S, PADDING } from '../../constants/size';
import { rvp } from '../../utils/responsive';
import type {
  ICityItem,
  ICityList,
  IDistrictItem,
  IPaymentTypeData,
  IProvinceItem,
  IProvinceList,
  IRentPriceData,
  IRentPriceItem,
  IsortData,
  ISortItem,
  LocationDataType
} from '../../model/RentRoomData';

import { getCityListApi, getDistrictListApi, getProvinceListApi } from '../../api/rentRoom';

import { globalEmitter } from '../../utils/emitter';

@Component
export default struct SearchFilter {
  @State searchTypeList: string[] = ['地区', '租金', '付款方式', '排序']
  @State currentSearchType: string = '' //当前选中的筛选项
  // 地区数据
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
  // 租金数据
  @State rentPriceData: IRentPriceData = {
    rentPriceList: [
      {
        id: 1,
        minRent: '0',
        maxRent: '0',
        text: '不限'
      },
      {
        id: 2,
        minRent: '0',
        maxRent: '1500',
        text: '1500元以下'
      },
      {
        id: 3,
        minRent: '1500',
        maxRent: '2500',
        text: '1500-2500元'
      },
      {
        id: 4,
        minRent: '2500',
        maxRent: '3500',
        text: '2500-3500元'
      },
      {
        id: 5,
        minRent: '3500',
        maxRent: '4500',
        text: '3500-4500元'
      },
      {
        id: 6,
        minRent: '4500',
        maxRent: '6000',
        text: '4500-6000元'
      },
      {
        id: 7,
        minRent: '6000',
        maxRent: '8000',
        text: '6000-8000元'
      },
      {
        id: 8,
        minRent: '8000',
        maxRent: '10000',
        text: '8000-10000元'
      },
      {
        id: 9,
        minRent: '10000',
        maxRent: '0',
        text: '10000元以上'
      }
    ],
    rentPrice: {},
    isSearch: false,
    searchRentPrice: {}
  }
  // 付款方式数据
  @State paymentTypeData: IPaymentTypeData = {
    paymentTypeList: ['月付', '季付', '半年付', '年付'],
    isSearch: false,
    paymentType: '',
    searchPaymentType: ''
  }
  // 排序
  @State sortData: IsortData = {
    sortList: [
      {
        id: 1,
        icon: $r('app.media.sort'),
        text: '综合排序',
        orderBy: '',
        orderType: ''
      },
      {
        id: 2,
        icon: $r('app.media.rent'),
        text: '价格从低到高',
        orderBy: 'price',
        orderType: 'asc'
      },
      {
        id: 3,
        icon: $r('app.media.rent'),
        text: '价格从高到低',
        orderBy: 'price',
        orderType: 'desc'
      },
      {
        id: 4,
        icon: $r('app.media.area'),
        text: '面积从大到小',
        orderBy: 'area',
        orderType: 'desc'
      },
      {
        id: 5,
        icon: $r('app.media.area'),
        text: '面积从小到大',
        orderBy: 'area',
        orderType: 'asc'
      },
    ],
    sort: {
      id: 1,
      icon: $r('app.media.sort'),
      text: '综合排序',
      orderBy: '',
      orderType: ''
    },
  }

  // 展示筛选标题“地区” 或者 是确切的“北京市/东城区”
  getSearchTypeName(item: string) {
    if (item === '地区') {
      return this.locationData.searchDistrictName || item
    } else if (item === '租金') {
      return this.rentPriceData.searchRentPrice.text || item
    } else if (item === '付款方式') {
      return this.paymentTypeData.searchPaymentType || item
    } else if (item === '排序') {
      return this.sortData.sort?.text || item
    }
    return item
  }

  // 如果有确切的选择，筛选标题 就改变字体颜色
  getSearchTypeNameColor(item: string) {
    if (item === '地区') {
      return this.locationData.searchDistrictName ? $r('app.color.primary') : $r('app.color.black')
    } else if (item === '租金') {
      return this.rentPriceData.searchRentPrice.text ? $r('app.color.primary') : $r('app.color.black')
    } else if (item === '付款方式') {
      return this.paymentTypeData.searchPaymentType ? $r('app.color.primary') : $r('app.color.black')
    } else if (item === '排序') {
      return this.sortData.sort?.text && this.sortData.sort?.text !== '综合排序' ? $r('app.color.primary') :
      $r('app.color.black')
    }
    return item
  }

  // ======== 一、地区筛选方法 ========

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
    } else if (searchType === '租金') {
      this.rentPriceData.isSearch = false
      this.rentPriceClose()
    } else if (searchType === '付款方式') {
      this.paymentTypeData.isSearch = false
      this.paymentTypeClose()
    } else if (searchType === '排序') {
      this.sortClose()
    }

    // 更新
    this.currentSearchType = searchType;
  }

  // 地区筛选-获取省市区数据方法
  async getProvinceList() {
    const provinceList: IProvinceList = await getProvinceListApi() //省列表
    this.locationData.provinceList = provinceList
    this.locationData.provinceCode = this.locationData.provinceCode || provinceList[0].code; //选中的项，默认第一个
    this.getCityList() //获取对应城市
  }

  // 地区筛选-获取对应城市
  async getCityList() {
    const cityList: ICityList = await getCityListApi(this.locationData.provinceCode)
    this.locationData.cityList = cityList;
    this.locationData.cityCode = this.locationData.cityCode || cityList[0].code; //选中的项，默认第一个
    this.getDistrictList() //获取对应区域
  }

  //地区筛选-获取对应区域
  async getDistrictList() {
    const districtList = await getDistrictListApi(this.locationData.cityCode)
    this.locationData.districtList = districtList
    this.locationData.districtCode = this.locationData.districtCode || districtList[0].code;
  }

  // 地区筛选-当地区-省份筛选的项发生改变时
  handleProvinceChange(provinceCode: string) {
    this.locationData.provinceCode = provinceCode;
    this.locationData.cityCode = ''
    this.locationData.districtCode = ''
    this.getCityList()
  }

  // 地区筛选-当地区-城市筛选的项发生改变时
  handleCityChange(cityCode: string) {
    this.locationData.cityCode = cityCode
    this.locationData.districtCode = ''
    this.getDistrictList()
  }

  // 地区筛选-当地区-区域筛选的项发生改变时
  handleDistrictChange(districtCode: string) {
    this.locationData.districtCode = districtCode;
  }

  // 地区筛选-点击查看房源
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

  // 地区筛选-搜索或点击关闭
  locationClose() {
    this.currentSearchType = ''
    if (this.locationData.isSearch) {
      // 点击查看房源 进行搜索
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

  // 地区筛选-重置筛选
  locationReset() {
    this.locationData.provinceCode = ''
    this.locationData.cityCode = ''
    this.locationData.districtCode = ''
    this.getProvinceList()
  }

  // ======== 二、租金筛选方法 ========

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
      }.width(rvp(120)).height('100%').backgroundColor($r('app.color.bg_gray')).scrollBar(BarState.Off)

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
      }.width(rvp(120)).height('100%').backgroundColor('#EBEBEB').scrollBar(BarState.Off)

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
      }.width(rvp(120)).height('100%').backgroundColor('#E6E6E6').scrollBar(BarState.Off)
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

  // 租金筛选-租金范围的选项发生变化
  handleRentPriceChange(rentPrice: IRentPriceItem) {
    this.rentPriceData.rentPrice = rentPrice
  }

  // 租金筛选-点击查看房源
  rentPriceSearch() {
    globalEmitter.emit('searchOptionsChange', {
      minRent: this.rentPriceData.rentPrice.minRent,
      maxRent: this.rentPriceData.rentPrice.maxRent,
    })
    this.rentPriceData.isSearch = true;
    this.rentPriceClose()
  }

  // 租金筛选-是否筛选
  rentPriceClose() {
    this.currentSearchType = ''
    if (this.rentPriceData.isSearch) {
      this.rentPriceData.searchRentPrice = this.rentPriceData.rentPrice
    } else {
      this.rentPriceData.rentPrice = this.rentPriceData.searchRentPrice
    }
  }

  // 租金筛选-重置
  rentPriceReset() {
    this.rentPriceData.rentPrice = {}
  }

  // ======== 三、付款方式筛选方法 ========

  // 租金筛选的展示列表
  @Builder
  RentPriceRender() {
    Column() {
      Grid() {
        ForEach(this.rentPriceData.rentPriceList, (rentPrice: IRentPriceItem) => {
          GridItem() {
            Text(rentPrice.text)
              .textStyles(this.rentPriceData.rentPrice.id === rentPrice.id)
              .onClick(this.handleRentPriceChange.bind(this, rentPrice))
          }
        }, (rentPrice: IRentPriceItem) => rentPrice.id + '')
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .height(rvp(194 - 58))

      Row({ space: rvp(22) }) {
        Button('重置')
          .buttonStyles(rvp(95), '#F0F0F0', $r('app.color.gray_second'))
          .onClick(this.rentPriceReset.bind(this))
        Button('查看房源')
          .buttonStyles(rvp(211), '#67C0A8', $r('app.color.white'))
          .onClick(this.rentPriceSearch.bind(this))
      }.height(rvp(58)).width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center)
    }
    .height(rvp(202))
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .padding({ left: rvp(PADDING), right: rvp(PADDING) })

    Row() {
    }.width('100%').layoutWeight(1).backgroundColor('rgba(0, 0, 0, 0.7)').onClick(this.rentPriceClose.bind(this))
  }

  // 付款方式-付款方式变更的方法
  handlePaymentTypeChange(paymentType: string) {
    this.paymentTypeData.paymentType = paymentType
  }

  // 付款方式-点击查看房源
  paymentTypeSearch() {
    globalEmitter.emit('searchOptionsChange', {
      paymentType: this.paymentTypeData.paymentType
    })
    this.paymentTypeData.isSearch = true;
    this.paymentTypeClose()
  }

  // 付款方式-是否筛选
  paymentTypeClose() {
    this.currentSearchType = ''
    if (this.paymentTypeData.isSearch) {
      this.paymentTypeData.searchPaymentType = this.paymentTypeData.paymentType
    } else {
      this.paymentTypeData.paymentType = this.paymentTypeData.searchPaymentType
    }
  }

  // 付款方式-重置
  paymentTypeReset() {
    this.paymentTypeData.paymentType = ''
  }

  // 付款方式筛选的展示列表
  @Builder
  PaymentTypeRender() {
    Column() {
      Grid() {
        ForEach(this.paymentTypeData.paymentTypeList, (paymentType: string) => {
          GridItem() {
            Text(paymentType)
              .textStyles(this.paymentTypeData.paymentType === paymentType)
              .onClick(this.handlePaymentTypeChange.bind(this, paymentType))
          }
        }, (paymentType: string) => paymentType)
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr')
      .height(rvp(100))

      Row({ space: rvp(22) }) {
        Button('重置')
          .buttonStyles(rvp(95), '#F0F0F0', $r('app.color.gray_second'))
          .onClick(this.paymentTypeReset.bind(this))
        Button('查看房源')
          .buttonStyles(rvp(211), '#67C0A8', $r('app.color.white'))
          .onClick(this.paymentTypeSearch.bind(this))
      }.height(rvp(58)).width('100%').backgroundColor($r('app.color.white')).justifyContent(FlexAlign.Center)
    }
    .height(rvp(158))
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .padding({ left: rvp(PADDING), right: rvp(PADDING) })

    Row() {
    }.width('100%').layoutWeight(1).backgroundColor('rgba(0, 0, 0, 0.7)').onClick(this.paymentTypeClose.bind(this))
  }

  // ======== 四、排序筛选方法 ========
  // 排序筛选-选择变更
  handleSortChange(sort: ISortItem) {
    this.sortData.sort = sort
    this.sortSearch()
  }

  // 排序筛选-请求/相应数据
  sortSearch() {
    globalEmitter.emit('searchOptionsChange', {
      orderBy: this.sortData.sort?.orderBy || '',
      orderType: this.sortData.sort?.orderType || '',
    })
    this.sortClose()
  }

  sortClose() {
    this.currentSearchType = ''
  }

  // 排序筛选-重置
  sortReset() {
    this.sortData.sort = {}
  }

  // 排序筛选的展示列表
  @Builder
  SortRender() {
    Column() {
      Column() {
        ForEach(this.sortData.sortList, (sort: ISortItem) => {
          Row({ space: rvp(8) }) {
            Image(sort.icon).width(rvp(16))
            Text(sort.text)
              .fontSize(14)
              .fontColor(this.sortData.sort?.id === sort.id ? '#67C0A8' : $r('app.color.gray_second'))
          }.height(rvp(34)).onClick(this.handleSortChange.bind(this, sort))
        }, (sort: ISortItem) => sort.id + '')
      }.padding({ left: rvp(20), top: rvp(8), bottom: rvp(16) }).alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .padding({ left: rvp(PADDING), right: rvp(PADDING) })
    .alignItems(HorizontalAlign.Start)


    Row() {
    }.width('100%').layoutWeight(1).backgroundColor('rgba(0, 0, 0, 0.7)').onClick(this.sortClose.bind(this))
  }

  build() {
    Column() {
      // 筛选的正常展示
      Row() {
        ForEach(this.searchTypeList, (item: string) => {
          Row({ space: rvp(6) }) {
            Text(this.getSearchTypeName(item))
              .fontSize(12)
              .fontColor(this.getSearchTypeNameColor(item))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .constraintSize({
                maxWidth: rvp(60),
              })
            Image($r('app.media.arrow_down_3')).imageStyles()
          }.width('25%').height('100%').justifyContent(FlexAlign.Center).onClick(this.chooseSearchType.bind(this, item))
        }, (item: string) => item)
      }.width('100%').height(rvp(44)).justifyContent(FlexAlign.SpaceBetween).margin({ top: rvp(44) })

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