function kf = run_single_kf_gating(kf, sensor, measurements)
    T = numel(measurements);
    
    % iterate over all T time steps
    for t = 1:T
        % get measured distances at the current time step
        dists = measurements(t).dists; 
        
        % convert the measured distances of the sensor to x,y coordinates
        meas_pos = sensor.dist_to_pos(dists);

        % measurments the equal maximum distance of the sensor
        %   or probably not actual object detections.
        % Only keep the measurements that are below this range
        mask = (dists < sensor.max_range);
        meas_pos = meas_pos(:,mask);

        %% Predict step
        kf = kf_predict_step(kf);
        
        %% Update step
        %   we will only update with the working measurments
        for r = 1:size(meas_pos,2)
            % the measurment along the r-th ray
            meas_r = meas_pos(:,r);           
            
            % -- GATING --
            %  The test_gating_score function should return
            %  a boolean value if the measurement is within
            %  the gating threshold.
            [is_ok, ~] = test_gating_score(kf, meas_r);
            
            if is_ok
                kf = kf_update_step(kf, meas_r);
            end
        end

    end

end