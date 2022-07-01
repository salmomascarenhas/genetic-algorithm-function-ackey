clear all;
clc;
tic;

qnt_individuos = 100;       % qtd de indivíduos.
num_bit = 40;               % qtd de bits para representar cada individuo.  
epocas = 100;                % qtd de gerações.
sup = 10;
inf = -10;

%%%% GERA UMA POPULAÇÃO PSEUDO ALEATÓRIA com tamanho 100x40 %%%%
matriz_populacao = randi([0,1],qnt_individuos,num_bit);

for epoca =1: epocas
    
    for i=1:qnt_individuos
        
        %%%%%% Conversão dos números binários para decimais %%%%%
        %   -> Os 20 primeiros bits (Colunas) da matriz de individuos= representam x.  
        %   -> Os 20 últimos bits (Colunas) da matriz de individuos = representam y.
        
        individuos_x = matriz_populacao(i, 1:20);      % Composto pelos 20 primeiros bits da matriz de indivíduos
        x_str = erase(strcat(num2str(individuos_x)),' ');           % Concatenando e convertendo os bits para string
        
        individuos_y = matriz_populacao(i, 21:40);     % Composto pelos 10 últimos bits da matriz de indivíduos
        y_str = erase(strcat(num2str(individuos_y)),' ');           % Concatenando e convertendo os bits para string

        x(i) = bin2dec(x_str);                      % Converte de binário para decimal
        y(i)= bin2dec(y_str);                        % Converte de binário para decimal 
        
        % Convertendo bits para números, na qual x e y pertencem ao intervalo [-10 10]*/
        x_real(i) = inf+(sup - inf)/((2^10)-1)*x(i);     % Representação de x em real entre o intervalo [-5 5]
        y_real(i) = inf+(sup - inf)/((2^10)-1)*y(i);     % Representação de y em real entre o intervalo [-5 5]
        

        %********************************* CÁLCULO DA FUNÇÃO DE AVALIAÇÃO - NOTAS ******************************************************/
        
        % Cálculo da função de avaliação -
         %   -> Utilizada para determinar a qualidade de um indivíduo || É uma nota dada ao indivíduo.
          %  -> Função de Rosenbrock: f(x, y) =(1 – x)^2 + 100(y – x^2)^2 
         
        nota(i) = -20 * exp(-0.2*sqrt(0.5*(x_real(i)^(2) + y_real(i)^(2)))) - exp(0.5*(cos(2*pi*x_real(i)) + cos(2*pi*y_real(i)))) + exp(1) + 20;
    end

    
    
    %***************************************** SELEÇÃO DOS PAIS - MÉTODO DO TORNEIO ************************************************/
        
    % Vamos selecionar "n" indivíduos que irão participar do torneio:
    %participantes = matriz_individuos(1:qnt_participantes, 1:20);   // Dimensionando a matriz "participantes"
    %nota_part = nota(1:qnt_participantes, :);                       // Dimensionando a matriz para notas dos participantes
        
    for i = 1:qnt_individuos
        
        for p = 1:qnt_individuos
            pos_indiv_aleat = ceil(rand()*qnt_individuos)                       %// Gera uma posição aleatórias.
            participantes(p, :) = matriz_populacao(pos_indiv_aleat, 1:20);     %// Seleciona aleatoriamente "n" indivíduos para participar do torneio.
        end
        
        for j = 1:qnt_participantes
            x1_partic1 = participantes(j, 1:10);             %// Composto pelos 10 primeiros bits da matriz de participantes
            x_partic_str = strcat(string(x1_partic1))        %// Concatenando e convertendo os bits para string
            
            y1_partic1 = participantes(j, 11:20);            %// Composto pelos 10 últimos bits da matriz de participantes
            y_partic_str = strcat(string(y1_partic1))        %// Concatenando e convertendo os bits para string
             
            x1_partcl_decimal(j) = bin2dec(x_partic_str)     %// Converte de binário para decimal (x)
            y1_partcl_decimal(j) = bin2dec(y_partic_str)     %// Converte de binário para decimal (y)
            
            x1_real(j) = inf+(sup - inf)/((2^10)-1)*x1_partcl_decimal(j);   %// Representação de x em real entre o intervalo [-5 5]  
            y1_real(j) = inf+(sup - inf)/((2^10)-1)*y1_partcl_decimal(j);   %// Representação de y em real entre o intervalo [-5 5]
            
            nota_part(j, :) = (1 - x1_real(j))^2 + 100*(y1_real(j) - x1_real(j)^2)^2  %// Notas dos participantes do torneio 
        end
        
        [valor,indice] = min(nota_part)                           %// Recebe os valores e os índices das menores notas
        matriz_individuos_pais(i, :) = participantes(indice, :)   %// Recebe os pais que foram selecionados
    end
end

toc;
