
if  {[winfo exists  .ipcvimshow] != 1 } then {
    set w .ipcvimshow
    catch {destroy $w}
    toplevel $w

    wm title $w "image show"
    wm iconname $w "imshow"

    frame $w.top -borderwidth 10
    grid $w.top -sticky n
    
    #Zoom In button
    button $w.top.zoomin -text "Zoom In" -command {zoom_in}
    grid $w.top.zoomin -row 0 -column 0 -sticky n

    #Zoom Out button
    button $w.top.zoomout -text "Zoom Out" -command {zoom_out}
    grid $w.top.zoomout -row 0 -column 1 -sticky n

    #close button
    button $w.top.exit -text Close -command {destroy $w}
    grid $w.top.exit -row 0 -column 2 -sticky n

    #create a scrollable canvas
    canvas $w.can -highlightthickness 0  -yscrollcommand {$w.vs set} -xscrollcommand {$w.hs set} 
    scrollbar $w.vs -command {$w.can yview}
    scrollbar $w.hs -command {$w.can xview} -orient horizontal
    grid $w.can $w.vs -sticky nsew
    grid $w.hs -sticky nsew
    grid rowconfigure    $w 1 -weight 1
    grid columnconfigure $w 0 -weight 1
}

#create image	
image create photo tkimage 
#put image data to tkimage
tkimage put  $imagedata

$w.can delete item 
$w.can create image 0 0 -tags item -image tkimage  -anchor nw

$w.can configure -scrollregion [$w.can bbox all]

set zoomscale 1.0

#resize the window, the max size of the window is 900x600
set winw [expr {$imagewidth+30}]
set winh [expr {$imageheight+75}]
if {$winw > 900} { set winw 900}
if {$winw < 250} { set winw 250} 
if {$winh > 600} { set winh 600}
wm geometry $w ${winw}x${winh}


proc zoom_in {} {
    global w tkimage zoomscale
    if ($zoomscale>=8.0) {
	set zoomscale 8.0
	return
    }
    set zoomscale [expr {$zoomscale*2} ]

    $w.can delete item 
    catch {image delete zoomimage}
    image create photo zoomimage
    zoomimage blank
    if ($zoomscale>=1.0) {
	zoomimage copy tkimage -zoom [format "%.0f" $zoomscale]
    } else {
	zoomimage copy tkimage -subsample [format "%.0f" [expr {1/$zoomscale}]]
    }

    $w.can create image 0 0 -tags item -image zoomimage  -anchor nw
    
    $w.can configure -scrollregion [$w.can bbox all]

} 

proc zoom_out {} {
    global w tkimage zoomscale
    if ($zoomscale<=0.125) {
	set zoomscale 0.125
	return
    }
    set zoomscale [expr {$zoomscale/2.0} ]

    $w.can delete item 
    catch {image delete zoomimage}
    image create photo zoomimage
    zoomimage blank
    if ($zoomscale>=1) {
	zoomimage copy tkimage -zoom [format "%.0f" $zoomscale]
    } else {
	zoomimage copy tkimage -subsample [format "%.0f" [expr {1/$zoomscale}]]
    }
    $w.can create image 0 0 -tags item -image zoomimage  -anchor nw

    $w.can configure -scrollregion [$w.can bbox all]

} 




