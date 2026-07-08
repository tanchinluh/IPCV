function S = base64toimg(base64_str)

    src = 'e:\base64source.txt';
    tgt = 'e:\base64target.png';

    mputl(base64_str,src);

    str = "$b64 =" + "Get-Content " + '''' + src + '''' + ';' + "$filename = " + '''' + tgt + '''' + ';' + "$bytes = [Convert]::FromBase64String($b64);[IO.File]::WriteAllBytes($filename, $bytes)" 

    powershell(str);


    S = imread(tgt);
    
    deletefile(src);
    deletefile(tgt);
endfunction


