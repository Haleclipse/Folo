import type { ElectronAPI } from "@electron-toolkit/preload"

declare global {
  interface Window {
    electron?: ElectronAPI
    api?: { canWindowBlur: boolean }
  }

  export const ELECTRON: boolean

  interface ImportMetaEnv {
    VITE_ENTERPRISE_MODE?: string
  }
}

export {}
