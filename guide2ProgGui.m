function guide2ProgGui(figureName)

% This function migrates any interface drawn with GUIDE to code which draws 
% the same interface programatically. Drawing the interface programatically 
% can be tidious and time consuming. The goal is to save time by letting the 
% programmer draw with GUIDE and convert the drawn interface to code which
% enables him to manage the GUI programatically. The tag property of each 
% object is considered as it's name. The object types considered are figures,
% uicontrols, axes, uipanels, uibuttongroup, and uitable. Only most used 
% properties have been taken into consideration. The program could always be 
% modified to integrate even more properties and functionalities.
% The program does not take Callbacks into consideration. It is intended just
% to reproduce the interface drawn in the GUIDE mode in the programatic GUI mode.
% 
% Author: Gouater Loic Dimitri
% Original Date: 06/10/2019
% 
% Copyright 2019 Computational Engineering Academy



    % Text File to write to
    fileName = [figureName(1:find(figureName=='.')-1), '_gui.m'];
    fid = fopen(fileName,'w+t');
    
    % Getting Figure's Handle
    fig = open(figureName);
    set(fig,'visible','off')
   
    % Programmatic Gui Code
    % Function Start
    fprintf(fid,'function %s\n',fileName(1:find(fileName=='.')-1));
    % Function Body
    % All GUIDE Objects
    objects = findall(fig);
    % Parent Tags of each Object
    parents = get(objects,'parent');
    parentsTag = cell(length(parents),1);
    for i = 1:length(parents)
        parentsTag{i} = get(parents{i},'tag');
    end
    % Objects creation Code
    for obj = objects'
        % Common Properties
        %un = get(obj,'unit'); % Unit
        set(obj,'units','pixels')
        pos = get(obj,'position');  % Position
        tag = get(obj,'tag');  % Object's Name, TAG
        
        
        if strcmp(get(obj,'type'),'figure')
            % Relevant Properties
            col = get(obj,'color');
            fprintf(fid,'\t%s = figure(''MenuBar'',''None'',''NumberTitle'',''off'',''Name'',''%s'',...\n',tag,get(obj,'name'));
            fprintf(fid,'\t\t''color'',[%.2f,%.2f,%.2f],''position'',[%.0f,%.0f,%.0f,%.0f],''visible'',''off'');%% %s\n',col,pos,tag);
            fprintf(fid,'\tmovegui(gcf,''center'')\n');
            fprintf(fid,'\n');
        elseif strcmp(get(obj,'type'),'uicontrol')
            col1 = get(obj,'backgroundcolor');
            col2 = get(obj,'foregroundcolor');
            fprintf(fid,'\tuicontrol(%s,''style'',''%s'',''fontname'',''%s'',''fontsize'',%.1f,...\n',parentsTag{obj==objects},get(obj,'style'),get(obj,'fontname'),get(obj,'fontsize'));
            fprintf(fid,'\t\t''backgroundcolor'',[%.2f,%.2f,%.2f],''foregroundcolor'',[%.2f,%.2f,%.2f],''position'',[%.0f,%.0f,%.0f,%.0f],...\n',col1,col2,pos);
            % String Property
            str = get(obj,'string');
            if ~iscell(str)
                if size(str,1)==1
                    fprintf(fid,'\t\t''string'',''%s'',',str);
                else
                    str = cellstr(str);
                    fprintf(fid,'\t\t''string'',{');
                    for i=1:length(str)-1
                        fprintf(fid,'''%s'';',str{i,:});
                    end
                    fprintf(fid,'''%s''},',str{end,:});
                end
            elseif length(str) == 1
                fprintf(fid,'\t\t''string'',''%s'',',str{1,:});
            else
                fprintf(fid,'\t\t''string'',{');
                for i=1:length(str)-1
                    fprintf(fid,'''%s'';',str{i,:});
                end
                fprintf(fid,'''%s''},',str{end,:});
            end
            % Other
            fprintf(fid,'''fontangle'',''%s'',''fontweight'',''%s'')%% %s\n',get(obj,'fontangle'),get(obj,'fontweight'),tag);
            fprintf(fid,'\n');
        elseif strcmp(get(obj,'type'),'axes')
            col = get(obj,'color');
            fprintf(fid,'\taxes(''parent'',%s,''color'',[%.2f,%.2f,%.2f],''units'',''pixels'',''position'',[%.0f,%.0f,%.0f,%.0f])%% %s\n',parentsTag{obj==objects},col,pos,tag);
            fprintf(fid,'\n');
        elseif strcmp(get(obj,'type'),'uipanel')
            col1 = get(obj,'backgroundcolor');
            col2 = get(obj,'foregroundcolor');
            str = get(obj,'title');
            if ~iscell(str)
                str = cellstr(str);
            end
            fprintf(fid,'\t%s = uipanel(''parent'',%s,''units'',''pixels'',''title'',''%s'',''fontname'',''%s'',''fontsize'',%.1f,...\n',tag,parentsTag{obj==objects},str{1},get(obj,'fontname'),get(obj,'fontsize'));
            fprintf(fid,'\t\t''backgroundcolor'',[%.2f,%.2f,%.2f],''foregroundcolor'',[%.2f,%.2f,%.2f],''position'',[%.0f,%.0f,%.0f,%.0f],...\n',col1,col2,pos);
            fprintf(fid,'\t\t''fontangle'',''%s'',''fontweight'',''%s'',''titleposition'',''%s'');%% %s\n',get(obj,'fontangle'),get(obj,'fontweight'),get(obj,'titleposition'),tag);
            fprintf(fid,'\n');
        elseif strcmp(get(obj,'type'),'uibuttongroup')
            col1 = get(obj,'backgroundcolor');
            col2 = get(obj,'foregroundcolor');
            str = get(obj,'title');
            if ~iscell(str)
                str = cellstr(str);
            end
            fprintf(fid,'\t%s = uibuttongroup(''parent'',%s,''units'',''pixels'',''title'',''%s'',''fontname'',''%s'',''fontsize'',%.1f,...\n',tag,parentsTag{obj==objects},str{1},get(obj,'fontname'),get(obj,'fontsize'));
            fprintf(fid,'\t\t''backgroundcolor'',[%.2f,%.2f,%.2f],''foregroundcolor'',[%.2f,%.2f,%.2f],''position'',[%.0f,%.0f,%.0f,%.0f],...\n',col1,col2,pos);
            fprintf(fid,'\t\t''fontangle'',''%s'',''fontweight'',''%s'',''titleposition'',''%s'');%% %s\n',get(obj,'fontangle'),get(obj,'fontweight'),get(obj,'titleposition'),tag);
            fprintf(fid,'\n');
        elseif strcmp(get(obj,'type'),'uitable')
            col2 = get(obj,'foregroundcolor');
            fprintf(fid,'\tuitable(''parent'',%s,''fontname'',''%s'',''fontsize'',%.1f,...\n',parentsTag{obj==objects},get(obj,'fontname'),get(obj,'fontsize'));
            fprintf(fid,'\t\t''foregroundcolor'',[%.2f,%.2f,%.2f],''position'',[%.0f,%.0f,%.0f,%.0f],...\n',col2,pos);
            fprintf(fid,'\t\t''fontangle'',''%s'',''fontweight'',''%s'');%% %s\n',get(obj,'fontangle'),get(obj,'fontweight'),tag);
            fprintf(fid,'\n');
        end
    end
    % Function End
    fprintf(fid,'\tset(gcf,''visible'',''on'')\n');
    fprintf(fid,'end');
    
    % End of Program
    delete(fig)
    fclose(fid);
end