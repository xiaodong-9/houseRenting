import { rvp } from '../../utils/responsive';
import { IPicItem } from '../../model/BasicDataSource';
import type { IHousePictureList, itemPicType } from '../../model/RentRoomData';


@Component
export default struct NavSwiper {
  @Link @Watch('handleHousePictureListChange') housePictureList: IHousePictureList
  @State housePictureListData: itemPicType[] = []
  @State currentTabIndex: number = 0
  scroller: Scroller = new Scroller()
  @State isGoCurrentTabIndexImage: boolean = false

  // 整理数据格式
  handleHousePictureListChange() {
    const list: itemPicType[] = []
    this.housePictureList.forEach((item, index) => {
      item.picList.forEach(itemPic => {
        list.push({
          currentTabIndex: index,
          url: itemPic
        })
      })
    })
    this.housePictureListData = list
  }

  // 更换tabs时
  setCurrentTabIndex(index: number) {
    this.currentTabIndex = index;
    this.goCurrentTabIndexImage()
  }

  // 获取对应tabs的index的对应图片
  goCurrentTabIndexImage() {
    const index: number = this.housePictureListData.findIndex((pic: itemPicType) => {
      return pic.currentTabIndex === this.currentTabIndex
    })
    this.scroller.scrollTo({
      xOffset: rvp(318) * index + rvp(10) * (index - 1),
      yOffset: 0,
      animation: {
        duration: 500,
        curve: Curve.EaseIn
      }
    })
    this.isGoCurrentTabIndexImage = true;
    setTimeout(() => {
      this.isGoCurrentTabIndexImage = false;
    }, 500)
  }

  // 切换图片时，切换tabs的index
  handleListScrollIndex(start: number) {
    if (this.isGoCurrentTabIndexImage) {
      return;
    }
    const pic: itemPicType = this.housePictureListData[start];
    if (pic) {
      this.currentTabIndex = pic.currentTabIndex;
    }
  }

  @Builder
  NavBarZu() {
    List({ space: rvp(16) }) {
      ListItem() {
      } //占位的

      ForEach(this.housePictureList, (pic: IPicItem, index: number) => {
        ListItem() {
          Column({ space: rvp(4) }) {
            Text(pic.spaceName + `(${pic.picList?.length})`)
              .fontSize(16)
              .fontColor(this.currentTabIndex === index ? $r('app.color.black') : $r('app.color.gray_second'))
            if (this.currentTabIndex === index) {
              Divider().width(rvp(16)).height(rvp(2)).color($r('app.color.primary'))
            }
          }
        }.onClick(this.setCurrentTabIndex.bind(this, index))
      }, (pic: IPicItem) => pic.spaceName)
      ListItem() {
      }
    }.listDirection(Axis.Horizontal).width('100%').height(rvp(42))
    .scrollBar(BarState.Off) //隐藏滚动条
  }

  @Builder
  PicList() {
    List({ space: rvp(10), scroller: this.scroller }) {
      ListItem() {
      }.width(rvp(6))

      ForEach(this.housePictureListData, (pic: itemPicType) => {
        ListItem() {
          Image(pic.url).width(rvp(318)).height(rvp(192)).objectFit(ImageFit.Fill)
        }
      }, (pic: itemPicType) => pic.url)

      ListItem() {
      }.width(rvp(6))
    }.width('100%').listDirection(Axis.Horizontal).onScrollIndex(this.handleListScrollIndex.bind(this))
  }

  build() {
    Column({ space: rvp(16) }) {
      this.NavBarZu()
      this.PicList()
    }.margin({ top: rvp(44 + 16) }).width('100%')
  }
}