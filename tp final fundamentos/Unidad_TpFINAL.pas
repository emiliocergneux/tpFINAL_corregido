Unit Unidad_TpFINAL;

Interface

uses Crt, SysUtils;

Type Cliente = record
    Codigo_Envio: string [15];
    Dni_Destinatario: string [10];
    Nombre_Destinatario: string [60];
    Ciudad_Destino: string [30];
    Estado_Envio: string[30];
    Peso_Paquete: real;
    Costo_Envio: real;
    end; 

T_Archivo = file of Cliente; 

Procedure Abrir_o_Crear (Var Arch:T_Archivo);

Procedure Cargar_Registro (Var r: Cliente; var Arch: T_Archivo);

Procedure Guardar_Envios (Var Arch: T_Archivo);

Procedure Mostrar_Registro (r: Cliente);

Procedure Listado (Var Arch: T_Archivo);

Procedure Burbuja (Var Arch: T_Archivo);

Procedure Busqueda (Var Arch: T_Archivo; Buscado: string; Var Pos: longint);

Procedure Encontrado (Var Arch: T_Archivo);

Procedure Avanzar_Estado (Var Arch: T_Archivo; Cod: string; Var Enc: boolean; var Pos: integer);
Procedure Avance (Var Arch: T_Archivo);

Procedure Cancelar_Envio (Var Arch: T_Archivo; Cod: string; Var Enc: boolean; var Pos: integer);
Procedure Cancelar(Var Arch: T_Archivo);


Implementation 

Procedure Abrir_o_Crear (Var Arch: T_Archivo);   //crear
var
    ruta: string;
begin
    ruta := 'ARCHIVO_CLIENTES.DAT';
    assign(Arch, ruta);

    if FileExists(ruta) then
    begin
         reset(Arch);
         close(Arch);
    end
    else
    begin
         rewrite(Arch);
         close(Arch);
    end;
end;


Procedure Cargar_Registro (Var r: Cliente; var Arch: T_Archivo);   //cargar

var Aux: Cliente;
var Repetido: boolean;

begin
     with r do 
     begin
          repeat
               Repetido := false;
               writeln('+-----------------------------+');
               writeln('|  DATOS A CARGAR DEL ENVIO   |');
               writeln('| INGRESE EL CODIGO DE ENVIO: |');
               writeln('+-----------------------------+');
               readln(Codigo_Envio);
               ClrScr;
               seek(Arch, 0);
               while not EOF(Arch) and (Repetido = false) do
               begin
                    read(Arch, Aux);
                    if (Aux.Codigo_Envio) = (Codigo_Envio) then
                    begin
                         Repetido := true;
                         writeln('+--------------------------------+');
                         writeln('| ESE CODIGO YA ESTA REGISTRADO! |');
                         writeln('+--------------------------------+');
                         writeln();
                         writeln('+-----------------------------------+');
                         writeln('| PRESIONE UNA TECLA PARA CONTINUAR |');
                         writeln('+-----------------------------------+');
                         readkey;
                         ClrScr;
                    end;
               end;
          until (Repetido = false);

          writeln('+---------------------------------------------+');
          writeln('| INGRESE APELLIDO Y NOMBRE DEL DESTINATARIO: |');
          writeln('+---------------------------------------------+');
          readln(Nombre_Destinatario);
          Nombre_Destinatario := UpCase(Nombre_Destinatario);
          ClrScr;
          writeln('+-------------------------------+');
          writeln('| INGRESE DNI DEL DESTINATARIO: |');
          writeln('+-------------------------------+');
          readln(Dni_Destinatario);
          Dni_Destinatario := UpCase(Dni_Destinatario);
          ClrScr;
          writeln('+----------------------------+');
          writeln('| INGRESE CIUDAD DE DESTINO: |');
          writeln('+----------------------------+');
          readln(Ciudad_Destino);
          Ciudad_Destino := UpCase(Ciudad_Destino);
          ClrScr;
          Estado_Envio := 'EN PREPARACION';
          writeln('+--------------------------------+');
          writeln('| INGRESE PESO DEL PAQUETE (KG): |');
          writeln('+--------------------------------+');
          readln(Peso_Paquete);
          ClrScr;
          while (Peso_Paquete < 1) do
          begin
               writeln('+-------------------------------------------+');
               writeln('| INGRESE PESO DEL PAQUETE NUEVAMENTE (KG): |');
               writeln('+-------------------------------------------+');
               readln(Peso_Paquete);
               ClrScr;
          end;
          writeln('+--------------------------+');
          writeln('| INGRESE COSTO DEL ENVIO: |');
          writeln('+--------------------------+');
          readln(Costo_Envio);
          ClrScr;
          while (Costo_Envio < 1) do
          begin
               writeln('+---------------------------------------+');
               writeln('| INGRESE EL COSTO DE ENVIO NUEVAMENTE: |');
               writeln('+---------------------------------------+');
               readln(Costo_Envio);
               ClrScr;
          end;
     end;
end;

Procedure Guardar_Envios (Var Arch: T_Archivo);   //guardar
var
R: Cliente;
Resp: char;

begin
     reset(Arch);
     seek(Arch, filesize(Arch));
     repeat
           Cargar_Registro(R, Arch);
           write(Arch, R);
           writeln('+-----------------------------------+');
           writeln('| DESEA INGRESAR OTRO ENVIO? (S/N): |');
           writeln('+-----------------------------------+');
           readln(Resp);
           ClrScr;
     until (UpCase(Resp) <> 'S');
     close(Arch);
end;

Procedure Burbuja (Var Arch: T_Archivo);  //burbuja
var
lim, i, j: integer;
R1, R2: Cliente;
Cod1, Cod2: integer;
begin
     reset(Arch);
     lim := filesize(Arch)-1;

     For i:=0 to lim-1 do
     begin
          For j:=0 to lim-i-1 do
          begin
               seek(Arch, j);
               read(Arch, R1);
               seek(Arch, j+1);
               read(Arch, R2);


               Cod1 := StrToIntDef(R1.Codigo_Envio, 0);
               Cod2 := StrToIntDef(R2.Codigo_Envio, 0);

               
               if Cod1 > Cod2 then
               begin
                    seek(Arch, j+1);
                    write(Arch, R1);
                    seek(Arch, j);
                    write(Arch, R2);
               end
               else
               begin
                    if R1.Codigo_Envio = R2.Codigo_Envio then
                    begin
                         if R1.Nombre_Destinatario > R2.Nombre_Destinatario then
                         begin
                              seek(Arch, j+1);
                              write(Arch, R1);
                              seek(Arch, j);
                              write(Arch, R2);
                         end;
                    end;
               end;
          end;
     end;
     close(Arch);
end;

Procedure Mostrar_Registro (r: Cliente);  //mostrar
begin
     writeln('+--------------------------------------------------------------------------------+');
     writeln('|                                     ENVIO:                                     |');
     writeln('+--------------------------------------------------------------------------------+');
     writeln('  CODIGO DE ENVIO: ', r.Codigo_Envio);
     writeln('  NOMBRE DEL DESTINATARIO: ', r.Nombre_Destinatario);
     writeln('  DNI DEL DESTINATARIO: ', r.Dni_Destinatario);
     writeln('  CIUDAD DE DESTINO: ', r.Ciudad_Destino);
     writeln('  ESTADO DEL ENVIO: ', r.Estado_Envio);
     writeln('  PESO DEL PAQUETE (KG): ', r.Peso_Paquete:0:2);
     writeln('  COSTO DEL ENVIO: ', r.Costo_Envio:0:2);
     writeln('+--------------------------------------------------------------------------------+');
     writeln();
     writeln('+-----------------------------------+');
     writeln('| PRESIONE UNA TECLA PARA CONTINUAR |');
     writeln('+-----------------------------------+');
     readkey();
     ClrScr;
end;

Procedure Busqueda (Var Arch: T_Archivo; Buscado: string; Var Pos: longint); //busqueda
var
   pri, med, ult: longint;
   R1: Cliente;
   NumBuscado, NumReg: integer;
begin
     pri := 0;
     ult := filesize(Arch) - 1;
     Pos := -1;
     NumBuscado := StrToIntDef(Buscado, -1);

     while (Pos = -1) and (pri <= ult) do
     begin
          med := (pri + ult) div 2;
          seek(Arch, med);
          read(Arch, R1);
          
          NumReg := StrToIntDef(R1.Codigo_Envio, 0);

          if (NumReg = NumBuscado) then
               Pos := med
          else if (NumReg > NumBuscado) then
               ult := med - 1
          else
               pri := med + 1;
     end;
end;

Procedure Encontrado (Var Arch: T_Archivo);   //encontrado
var
   Resp: string;
   Posicion: longint;
   R: Cliente;
begin
     Burbuja(Arch);
     reset(Arch);
     writeln('+-------------------------------------+');
     writeln('| INGRESE EL CODIGO QUE DESEA BUSCAR: |');
     writeln('+-------------------------------------+');
     readln(Resp);
     ClrScr;

     Busqueda (Arch, Resp, Posicion);

     if (Posicion <> -1) then
     begin
          seek(Arch, Posicion);
          read(Arch, R);
          Mostrar_Registro (R); // Ya no dará error
     end
     else
     begin
          writeln('+----------------------+');
          writeln('| CODIGO NO ENCONTRADO |');
          writeln('+----------------------+');
          readkey();
     end;
     close(Arch);
     ClrScr;
end;

Procedure Listado (Var Arch: T_Archivo);  //listar
var 
   R: Cliente;
   Contador: integer;
begin
     Burbuja(Arch);
     reset(Arch);
     ClrScr;

     if FileSize(Arch) = 0 then
     begin
          writeln('+----------------------------------+');
          writeln('| NO HAY ENVIOS REGISTRADOS AUN    |');
          writeln('+----------------------------------+');
     end
     else
     begin
          writeln('================================================================================');
          writeln('CODIGO          DESTINATARIO                   CIUDAD          ESTADO          ');
          writeln('================================================================================');

          Contador := 0;
          while not EOF(Arch) do
          begin
               read(Arch, R);
               writeln(R.Codigo_Envio:15, ' ', Copy(R.Nombre_Destinatario, 1, 28):30, ' ', Copy(R.Ciudad_Destino, 1, 14):15, ' ', R.Estado_Envio:15);
               Inc(Contador);

               if (Contador mod 10 = 0) and not EOF(Arch) then
               begin
                    writeln('--------------------------------------------------------------------------------');
                    writeln('Presione una tecla para ver mas envios...');
                    readkey;
                    ClrScr;
                    writeln('================================================================================');
                    writeln('CODIGO          DESTINATARIO                   CIUDAD          ESTADO          ');
                    writeln('================================================================================');
               end;
          end;
          writeln('================================================================================');
     end;

     close(Arch);
     writeln();
     writeln('+-----------------------------------+');
     writeln('| PRESIONE UNA TECLA PARA CONTINUAR |');
     writeln('+-----------------------------------+');
     readkey();
     ClrScr;
end;


Procedure Avanzar_Estado (Var Arch: T_Archivo; Cod: string; Var Enc: boolean; var Pos: integer);   //avanzar
var
R: Cliente;
Cont: integer;
Hallado: boolean;

begin
     Cont := 0;
     Hallado := false;
     Enc := false;

     repeat 
     begin
          seek(Arch, Cont);
          read(Arch, R);
          if (Cod <> R.Codigo_Envio) then
          begin
               Inc(Cont);
          end;

          if (Cod = R.Codigo_Envio) then
          begin
               Hallado := true;
               Pos := Cont;
          end;         
     end;
     until (Cont >= filesize(Arch)) or (Hallado = true);

     if (Hallado = true) then
     begin
          if (R.Estado_Envio = 'EN PREPARACION') then
          begin
               R.Estado_Envio := 'EN CAMINO';
               seek(Arch, Cont);
               write(Arch, R);
               Enc := true;
          end
          else
          begin
               if (R.Estado_Envio = 'EN CAMINO') then
               begin
                    R.Estado_Envio := 'EN DESTINO';
                    seek(Arch, Cont);
                    write(Arch, R);
                    Enc := true;
               end
               else
               begin
                    Enc := false;
               end;
          end;
     end;
     
     if (Hallado = false) then
     begin
          Enc := false;
     end;
end;


Procedure Avance (Var Arch: T_Archivo);
var
Codigo: string;
Encontrado: boolean;
Posicion: integer;

begin
     reset(Arch);
     Encontrado := false;
     Posicion := -1;

     if (FileSize(Arch) = 0) then
     begin
          writeln('+------------------------+');
          writeln('| DEBES INGRESAR ENVIOS! |');
          writeln('+------------------------+');
          writeln();
          writeln('+-----------------------------------+');
          writeln('| PRESIONE UNA TECLA PARA CONTINUAR |');
          writeln('+-----------------------------------+');
          readkey();
          ClrScr;
     end
     else
     begin
          writeln('+-----------------------------------------------+');
          writeln('| CUAL ENVIO DESEAS AVANZAR?: (CODIGO DE ENVIO) |');
          writeln('+-----------------------------------------------+');
          readln(Codigo);          
          ClrScr;

          Avanzar_Estado (Arch, Codigo, Encontrado, Posicion);

          if (Encontrado = false) and (Posicion = -1) then
          begin
               writeln('+-------------------------+');
               writeln('| EL ENVIO NO SE ENCONTRO |');
               writeln('+-------------------------+');
          end;

          if (Encontrado = false) and (Posicion <> -1) then
          begin
               writeln('+-------------------------------------------------------+');
               writeln('| EL ENVIO YA SE ENCUENTRA EN DESTINO O SE HA CANCELADO |');
               writeln('+-------------------------------------------------------+');
          end;

          if (Encontrado = true) and (Posicion <> -1) then
          begin
               writeln('+-------------------------------+');
               writeln('| EL ESTADO DEL ENVIO SE AVANZO |');
               writeln('+-------------------------------+');
          end;
          close(Arch);
          writeln();
          writeln('+-----------------------------------+');
          writeln('| PRESIONE UNA TECLA PARA CONTINUAR |');
          writeln('+-----------------------------------+');
          readkey();
          ClrScr; 
     end;
end;

Procedure Cancelar_Envio (Var Arch: T_Archivo; Cod: string; Var Enc: boolean; var Pos: integer);
var
R: Cliente;
Cont: integer;
Hallado: boolean;

begin
     Cont := 0;
     Hallado := false;
     Enc := false;

     repeat          
          seek(Arch, Cont);
          read(Arch, R);
          if (Cod <> R.Codigo_Envio) then
          begin
               Inc(Cont);
          end;

          if (Cod = R.Codigo_Envio) then
          begin
               Hallado := true;
               Pos := Cont;
          end;         
     until (Cont >= filesize(Arch)) or (Hallado = true);

     if (Hallado = true) then
     begin
          if (R.Estado_Envio = 'EN PREPARACION') then
          begin
               R.Estado_Envio := 'ENVIO CANCELADO';
               seek(Arch, Cont);
               write(Arch, R);
               Enc := true;
          end
          else
          begin
               Enc := false;
          end;
     end;
     
     if (Hallado = false) then
     begin
          Enc := false;
     end;
end;

Procedure Cancelar (Var Arch: T_Archivo);
var
Codigo: string;
Encontrado: boolean;
Posicion: integer;

begin
     reset(Arch);
     Encontrado := false;
     Posicion := -1;

     if (FileSize(Arch) = 0) then
     begin
          writeln('+------------------------+');
          writeln('| DEBES INGRESAR ENVIOS! |');
          writeln('+------------------------+');
          writeln();
          writeln('+-----------------------------------+');
          writeln('| PRESIONE UNA TECLA PARA CONTINUAR |');
          writeln('+-----------------------------------+');
          readkey();
          ClrScr;
     end
     else
     begin
          writeln('+-----------------------------------------------+');
          writeln('| QUE ENVIO DESEAS CANCELAR?: (CODIGO DE ENVIO) |');
          writeln('+-----------------------------------------------+');
          readln(Codigo);          
          ClrScr;    

          Cancelar_Envio (Arch, Codigo, Encontrado, Posicion);

          if (Encontrado = false) and (Posicion = -1) then
          begin
               writeln('+-------------------------+');
               writeln('| EL ENVIO NO SE ENCONTRO |');
               writeln('+-------------------------+');
          end;

          if (Encontrado = false) and (Posicion <> -1) then
          begin
               writeln('+-----------------------------------------+');
               writeln('|   EL ENVIO NO SE PUDO CANCELAR PORQUE   |'); 
               writeln('|     NO SE ENCUENTRA EN PREPARACION      |');
               writeln('+-----------------------------------------+');
          end;

          if (Encontrado = true) and (Posicion <> -1) then
          begin
               writeln('+---------------------+');
               writeln('| EL ENVIO SE CANCELO |');
               writeln('+---------------------+');
          end;
          close(Arch);
          writeln();
          writeln('+-----------------------------------+');
          writeln('| PRESIONE UNA TECLA PARA CONTINUAR |');
          writeln('+-----------------------------------+');
          readkey();
          ClrScr;
     end;
end;


end.
