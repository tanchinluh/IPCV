//=============================================================================
// Copyright (C) Trity Technologies - 2012 -
// http://www.gnu.org/licenses/gpl-2.0.txt
//=============================================================================
[L, n] = imbwlabel(img);
area = [];
count = 1;

// scan regions for connected areas
for i = 1:n
    area(count) = length(find(L==i));
    count = count + 1;
end
