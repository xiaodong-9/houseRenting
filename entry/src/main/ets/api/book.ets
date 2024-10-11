import { http } from '../utils/http';
import type { IBookInfo, IBookInfoReturn,IBookRentRoomList } from '../model/BookRentRoomList';

// 预约看房
export const bookRentRoomApi = (bookInfoData: IBookInfo): Promise<IBookInfoReturn> => {
  return http.post<IBookInfoReturn>('/auth/house/reservation', bookInfoData)
}

// 获取预约租房列表
export const getBookRentRoomListApi = (): Promise<IBookRentRoomList> => {
  return http.get<IBookRentRoomList>('/auth/house/history')
}