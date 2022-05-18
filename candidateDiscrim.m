function [area, centroid, bbox, majoraxis, eccentricity, extent] = candidateDiscrim(binaryim, gry1)
[pixel_row, pixel_col] = find(binaryim);
for i = 1: length(pixel_row)
    lowerRindex = pixel_row(i) -5;
    upperRindex = pixel_row(i) + 5;
    lowerCindex = pixel_col(i) - 5;
    upperCindex = pixel_col(i) + 5;
    if lowerRindex > 0 && upperRindex <= 1025 %rows
        if lowerCindex > 0 && upperCindex <= 1025 %cols
            search_window = gry1(lowerRindex: upperRindex, lowerCindex : upperCindex);
        elseif lowerCindex < 1
            lowerCindex = 1;
            search_window = gry1(lowerRindex: upperRindex, lowerCindex : upperCindex);
        elseif upperCindex > 1025 %cols 
            upperCindex = 1025; %cols;
            search_window =gry1(lowerRindex: upperRindex, lowerCindex : upperCindex);
        end
    elseif lowerRindex < 1
        lowerRindex = 1;
        search_window = gry1(lowerRindex: upperRindex, lowerCindex : upperCindex);
    elseif upperRindex > 1025 %rows
        upperRindex = 1025; %rows;
        search_window = gry1(lowerRindex: upperRindex, lowerCindex : upperCindex);
    end
    pixel_values = [];
    n = 1;
    for b=1: length(pixel_col)
        if pixel_col(b) > lowerCindex && pixel_col(b) < upperCindex
            if pixel_row(b) > lowerRindex && pixel_row(b) < upperRindex
                pixel_values(n) = gry1(pixel_row(b), pixel_col(b));
                n = n+1;
            end
        end
    end
    mu = mean(pixel_values);
    sigma = std(double(pixel_values));
    x = norminv([0.0025, 0.9975], mu, sigma);
    for m = 1: numel(search_window)
        if search_window(m) > x(1) && search_window(m) < x(2)
            search_window(m) = 1;
        else 
            search_window(m) = 0;
        end
    end
    final(lowerRindex:upperRindex, lowerCindex: upperCindex) = search_window;
end
hblob = vision.BlobAnalysis('MajorAxisLengthOutputPort', true, 'EccentricityOutputPort', true, 'ExtentOutputPort', true);
[area, centroid, bbox, majoraxis, eccentricity, extent] = hblob(logical(final));
end

