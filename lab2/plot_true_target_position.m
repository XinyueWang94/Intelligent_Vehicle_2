function plot_true_target_position(t, objects) 
    % plot true target positions
    delete(findobj('Tag', 'object'));
    
    for object = objects(:)'    
        plot( ... 
            object.pos(1,t), object.pos(2,t), ...
            '*', ...
            'Color', object.plot_color, ...
            'Tag', 'object');
    end
end