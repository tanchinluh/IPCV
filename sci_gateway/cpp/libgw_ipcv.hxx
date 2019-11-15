#ifndef __LIBGW_IPCV_GW_HXX__
#define __LIBGW_IPCV_GW_HXX__

#ifdef _MSC_VER
#ifdef LIBGW_IPCV_GW_EXPORTS
#define LIBGW_IPCV_GW_IMPEXP __declspec(dllexport)
#else
#define LIBGW_IPCV_GW_IMPEXP __declspec(dllimport)
#endif
#else
#define LIBGW_IPCV_GW_IMPEXP
#endif

extern "C" LIBGW_IPCV_GW_IMPEXP int libgw_ipcv(wchar_t* _pwstFuncName);



#endif /* __LIBGW_IPCV_GW_HXX__ */
