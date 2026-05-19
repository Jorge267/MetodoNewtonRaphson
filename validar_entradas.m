function [esValido, mensaje, x0, tol, maxIter] = validar_entradas(strFuncion, strX0, strTol, strMaxIter)
    % Inicializamos las variables de salida
    esValido = true;
    mensaje = 'Todo correcto. Procesando...';
    x0 = 0; tol = 0; maxIter = 0;

    % 1. VALIDACIÓN DE LA FUNCIÓN
    try
        % Convertimos el texto a una función matemática de MATLAB
        f = str2func(['@(x) ' strFuncion]);
        f(1); % Prueba rápida evaluando en 1 para ver si no truena
    catch
        esValido = false;
        mensaje = 'Error: La función ingresada no es válida o faltan operadores (ej. usar * para multiplicar).';
        return;
    end

    % 2. VALIDACIÓN DEL VALOR INICIAL (X0) con 8 decimales
    numX0 = str2double(strX0);
    if isnan(numX0)
        esValido = false;
        mensaje = 'Error: El valor inicial (X0) debe ser un número válido.';
        return;
    else
        % Forzamos formato de 8 decimales
        x0 = str2double(sprintf('%.8f', numX0));
    end

    % 3. VALIDACIÓN DE LA TOLERANCIA / MARGEN (Debe ser positivo)
    numTol = str2double(strTol);
    if isnan(numTol) || numTol <= 0
        esValido = false;
        mensaje = 'Error: El margen de variación (Tolerancia) debe ser un número mayor a 0.';
        return;
    else
        tol = str2double(sprintf('%.8f', numTol));
    end

    % 4. VALIDACIÓN DE ITERACIONES MÁXIMAS (Entero positivo)
    numMaxIter = str2double(strMaxIter);
    if isnan(numMaxIter) || numMaxIter <= 0 || mod(numMaxIter, 1) ~= 0
        esValido = false;
        mensaje = 'Error: El número de iteraciones debe ser un número entero positivo.';
        return;
    else
        maxIter = numMaxIter;
    end
end