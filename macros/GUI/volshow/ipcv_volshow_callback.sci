function ipcv_volshow_callback(msg, cb)
    if msg == "loaded" then
        return;
    end

    global IPCV_VOLSHOW_SOURCE_VOLUME;
    global IPCV_VOLSHOW_ORIGINAL_VOLUME;
    global IPCV_VOLSHOW_PREVIOUS_VOLUME;
    global IPCV_VOLSHOW_LAST_EXPORT_NAME;
    global IPCV_VOLSHOW_LAST_EXPORT_LAYER;

    try
        select msg.type
        case "exportLayer" then
            variableName = msg.variable;
            if type(variableName) <> 10 | size(variableName, "*") <> 1 | ..
                    ~validvar(variableName) then
                cb(toJSON(struct("status", "error", ..
                    "message", "Enter a valid Scilab variable name.")));
                return;
            end
            if isempty(IPCV_VOLSHOW_SOURCE_VOLUME) then
                cb(toJSON(struct("status", "error", ..
                    "message", "The source volume is no longer available.")));
                return;
            end

            layerIndex = round(evstr(string(msg.index)));
            layer = ipcv_volshow_extract_layer( ..
                IPCV_VOLSHOW_SOURCE_VOLUME, msg.axis, layerIndex);
            IPCV_VOLSHOW_LAST_EXPORT_NAME = variableName;
            IPCV_VOLSHOW_LAST_EXPORT_LAYER = layer;
            response = struct( ..
                "status", "ok", ..
                "message", msprintf("Exported %s layer %d to %s (%d x %d).", ..
                    msg.axis, layerIndex, variableName, size(layer, 1), size(layer, 2)));
            cb(toJSON(response));

            // resume places the layer in the Scilab workspace that owns the GUI callback.
            execstr(variableName + " = resume(layer);");
        case "process" then
            if isempty(IPCV_VOLSHOW_SOURCE_VOLUME) then
                error("The source volume is no longer available.");
            end
            parameter = evstr(string(msg.parameter));
            threshold = evstr(string(msg.threshold));
            connectivity = evstr(string(msg.connectivity));
            [processed, description] = ipcv_volshow_process( ..
                IPCV_VOLSHOW_SOURCE_VOLUME, msg.operation, parameter, ..
                threshold, connectivity);
            IPCV_VOLSHOW_PREVIOUS_VOLUME = IPCV_VOLSHOW_SOURCE_VOLUME;
            IPCV_VOLSHOW_SOURCE_VOLUME = processed;
            cb(toJSON(ipcv_volshow_refresh(description + ".")));
        case "undoProcessing" then
            if isempty(IPCV_VOLSHOW_PREVIOUS_VOLUME) then
                cb(toJSON(struct("status", "error", ..
                    "message", "There is no previous processing result to restore.")));
                return;
            end
            current = IPCV_VOLSHOW_SOURCE_VOLUME;
            IPCV_VOLSHOW_SOURCE_VOLUME = IPCV_VOLSHOW_PREVIOUS_VOLUME;
            IPCV_VOLSHOW_PREVIOUS_VOLUME = current;
            cb(toJSON(ipcv_volshow_refresh("Restored the previous volume.")));
        case "resetProcessing" then
            if isempty(IPCV_VOLSHOW_ORIGINAL_VOLUME) then
                error("The original volume is no longer available.");
            end
            IPCV_VOLSHOW_PREVIOUS_VOLUME = IPCV_VOLSHOW_SOURCE_VOLUME;
            IPCV_VOLSHOW_SOURCE_VOLUME = IPCV_VOLSHOW_ORIGINAL_VOLUME;
            cb(toJSON(ipcv_volshow_refresh("Restored the original volume.")));
        case "exportVolume" then
            variableName = msg.variable;
            if type(variableName) <> 10 | size(variableName, "*") <> 1 | ..
                    ~validvar(variableName) then
                cb(toJSON(struct("status", "error", ..
                    "message", "Enter a valid Scilab variable name.")));
                return;
            end
            currentVolume = IPCV_VOLSHOW_SOURCE_VOLUME;
            cb(toJSON(struct("status", "ok", ..
                "message", "Exported the full processed volume to " + variableName + ".")));
            execstr(variableName + " = resume(currentVolume);");
        case "close" then
            IPCV_VOLSHOW_SOURCE_VOLUME = [];
            IPCV_VOLSHOW_ORIGINAL_VOLUME = [];
            IPCV_VOLSHOW_PREVIOUS_VOLUME = [];
        else
            cb(toJSON(struct("status", "error", ..
                "message", "Unknown volshow command.")));
        end
    catch
        cb(toJSON(struct("status", "error", ..
            "message", "volshow command failed: " + lasterror())));
    end
endfunction