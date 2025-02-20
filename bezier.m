
function points_bezier = bezier(points_controle, lissage_niveau)
    
    %%% v1
    %{
    n = size(points_controle, 1) - 1;

    % Créer un vecteur t avec plus de points pour un lissage plus fin
    t = linspace(0, 1, max(50, n*10)); % Ajuster le nombre de points selon le nombre de points de contrôle
    t = t.^lissage_niveau; %appliquer le niveau de lissage sur t

    points_bezier = zeros(length(t), 2); % Pré-allouer la mémoire pour plus d'efficacité
    for i = 1:length(t)
        p = [0, 0];
        for j = 0:n
            p = p + nchoosek(n, j) * (1 - t(i))^(n - j) * t(i)^j * points_controle(j + 1, :);
        end
        points_bezier(i, :) = p;
    end
    %} 
    
   %%%% v2 : plus stable numériquement 
    n = size(points_controle, 1) - 1;
    t = linspace(0, 1, max(100, n*10));
    t = t.^lissage_niveau;
    points_bezier = zeros(length(t), 2);
    for i = 1:length(t)
        p = [0, 0];
        for j = 0:n
            % Calcul plus stable du coefficient binomial
            coeff = exp(gammaln(n + 1) - gammaln(j + 1) - gammaln(n - j + 1));
            p = p + coeff * (1 - t(i))^(n - j) * t(i)^j * points_controle(j + 1, :);
        end
        points_bezier(i, :) = p;
    end
    
    
    
end