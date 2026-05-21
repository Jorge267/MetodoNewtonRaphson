function resultados = calcular_newton_raphson(f_str, x0, tol, maxIter)
% calcular_newton_raphson  Aplica el método de Newton-Raphson Modificado.
%
%   resultados = calcular_newton_raphson(f_str, x0, tol, maxIter)
%
%   Entradas:
%     f_str   – función como string, ej: '8*x^5 + 4*x^4 + 6*x^2 + 6*x - 1'
%     x0      – valor inicial (punto de partida)
%     tol     – tolerancia para el criterio de parada
%     maxIter – número máximo de iteraciones
%
%   Salida:
%     resultados – matriz Nx5 con columnas: [xi, f(xi), f'(xi), f''(xi), xi+1]
%                  Compatible con generar_tabla(tabla, resultados)

    % Convertir el string de la función a expresión simbólica
    syms x
  f_sym = str2sym(f_str);
    df_sym = diff(f_sym, x);       % Primera derivada
    d2f_sym = diff(df_sym, x);     % Segunda derivada

    % Convertir a funciones numéricas para evaluación rápida
    f   = matlabFunction(f_sym,   'Vars', x);
    df  = matlabFunction(df_sym,  'Vars', x);
    d2f = matlabFunction(d2f_sym, 'Vars', x);

    % Preasignar matriz de resultados
    resultados = zeros(maxIter, 5);

    xi = x0;

    for i = 1:maxIter
        fxi   = f(xi);
        dfxi  = df(xi);
        d2fxi = d2f(xi);

        % Fórmula de Newton-Raphson Modificado:
        % xi+1 = xi - [ f(xi)*f'(xi) ] / [ f'(xi)^2 - f(xi)*f''(xi) ]
        denominador = dfxi^2 - fxi * d2fxi;

        if denominador == 0
            warning('Denominador cero en iteración %d. Se detiene.', i);
            resultados = resultados(1:i-1, :);
            return;
        end

        xi_next = xi - (fxi * dfxi) / denominador;

        % Guardar fila: [xi, f(xi), f'(xi), f''(xi), xi+1]
        resultados(i, :) = [xi, fxi, dfxi, d2fxi, xi_next];

        % Criterio de parada: cambio en x menor que la tolerancia
        if abs(xi_next - xi) < tol
            resultados = resultados(1:i, :);
            return;
        end

        xi = xi_next;
    end

    % Si se agotaron las iteraciones, devolver todo lo calculado
    resultados = resultados(1:maxIter, :);
end