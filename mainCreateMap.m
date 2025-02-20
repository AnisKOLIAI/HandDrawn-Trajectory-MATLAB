%% Génération et Lissage de Trajectoire

% Author : Anis KOLIAI
% Date : 17/01/2025
clear all, close all, clc;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Hyper Params %%%%%%%%%%%%%%%%%%%%%
% Bordures de la map
xmin = -1.2;
xmax = 1.5;
ymin = -1;
ymax = 2;

% Paramètres de lissage entre 0 et 1
lissage_niveau = 0.8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
create_path(xmin,xmax,ymin,ymax,lissage_niveau); % Exécute la fonction create_path

% Attendre que l'utilisateur interagisse et ferme la figure.
uiwait(gcf);

% Vérifier si les variables X_waypoints et Y_waypoints existent dans l'espace de travail
if evalin('base', 'exist(''X_waypoints'', ''var'')') && evalin('base', 'exist(''Y_waypoints'', ''var'')')
    disp('Test 1 réussi : Les variables X_waypoints et Y_waypoints ont été créées.');
    X_waypoints = evalin('base','X_waypoints');
    Y_waypoints = evalin('base','Y_waypoints');
    disp(['Taille de X_waypoints : ', num2str(size(X_waypoints))]);
    disp(['Taille de Y_waypoints : ', num2str(size(Y_waypoints))]);
else
    error('Test 1 échoué : Les variables X_waypoints et Y_waypoints n''ont pas été créées.');
end

%% Fianle result 
figure(10)
plot(X_waypoints,Y_waypoints,'-*r');
grid on 
hold on
plot(XY_hand(:,1),XY_hand(:,2),'-.b');
hold off
legend('smouthed','hand drown')
title('Created Trajectory')
