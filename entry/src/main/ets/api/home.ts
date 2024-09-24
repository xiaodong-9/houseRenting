import { http } from '../utils/http'

const getHomeDataApi = () => {
  return http.get("/home/info")
}