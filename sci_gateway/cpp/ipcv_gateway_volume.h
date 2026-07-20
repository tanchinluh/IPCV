#ifndef IPCV_GATEWAY_VOLUME_H
#define IPCV_GATEWAY_VOLUME_H

#include "ipcv_gateway_common.h"
#include "ipcv_volume.h"

int ipcv_get_volume_argument(void *pvApiCtx, int position, IpcvVolume& volume);
void ipcv_release_volume_argument(IpcvVolume& volume);
int ipcv_set_volume_argument(void *pvApiCtx, int position,
    const IpcvVolume& volume, int as_boolean);

extern "C"
{
int sci_int_imboxfilt3(char *fname, void *pvApiCtx);
int sci_int_imbwareaopen3(char *fname, void *pvApiCtx);
int sci_int_imbwmorph3(char *fname, void *pvApiCtx);
int sci_int_imbwperim3(char *fname, void *pvApiCtx);
int sci_int_imfill3(char *fname, void *pvApiCtx);
int sci_int_imgaussianblur3(char *fname, void *pvApiCtx);
int sci_int_imlabeln3(char *fname, void *pvApiCtx);
int sci_int_immedian3(char *fname, void *pvApiCtx);
int sci_int_imregionalmax3(char *fname, void *pvApiCtx);
}

#endif
