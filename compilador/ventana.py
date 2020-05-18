from tkinter import *

#--------------------Guarda texto en un Archivo-------------------------------
def writeFile(codigo):
    try:
        f = open ('instructions.txt','w')
        f.write(str(codigo))
    except Exception as e:
        error("Error al guardar codigo compilado en el archivo")
        return 0;

#------------------mostrar mensaje de error---------------------------------
def error(mensaje):
    consola.config(text=mensaje)

#-----------------retorna el equivalente binario de un int------------------
def intToBin(numero):
    bin = "";
    while numero > 1:
        if numero % 2 == 0:
            bin += "0"
        else:
            bin += "1"
        numero = int(numero / 2)
    bin += "1"
    bin = bin[::-1]    
    return bin   



#------------------retorna la posicion del registro-------------------------
def getRegistro(registro, i):
    txtReg = "00000"
    registro = registro.strip()
    registro = registro.lower()
    #si no tiene el sigo $ al inicio
    if registro[0] != "$":
        error("error en linea "+str(i)+", direccion de registro sin '$'")
        return 0
#==================todos los nombres de los registros================
    registros = {
        "$zero": "000000",
        "$at": "000001",
        "$v0": "000010",
        "$v1": "000011"
    }

    #revisar registros
    try:
        txtReg = registros[registro]
    except Exception as e:
        #hacerlo por numero
        try:
            dir = int(registro[1:len(registro)])
            if dir < 32:
                txtReg = intToBin(dir)
                txtReg = txtReg.zfill(5)#rellena los 5 bits si no estan llenos
            else:
                error("error en linea "+str(i)+"direccion de registro excede el rango")
        except Exception as e:
            error("error en linea "+str(i)+"error en sintaxis de direccion de registro, registro no existente")
            return 0
    return txtReg

#---------------------Retorna un valor dependiendo de la operacion-----------
def getCode(linea,i):
    tipo = ""
    codigo = ""
    operacion = (linea.split(" "))
    operandos = []
    #-----------obtener los operandos---------------
    try:
        iOp = linea.find(" ")
        fOp = linea.find("#")
        if fOp == -1:
            fOp = len(linea)
        operandos = linea[iOp:fOp].split(",")
    except Exception as e:
        error(i+"error en sintaxis")
        return 0;

    #//////////////////////caso ADD/////////////////////
    if operacion[0].lower() == "add":
        tipo = "R"
        op = "000000"
        ft = "100000"
        sh = "00000"
    #//////////////////////caso SUB/////////////////////
    elif operacion[0].lower() == "sub":
        tipo = "R"
        op = "000000"
        ft = "100010"
        sh = "00000"
    else:
         error("error en linea "+str(i)+", nombre de opcode no reconocido")
         return 0

    #////////////////Instrucciones tipo R///////////////
    if tipo == "R":
        if len(operandos) != 3:
            error("error en linea "+str(i)+" funcion add necesita 3 argumentos separados por ','")
            return 0
        rd = getRegistro(operandos[0],i)
        rs = getRegistro(operandos[1],i)
        rt = getRegistro(operandos[2],i)
        if rd == 0 or rs == 0 or rt == 0:
            error("error en linea "+str(i)+" operandos invalidos")
            return 0;
        try:
            codigo = op + rs + rt + rd + sh + ft 
        except Exception as e:
            error("error en linea "+str(i)+" no se pudo ejecutar linea")
            return 0

    return codigo


#---------------------metodo que compila es texto-----------------------------
def compilar():
    codigo = ""
    consola.config(text="")
    textoPlano = texto.get("1.0","end")
    #si no se escribio nada en el texto
    if len(textoPlano) == 1:
        error("Campo de texto vacio, nada para compilar")
        return 0;
    else:
        #separar el codigo en lineas
        lineas = textoPlano.split("\n")
        i = 0
        #cada linea
        for linea in lineas:
            i += 1
            if linea:
                if getCode(linea,i) == 0:
                    return 0
                cod = getCode(linea,i)
                codigo += cod[0:7] + "\n" + cod[8:15] + "\n" + cod[16:23] + "\n" + cod[24:31] + "\n"
    error("codigo compilado correctamente")
    writeFile(codigo)


#---------------------Inicializa la ventana y sus elementos---------------------
ventana = Tk()
ventana.title("Compilador")
ventana.resizable(False,False)
ventana.iconbitmap("engrane.ico")

frame = Frame()
frame.pack()
frame.config(width=500,height=600)
frame.config(bg = "#856ff8")

texto = Text(frame)
texto.place(x=10,y=10,width=480,height=350)

btnAceptar = Button(frame,text="Compilar",command=compilar)
btnAceptar.place(x=300,y=375)

consola = Label(frame,text="Todos los errores de compilacion van aqui",anchor="nw")
consola.place(x=10,y=415,width=480,height=150)



ventana.mainloop()

