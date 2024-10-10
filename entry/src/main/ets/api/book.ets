import { http } from '../utils/http';
import type { IBookInfo, IBookInfoReturn } from '../model/BookRentRoomList';

// 预约看房
export const bookRentRoomApi = (bookInfoData: IBookInfo): Promise<IBookInfoReturn> => {
  return http.post<IBookInfoReturn>('/auth/house/reservation', bookInfoData)
}