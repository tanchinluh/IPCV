function base64_str = imgtobase64(img_name)
    str = '[convert]::ToBase64String((Get-Content '+ '''' + img_name + '''' +' -Encoding byte))'
    base64_str = powershell(str);
endfunction



//$b64      = 'AAAAAA...'
//$filename = 'e:\aaa.png'
//$bytes = [Convert]::FromBase64String($b64)
//[IO.File]::WriteAllBytes($filename, $bytes)
