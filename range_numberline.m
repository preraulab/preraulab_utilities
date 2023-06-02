classdef range_numberline < handle
    % RANGENUMBERLINE Class for creating and updating a number line with a range and position indicator.
    %
    % This class provides a visual representation of a number line with a
    % range and position indicator. The range is represented by a
    % rectangle, and the position is represented by a line. The class
    % allows updating the position and range dynamically.
    %
    % Example usage:
    %   ax = axes;
    %   limits = [0 100];
    %   pos = 5;
    %   range = [0 10];
    %   numline = range_numberline(ax, limits, pos, range);
    %   numline.update_range(8, [2 12]);
    %
    % Copyright 2023 Michael J. Prerau Laboratory. - http://www.sleepEEG.org
    %

    properties
        ax % Axis for plot
        limits % Limits for plot
        range_rect = [] % Rectangle object
        range_line = [] % Line object
        pos % Middle position
        range % Range
    end

    methods
        function obj = range_numberline(ax, limits, pos, range)
            % Constructor for the range_numberline class.
            %   ax: (optional) Axis for the plot. If not provided, the current axis (gca) will be used.
            %   limits: (optional) Limits for the number line plot. Default is [0 100].
            %   pos: (optional) Middle position indicator. Default is 5.
            %   range: (optional) Range for the number line. Default is [0 10].

            if nargin == 0 || isempty(ax)
                obj.ax = gca;
            else
                obj.ax = ax;
            end

            if nargin < 2
                obj.limits = [0 100];
            else
                obj.limits = limits;
            end

            if nargin < 3
                obj.pos = 5;
            else
                obj.pos = pos;
            end

            if nargin < 4
                obj.range = [0 10];
            else
                obj.range = range;
            end

            obj.ax.XAxisLocation = "bottom";
            obj.ax.YAxis.Visible = "off";
            obj.ax.XLim = obj.limits;
            obj.ax.YLim = [0 1];
            obj.ax.YTick = [];
            obj.ax.FontSize = 15;

            obj.draw_range();
        end

        function obj = update_range(obj, pos, range)
            % Updates the position and range of the number line.
            %   pos: Middle position indicator.
            %   range: Range for the number line.

            obj.pos = pos;
            obj.range = range;
            obj.draw_range();
        end
    end

    methods (Access = private)
        function obj = draw_range(obj)
            % Draws the range rectangle and position line on the number line.

            % Update range and pos
            assert(~isempty(obj.pos) && obj.pos > obj.range(1) && obj.pos < obj.range(2), 'Position must have a value within range');
            assert(~isempty(obj.range), 'Range must have a value');

            if isempty(obj.range_rect)
                obj.range_rect = rectangle(obj.ax,"FaceColor", [0 0 1 .2], 'edgecolor', 'none', 'Position', [obj.range(1) 0 diff(obj.range), 1]);
            else
                obj.range_rect.Position = [obj.range(1) 0, diff(obj.range), 1];
            end

            if isempty(obj.range_line)
                obj.range_line = line(obj.ax,[obj.pos obj.pos], [0 1], 'color', 'blue', 'linewidth', 2);
            else
                obj.range_line.XData = [obj.pos obj.pos];
            end
        end
    end
end
