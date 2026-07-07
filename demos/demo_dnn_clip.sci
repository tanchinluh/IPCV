////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
////////////////////////////////////////////////////////////
function demo_dnn_clip()

    function [labels, prompts, embeddings] = load_clip_prompts(dnn_path)
        lines = mgetl(dnn_path + "clip_rn50_openai_prompts.txt");
        labels = emptystr(size(lines, "*"), 1);
        prompts = emptystr(size(lines, "*"), 1);

        for i = 1:size(lines, "*")
            parts = strsplit(lines(i), "|");
            labels(i) = parts(1);
            prompts(i) = parts(2);
        end

        embeddings = csvRead(dnn_path + "clip_rn50_openai_text_embeddings.csv");
    endfunction

    function img = clip_preprocess(S)
        img = im2double(imresize(S, [224 224]));
        channel_mean = [0.48145466 0.4578275 0.40821073];
        channel_std = [0.26862954 0.26130258 0.27577711];

        for c = 1:3
            img(:,:,c) = (img(:,:,c) - channel_mean(c)) ./ channel_std(c);
        end
    endfunction

    function scores = clip_zeroshot_scores(net, S, text_embeddings)
        img = clip_preprocess(S);
        image_embedding = dnn_forward(net, img, [224, 224], [], 1, [0 0 0], 0, 0);
        image_embedding = image_embedding(:)';
        image_embedding = image_embedding ./ sqrt(sum(image_embedding .* image_embedding));
        scores = text_embeddings * image_embedding';
    endfunction

    dnn_unloadallmodels();

    dnn_path = fullpath(getIPCVpath() + "/images/dnn/");
    model_file = dnn_path + "clip_rn50_openai_visual_fp16.onnx";

    net = dnn_readmodel(model_file, "", "onnx");
    net = dnn_setpreferable(net, "opencv", "cpu");
    [labels, prompts, text_embeddings] = load_clip_prompts(dnn_path);

    S = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    scores = clip_zeroshot_scores(net, S, text_embeddings);

    mprintf("\nCLIP zero-shot classification\n");
    mprintf("Image encoder: %s\n", net.name);
    mprintf("Prompt count: %d\n\n", size(labels, "*"));
    mprintf("Top predictions:\n");

    ranked_scores = scores;
    for k = 1:min(5, size(ranked_scores, "*"))
        [score, index] = max(ranked_scores);
        mprintf("%d. %s - %s (%.4f)\n", k, labels(index), prompts(index), score);
        ranked_scores(index) = -%inf;
    end

    [top_score, top_index] = max(scores);
    scf();
    imshow(S);
    title("CLIP zero-shot: " + labels(top_index) + " (" + msprintf("%.4f", top_score) + ")");

    dnn_unloadmodel(net);
endfunction
// ====================================================================
demo_dnn_clip();
clear demo_dnn_clip;
// ====================================================================
