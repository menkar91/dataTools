/**
 * Esta función recibe varios campos y los concatena a partir del primer parametro
 * 
 * @param {String} separador Caracter que separará cada uno de los campos
 * @param {String} datos
 * @return {String} output Cadena concatenada
 * @customfunction
 */
function CONCAT_WS(separador,datos){
  var output = [];
  var registro;
  datos.forEach(fila=>{
    registro = ""
    fila.forEach(columna=>{
      if(columna){ registro += separador + columna }
    });
    if(registro){ registro = registro.substring( separador.length , registro.length) }
    output.push(registro)
  });
  return output;
}
