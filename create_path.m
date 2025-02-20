function create_path(x_min,x_max,y_min,y_max,NivLis)

% Paramètres du carré
xmin = x_min;
xmax = x_max;
ymin = y_min;
ymax = y_max;

% Paramètres de lissage et d'échantillonnage
lissage_niveau = NivLis;


% Création de la figure et des axes
fig = figure('Name', 'Création de chemin', 'NumberTitle', 'off');
ax = axes('Parent', fig);
axis([xmin xmax ymin ymax]);
grid on;
hold on;
title('Draw a path');
xlabel('X [m]');
ylabel('Y [m]');

% Dessin du carré
rectangle('Position', [xmin, ymin, xmax - xmin, ymax - ymin], 'EdgeColor', 'b');

% Initialisation des variables
points = [];
ligne_tracee = [];
ligne_lisse = [];
trace_valide = false; % Variable pour indiquer si le tracé est validé

% Création du panneau pour les boutons
panel_buttons = uipanel('Parent', fig, 'Title', 'Contrôles', ...
    'Position', [0.01 0.01 0.2 0.1]); % Position et taille du panneau (ajuster selon besoin)

% Boutons "Effacer" et "OK" dans le panneau
uicontrol('Style', 'pushbutton', 'String', 'Erase path', ...
    'Parent', panel_buttons, 'Units','normalized',...
    'Position', [0.1 0.2 0.4 0.6], ... % Position relative dans le panneau
    'Callback', @effacer_trace);

uicontrol('Style', 'pushbutton', 'String', 'Confirm', ...
    'Parent', panel_buttons,'Units','normalized', ...
    'Position', [0.55 0.2 0.4 0.6], ... % Position relative dans le panneau
    'Callback', @valider_trace);

% Ajuster la position des axes pour laisser de la place au panneau
set(ax, 'Position', [0.25 0.15 0.7 0.8]); % Ajuster les valeurs selon besoin

% Gestion des événements souris (inchangé)
set(ax, 'ButtonDownFcn', @debut_trace);

% Gestion des événements souris
set(ax, 'ButtonDownFcn', @debut_trace);

    function debut_trace(~, ~)
        if ~trace_valide % Empêcher de tracer si le tracé est déjà validé
            points = [];
            set(fig, 'WindowButtonMotionFcn', @tracer_chemin);
            set(fig, 'WindowButtonUpFcn', @fin_trace);
        end
    end

    function tracer_chemin(~, ~)
        if ~trace_valide
            C = get(ax, 'CurrentPoint');
            x = C(1,1);
            y = C(1,2);
            if(x >= xmin && x <= xmax && y >= ymin && y <= ymax)
                points = [points; x, y];
                if ~isempty(ligne_tracee)
                    delete(ligne_tracee);
                end
                ligne_tracee = plot(points(:,1), points(:,2), '-r', 'LineWidth', 1.5, 'Parent', ax);
                drawnow;
            end
        end
    end

    function fin_trace(~, ~)
        if ~trace_valide
            set(fig, 'WindowButtonMotionFcn', '');
            set(fig, 'WindowButtonUpFcn', '');
        end
    end

    function valider_trace(~, ~)
        if ~trace_valide && size(points, 1) > 2 % Validation seulement si le tracé n'est pas déjà validé et qu'il y a au moins 3 points
            trace_valide = true; % Marquer le tracé comme validé

           
            tol = 0.01; 
            points = simplifier_points(points, tol); % Par exemple, une tolérance de 0.01
            % Lissage avec les courbes de Bézier
            points_lisses = bezier(points, lissage_niveau);
            while  isnan(points_lisses(1,1))==1
                tol = tol + 0.01; 
                points = simplifier_points(points, tol);
                 points_lisses = bezier(points, lissage_niveau);
            end
            assignin('base','XY_hand',points);

            if ~isempty(ligne_lisse)
                delete(ligne_lisse);
            end

            ligne_lisse = plot(points_lisses(:,1), points_lisses(:,2), '-g', 'LineWidth', 2, 'Parent', ax);
            legend('Hand Drawn','smouthed')   
            

                % Exportation des waypoints
                X_waypoints = points_lisses(:, 1);
                Y_waypoints = points_lisses(:, 2);
                assignin('base','X_waypoints',X_waypoints);
                assignin('base','Y_waypoints',Y_waypoints);
                disp("les waypoint on été exporter dans l'espace de travail sous le nom X_waypoints et Y_waypoints")
        else
            if size(points,1) <= 2
                disp("pas asser de point pour faire un lissage")
            end
        end
    end

    function effacer_trace(~, ~)
        cla(ax);
        rectangle('Position', [xmin, ymin, xmax - xmin, ymax - ymin], 'EdgeColor', 'b');
        points = [];
        ligne_tracee = [];
        ligne_lisse = [];
        trace_valide = false; % Réinitialiser la validation
    end

end


function points_simplifies = simplifier_points(points, tolerance)
    points_simplifies = points(1,:);
    for i = 2:size(points, 1)
        if norm(points(i,:) - points_simplifies(end,:)) > tolerance
            points_simplifies = [points_simplifies; points(i,:)];
        end
    end
end
