/**
 * Esta función permite buscar un valor e una hoja especifica
 */
function BUSCAR(dato_a_buscar, nombre_hoja, columna_de_referencia, columna_de_resultado){
  const SS = SpreadsheetApp.getActiveSpreadsheet();
  const hoja = SS.getSheetByName(nombre_hoja);
  const registros = hoja.getDataRange().getDisplayValues();
  var resultado;

  registros.forEach( registro =>{
    if( registro[columna_de_referencia-1] === dato_a_buscar ){
      resultado = registro[columna_de_resultado-1];
    }
  })
  return resultado;
}