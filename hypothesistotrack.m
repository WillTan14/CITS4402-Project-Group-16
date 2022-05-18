function [assignment, unassignedTracks, unassignedDetections] =hypothesistotrack(predictions, detections)
cost = zeros(size(predictions,1), size(detections,1));
for i = 1: size(predictions,1)
    diff = detections - repmat(predictions(i, :), [size(detections,1), 1]);
    cost(i, :) = sqrt(sum(diff.^2,2));
end
[assignment, unassignedTracks, unassignedDetections] = assignDetectionsToTracks(cost, 0.7);
