import NavBar from '../../components/NavBar'
import { getWindowTopHeight } from '../../utils/responsive'

@Entry
@Component
struct RentRoomList {
  build() {
    Stack() {
      Column() {
        NavBar({ title: '租房列表' })
      }.height('100%').padding({ top: getWindowTopHeight() })
    }.height('100%').alignContent(Alignment.TopStart)
  }
}