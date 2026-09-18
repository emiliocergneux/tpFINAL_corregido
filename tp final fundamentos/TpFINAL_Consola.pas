program TpFINAL_Consola;

uses
  Unidad_TpFINAL, Crt;

var
  Archivo: T_Archivo;
  Selecto: Char;
  Orden: Boolean;

begin
  Selecto := '0';
  Orden := False;

  Abrir_o_Crear(Archivo);


  repeat
    ClrScr; 

    writeln('+----------------------------+');
    writeln('|  PANEL DE PROCEDIMIENTOS   |');
    writeln('+----------------------------+');
    writeln('|  [1] = CARGAR DATOS        |');
    writeln('|  [2] = LISTADO             |');
    writeln('|  [3] = BUSQUEDA POR CODIGO |');
    writeln('|  [4] = AVANZAR ESTADO      |');
    writeln('|  [5] = CANCELAR ENVIO      |');
    writeln('|  [6] = SALIR               |');
    writeln('+----------------------------+');
    writeln('| PRESIONE LA TECLA NUMERICA |');
    writeln('|    DEL PROCEDIMIENTO QUE   |');
    writeln('|       DESEA REALIZAR:      |');
    writeln('+----------------------------+');

    Selecto := ReadKey;
    ClrScr; 

    case Selecto of
      '1': begin
              Guardar_Envios(Archivo);
            end;

      '2': begin
             ClrScr;
             Listado(Archivo);
           end;

      '3': begin
           ClrScr;
           Encontrado(Archivo);
           end;

      '4': begin
             ClrScr;
             Avance(Archivo);
           end;

      '5': begin
             ClrScr;
             Cancelar(Archivo);
           end;

      '6': begin
            ClrScr;
            writeln('+-------------------------+');
            writeln('| FINALIZANDO PROGRAMA... |');
            writeln('+-------------------------+');
            writeln();
            writeln('+-----------------------------------+');
            writeln('| PRESIONE UNA TECLA PARA CONTINUAR |');
            writeln('+-----------------------------------+');
            ReadKey;
            ClrScr;
           end;

    else
      ClrScr;
      writeln('+-----------------+');
      writeln('| TECLA INVALIDA! |');
      writeln('+-----------------+');
      writeln();
      writeln('+-----------------------------------+');
      writeln('| PRESIONE UNA TECLA PARA CONTINUAR |');
      writeln('+-----------------------------------+');      
      ReadKey;
    end;

  until (Selecto = '6');

  ClrScr;
  writeln('+---------------------+');
  writeln('| PROGRAMA FINALIZADO |');
  writeln('+---------------------+');
  writeln();
  writeln('+-----------------------------------+');
  writeln('| PRESIONE UNA TECLA PARA CONTINUAR |');
  writeln('+-----------------------------------+');
  ReadKey;
  ClrScr;

end.
