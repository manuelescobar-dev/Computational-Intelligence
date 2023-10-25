function [Cspace] = CspaceEjemplo(size)
    % Esta función genera de manera aleatoria un C-space de ejemplo para ser
    % usado con los algoritmos de búsqueda
    % se crea una matriz de ceros para poner los obstáculos aleatorios
    Cspace1=zeros(size);
    for i = 1:round(numel(Cspace1)*0.2) % porcentaje de espacio que será considerado obstáculos
        Cspace1(randi(size),randi(size))=1;
    end
    Cspace=zeros(size+2); % se crea una matriz de ceros con paredes
    Cspace(1,:)=1;
    Cspace(size+2,:)=1;
    Cspace(:,1)=1;
    Cspace(:,size+2)=1;
    % se diseña el Cspace final
    Cspace(2:size+1,2:size+1)=Cspace1;
    %Gráfica
end