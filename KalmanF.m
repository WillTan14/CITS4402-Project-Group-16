tracks = cell(1, length(centroid));
covariances = cell(1, length(centroids));
predictions = [];
qk = [p^2, 0,0,0,0,0;
    0,p^2,0,0,0,0;
    0,0,d^2,0,0,0;
    0,0,0,d^2,0,0;
    0,0,0,0,a^2,0;
    0,0,0,0,0,a^2];
hk = [1, 0,0,0,0,0; 0,1,0,0,0,0];
rk = [d^2, 0: 0, d^2];
fk = [1,0,1,0,0.5,0;
      0,1,0,1,0,0.5;
      0,0,1,0,1,0;
      0,0,0,1,0,1;
      0,0,0,0,1,0;
      0,0,0,0,0,1];
I = eye(6);
for i=1: numFrames
    [assignment, unassignedTracks, unassignedDetections] =hypothesistotrack(predictions, centroiods);
    if ~isempty(unassignedDetections)
        for b = 1: length(unassignedDetections)
            %initialise tracks, display and then predict
            unassignedIndex = unassignedDetections(b);
            tracks{1, unassignedIndex} = [centroids(unassignedIndex, 1); centroids(unassignedIndex,2);0;0;0;0];
            covariances{1, unassignedIndex} = qk;
            predictions(indexUnassignedD, 1:2) = tracks{1,indexUnassignedD}(1:2,1);
            %display image + track
        end
    end
    if ~isempty(assignment)
        for c=1: length(assignment)
            %update step for kalman filter, display and then predict
            assignedIndex = assignment(c);
            %compute error
            yk = centroid - hk*tracks{1, assignedIndex};
            %compute covariance of innovation
            sk = hk*covariances{1, assignedIndex}*transpose(hk)+ rk;
            %compute kalman gain
            kk = covariances{1, assignedIndex}*transpose(hk)*sk^(-1);
            %compute updated state estimate
            tracks{1, assignedIndex} = tracks{1, assignedIndex} + kk*yk;
            %compute updated state covariance
            covariances{1, assignedIndex} = (I - kk*hk)*covariances{1, assignedIndex};
            %display image +track
        end
    end
    if ~isempty(unassignedTracks)
        for d =1: length(unassignedTracks)
        %nearest search, if found update step and display, else remove track
        end
    end
    path = strcat(app.image_files(i).folder, '\', app.image_files(i).name);
    im = imread(path);
    imshow(path);
    for e =1 : length(bbox)
        posx = bbox(d, 1);
        posy = bbox(d,2);
        width = bbox(d, 3);
        height = bbox(d,4);
        rectangle(app.UIAxes, "Position", [posx, posy,width, height],"EdgeColor", 'y');
    end
    %predict next track
    for e=1: length(tracks)
        tracks{1,e} = fk*tracks{1,e};
        covariances{1,e} = fk*covariances{1,e}*transpose(fk)+qk;
    end
end


