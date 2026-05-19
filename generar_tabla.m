function generar_tabla(tabla, resultados)
    if isempty(resultados)
        tabla.Data = {};
        return;
    end
    n = size(resultados, 1);
    datos = cell(n, 5);
    for i = 1:n
        datos{i,1} = sprintf('%.8f', resultados(i,1));
        datos{i,2} = sprintf('%.8f', resultados(i,2));
        datos{i,3} = sprintf('%.8f', resultados(i,3));
        datos{i,4} = sprintf('%.8f', resultados(i,4));
        datos{i,5} = sprintf('%.8f', resultados(i,5));
    end
    tabla.Data = datos;
end