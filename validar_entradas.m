function [esValido, mensaje, x0, tol, maxIter] = validar_entradas(strFuncion, strX0, strTol, strMaxIter)
    % Inicializamos las variables de salida
    esValido = true;
    mensaje = 'Todo correcto. Procesando...';
    x0 = 0; tol = 0; maxIter = 0;

    % 1. VALIDACIÓN DE ENTRADAS VACÍAS
    if isempty(strFuncion) || isempty(strX0) || isempty(strTol) || isempty(strMaxIter)
        esValido = false;
        mensaje = 'Error: Todos los campos son obligatorios y no pueden estar vacíos.';
        return;
    end

    % 2. VALIDACIÓN Y PREPARACIÓN DE LA FUNCIÓN
    try
        % Limpiamos espacios en blanco
        strFuncion = strtrim(strFuncion);
        
        % Convertimos la función a formato vectorial automáticamente (agrega .^ , .* , ./)
        % para evitar errores en las graficas
        strFuncionVectorial = vectorize(strFuncion);
        
        % Convertimos el texto a una función matemática real de MATLAB
        f = str2func(['@(x) ' strFuncionVectorial]);
        
        % Prueba de evaluación en dos puntos para asegurar consistencia
        resultadoEval1 = f(1);
        resultadoEval2 = f(2);
        
        % Verificamos que el resultado no sea Infinito, NaN o un número complejo
        if ~isfinite(resultadoEval1) || ~isreal(resultadoEval1) || ~isfinite(resultadoEval2)
            esValido = false;
            mensaje = 'Error: La función produce valores indeterminados, infinitos o complejos en el rango de prueba.';
            return;
        end
    catch
        esValido = false;
        mensaje = 'Error: La función ingresada no es válida. Asegúrate de usar * para multiplicar (ej: 4*x) y que la variable sea "x".';
        return;
    end

    % 3. VALIDACIÓN DEL VALOR INICIAL (X0) con 8 decimales
    numX0 = str2double(strX0);
    if isnan(numX0) || ~isreal(numX0)
        esValido = false;
        mensaje = 'Error: El valor inicial (X0) debe ser un número real válido.';
        return;
    else
        x0 = str2double(sprintf('%.8f', numX0));
    end

    % 4. VALIDACIÓN DE LA TOLERANCIA / MARGEN (Debe ser positivo)
    numTol = str2double(strTol);
    if isnan(numTol) || numTol <= 0 || ~isreal(numTol)
        esValido = false;
        mensaje = 'Error: El margen de variación (Tolerancia) debe ser un número real mayor a 0.';
        return;
    else
        tol = str2double(sprintf('%.8f', numTol));
    end

    % 5. VALIDACIÓN DE ITERACIONES MÁXIMAS (Entero positivo)
    numMaxIter = str2double(strMaxIter);
    if isnan(numMaxIter) || numMaxIter <= 0 || mod(numMaxIter, 1) ~= 0
        esValido = false;
        mensaje = 'Error: El número de iteraciones debe ser un número entero positivo (sin decimales).';
        return;
    else
        maxIter = numMaxIter;
    end
end