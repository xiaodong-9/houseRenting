import { http } from '../utils/http';
import type { codeReturn, LoginParams, sendSMSCodeParms,  } from '../model/loginCodeData';
import type { IUserInfo  } from '../model/UserData';

// 发送验证码
export const sendSMSCodeApi = (phone: string): Promise<string> => {
  const params: sendSMSCodeParms = { phone }
  return http.post<string>('/sendSMSCode', params)
}

// 登录
export const loginApi = (phone: string, code: string): Promise<codeReturn> => {
  const params: LoginParams = { phone, code }
  return http.post<codeReturn>('/login', params)
}

// 获取用户数据
export const getUserInfoApi = (): Promise<IUserInfo> => {
  return http.get<IUserInfo>('/auth/user/userInfo')
}