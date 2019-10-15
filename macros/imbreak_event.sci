function imbreak_event(win, x, y, ibut)
global breakloop;
  if ibut==-1000 then return,end
  if ibut==27
      breakloop = %t;
  end
endfunction
