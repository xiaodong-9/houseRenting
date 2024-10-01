import NavBar from '../../components/NavBar'
import SearchFilter from '../../views/RentRoomList/SearchFilter'
import WaterfallFlow from '../../views/RentRoomList/WaterfallFlow'

@Entry
@Component
struct RentRoomList {
  build() {

    Column() {
      Stack() {
        Column() {
          NavBar({ title: '租房列表' })
          SearchFilter()
        }
      }

      // Column内部可滑动，Stack不可滑动
      Column() {
        WaterfallFlow()
      }
    }

  }
}