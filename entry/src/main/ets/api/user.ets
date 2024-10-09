import { http } from '../utils/http';
import type { codeReturn, LoginParams, sendSMSCodeParms, sendSMSCodeParmsReturn } from '../model/loginCodeData';

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