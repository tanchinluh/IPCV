function imfinfo_print(x)

//template = ['Filename','FileSize','Width','Height','BitDepth','ColorType']';
file_fields = ['Width','Height','Datatype','Channel'];
//#define CV_8U   0
//#define CV_8S   1
//#define CV_16U  2
//#define CV_16S  3
//#define CV_32S  4
//#define CV_32F  5
//#define CV_64F  6
//#define CV_USRTYPE1 7

data_type = ['uint8','int8','uint16','int16','uint32','int32','double','binary'];

//for cnt = 1:6
//    mprintf('%s : %d\n', template(cnt),eval('x.'+template(cnt)));
//end
//
mprintf('%s : %d\n', file_fields(1),x(1)(1));
mprintf('%s : %d\n', file_fields(2),x(1)(2));
mprintf('%s : %s\n', file_fields(3),data_type(x(2)+1));
mprintf('%s : %d\n', file_fields(4),x(3));
endfunction

