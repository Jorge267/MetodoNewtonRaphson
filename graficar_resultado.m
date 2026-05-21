function graficar_resultado(ax, f_str, resultados)
    % graficar_resultado Dibuja la función y las iteraciones del método en un UIAxes
    %
    % Entradas:
    %   ax         - El UIAxes donde se va a graficar (ej: app.UIAxes)
    %   f_str      - La función en forma de string (ej: '8*x^5 + 4*x^4...')
    %   resultados - Matriz Nx5 con los resultados de calcular_newton_raphson
    
    if isempty(resultados)
        return;
    end
    
    % Convertir la función a anónima (vectorizada)
    f_str_vec = vectorize(f_str);
    f = str2func(['@(x) ' f_str_vec]);
    
    % Extraer los valores de iteración x_i
    % Incluimos el x_i final para ver el último paso
    x_iter = [resultados(:, 1); resultados(end, 5)];
    y_iter = [resultados(:, 2); f(resultados(end, 5))];
    
    % Rango de la gráfica
    margen = max(0.5, (max(x_iter) - min(x_iter)) * 0.2);
    x_min = min(x_iter) - margen;
    x_max = max(x_iter) + margen;
    
    % Puntos para la curva suave
    x_eje = linspace(x_min, x_max, 1000);
    y_eje = f(x_eje);
    
    % Limpiar el eje
    cla(ax);
    
    % Configuración de colores oscuros (opcional, como en tu ejemplo)
    set(ax, 'Color', [0.1 0.1 0.2], 'XColor', [1 1 1], 'YColor', [1 1 1], 'GridColor', [0.5 0.5 0.5], 'GridAlpha', 0.4);
    
    % Graficar la función principal
    plot(ax, x_eje, y_eje, 'c-', 'LineWidth', 2); 
    hold(ax, 'on'); 
    grid(ax, 'on');
    
    % Eje X (y = 0)
    plot(ax, [x_min, x_max], [0, 0], 'w-', 'LineWidth', 1.2);
    
    colors = jet(length(x_iter));
    rango_y = max(y_eje) - min(y_eje);
    desp_texto = max(0.1, rango_y * 0.05);
    
    % Graficar los puntos de iteración
    for i = 1:length(x_iter)
        % Punto en la curva
        plot(ax, x_iter(i), y_iter(i), 'o', 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', 'w', 'MarkerSize', 8);
        
        % Línea vertical desde el eje X hasta el punto
        plot(ax, [x_iter(i), x_iter(i)], [0, y_iter(i)], ':', 'Color', [0.7 0.7 0.7]);
        
        % Etiqueta de la iteración
        texto_iter = sprintf('x_{%d}', i-1);
        text(ax, x_iter(i), y_iter(i) + desp_texto, texto_iter, 'HorizontalAlignment', 'center', 'FontSize', 10, 'FontWeight', 'bold', 'Color', [1 1 1]);
    end
    
    % Conectar las líneas tangentes (Pasos de Newton Raphson)
    for i = 1:length(x_iter)-1
        % En el Newton clásico la tangente corta en el siguiente x. 
        % Trazamos la línea desde (xi, f(xi)) hasta (xi+1, 0)
        plot(ax, [x_iter(i), x_iter(i+1)], [y_iter(i), 0], 'y--', 'LineWidth', 1.5);
    end
    
    % Títulos y Etiquetas
    title(ax, 'Método de Newton-Raphson', 'FontSize', 14, 'Color', [1 1 1]);
    xlabel(ax, 'X', 'FontSize', 12, 'Color', [1 1 1]);
    ylabel(ax, 'f(X)', 'FontSize', 12, 'Color', [1 1 1]);
    
    % Leyenda
    lgd = legend(ax, 'f(x) Función', 'Eje X (y=0)', 'Puntos de iteración', 'Pasos del método', 'Location', 'Best');
    set(lgd, 'TextColor', [1 1 1], 'Color', [0.15 0.12 0.15], 'EdgeColor', [0.5 0.5 0.5]);
    
    % Ajustar los límites de la gráfica
    axis(ax, [x_min, x_max, min(y_eje) - desp_texto*2, max(y_eje) + desp_texto*2]);
    hold(ax, 'off');
end
