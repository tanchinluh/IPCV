function value = imcomparehist(h1, h2, method)
    // Compare two histograms.
    //
    // Syntax
    //    value = imcomparehist(h1, h2)
    //    value = imcomparehist(h1, h2, method)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 3 then
        error("imcomparehist: Wrong number of input arguments.");
    end
    if rhs < 3 then method = "correlation"; end
    a = matrix(double(h1), -1, 1);
    b = matrix(double(h2), -1, 1);
    if size(a, "*") <> size(b, "*") then
        error("imcomparehist: histograms must have the same number of elements.");
    end

    select convstr(method, "l")
    case "correlation" then
        aa = a - mean(a);
        bb = b - mean(b);
        den = sqrt(sum(aa .^ 2) * sum(bb .^ 2));
        if den == 0 then value = 0; else value = sum(aa .* bb) / den; end
    case "chisqr" then
        den = a + (a == 0);
        value = sum(((a - b) .^ 2) ./ den);
    case "intersection" then
        value = sum(min(a, b));
    case "bhattacharyya" then
        if sum(a) == 0 | sum(b) == 0 then
            value = 1;
        else
            pa = a ./ sum(a);
            pb = b ./ sum(b);
            value = sqrt(max(0, 1 - sum(sqrt(pa .* pb))));
        end
    else
        error("imcomparehist: Unsupported comparison method.");
    end
endfunction
