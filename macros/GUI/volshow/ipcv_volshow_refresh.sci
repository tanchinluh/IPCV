function response = ipcv_volshow_refresh(message)
    global IPCV_VOLSHOW_SOURCE_VOLUME;
    global IPCV_VOLSHOW_ENCODE_QUALITY;

    [dataUri, textureDimensions, intensityRange] = int_volshowencode( ..
        double(IPCV_VOLSHOW_SOURCE_VOLUME), IPCV_VOLSHOW_ENCODE_QUALITY, ..
        [%nan %nan], 0);
    sourceDimensions = [size(IPCV_VOLSHOW_SOURCE_VOLUME, 1), ..
        size(IPCV_VOLSHOW_SOURCE_VOLUME, 2), ..
        size(IPCV_VOLSHOW_SOURCE_VOLUME, 3)];
    update = struct( ..
        "request", "volumeUpdate", ..
        "status", "ok", ..
        "message", message, ..
        "dataUri", dataUri, ..
        "sourceDimensions", sourceDimensions, ..
        "textureDimensions", textureDimensions, ..
        "intensityRange", intensityRange);
    ipcv_volshow_push_json(toJSON(update));
    response = struct("status", "ok", "message", message);
endfunction