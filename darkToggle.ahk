^#d::toggleDarkMode()
; use ctrl+win key+t to toggle

toggleDarkMode()
{
    static key := "", mode
    if !key
        RegRead mode, % key := "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize", SystemUsesLightTheme
    mode ^= 1
    RegWrite REG_DWORD, % key, AppsUseLightTheme   , % mode
    RegWrite REG_DWORD, % key, SystemUsesLightTheme, % mode
}