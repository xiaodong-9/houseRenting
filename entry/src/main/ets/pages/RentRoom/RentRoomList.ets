import NavBar from '../../components/NavBar'
import { getWindowTopHeight } from '../../utils/responsive'
import SearchFilter from '../../views/RentRoomList/SearchFilter'
import WaterfallFlow from '../../views/RentRoomList/WaterfallFlow'

@Entry
@Component
struct RentRoomList {


  build() {
    Stack() {
      WaterfallFlow()
      SearchFilter()
      NavBar({ title: '租房列表' })
    }.width('100%')
    .height('100%')
    .alignContent(Alignment.TopStart).padding({ top: getWindowTopHeight() })

  }
}