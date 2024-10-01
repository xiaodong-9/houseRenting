import { BORDER_RADIUS_S } from '../../constants/size'
import { rvp } from '../../utils/responsive'

@Component
export default struct SearchFilter {
  @State searchTypeList: string[] = ['地区', '租金', '付款方式', '排序']
  @State currentSearchType: string = ''

  chooseSearchType(searchType: string) {
    this.currentSearchType = searchType
  }

  @Builder
  LocationRender() {
    Text('LocationRender')
  }

  @Builder
  RentPriceRender() {
    Text('RentPriceRender')
  }

  @Builder
  PaymentTypeRender() {
    Text('PaymentTypeRender')
  }

  @Builder
  SortRender() {
    Text('SortRender')
  }

  build() {
    Column() {
      Row() {
        ForEach(this.searchTypeList, (item: string) => {
          Row({ space: rvp(6) }) {
            Text(item)
              .fontSize(rvp(12))
              .fontColor($r('app.color.black'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .constraintSize({
                maxWidth: rvp(60),
              })
            Image($r('app.media.arrow_down_3')).imageStyles()
          }.width('25%').height('100%').justifyContent(FlexAlign.Center).onClick(() => {
            this.chooseSearchType(item)
          })
        }, (item: string) => item)
      }.width('100%').height(rvp(44)).justifyContent(FlexAlign.SpaceBetween)

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
  .width(rvp(6)).height(rvp(3)).objectFit(ImageFit.Fill)
}

@Extend(Button)
function buttonStyles(width: number, bgColor: string | Resource, fontColor: string | Resource) {
  .type(ButtonType.Normal)
  .width(width)
  .height(rvp(26))
  .borderRadius(rvp(BORDER_RADIUS_S))
  .fontSize(rvp(12))
  .backgroundColor(bgColor)
  .fontColor(fontColor)
}

@Extend(Text)
function textStyles(active: boolean) {
  .fontSize(rvp(12))
  .fontColor(active ? $r('app.color.white') : $r('app.color.gray_second'))
  .width(rvp(94))
  .height(rvp(26))
  .backgroundColor(active ? '#67C0A8' : $r('app.color.bg_gray'))
  .borderRadius(rvp(BORDER_RADIUS_S))
  .textAlign(TextAlign.Center)
}