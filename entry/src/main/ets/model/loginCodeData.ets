export interface sendSMSCodeParmsReturn {
  code: number
}

export interface sendSMSCodeParms {
  phone: string
}

export interface LoginParams {
  phone: string,
  code: string
}

export interface codeReturn {
  token: string
}

export interface currentTabBarIndexType {
  currentTabBarIndex: number
}


