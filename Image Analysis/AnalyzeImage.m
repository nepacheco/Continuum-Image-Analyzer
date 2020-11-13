function notchAngles = AnalyzeImage(numberofNotches,Image)

notchAngles = zeros(numberofNotches,1);
rectanglePositions = [];
for i = 1:numberofNotches
    [notchImage, roi] = SelectNotch(Image,'previousRegions',rectanglePositions);
    rectanglePositions = [rectanglePositions; roi];
    theta = AnalyzeNotch(notchImage);
    notchAngles(i) = theta;
end
end

