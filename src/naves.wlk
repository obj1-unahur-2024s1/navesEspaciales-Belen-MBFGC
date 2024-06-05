class NaveEspacial {
	var velocidad = 0 	/** ninguna nave puede ser mayor a 100000
	 kms/seg, ni tampoco puede ser negativa */
	var direccion = 0
	var combustible = 0
	
	method acelerar(cuanto){
		 velocidad = 100000.min(velocidad+cuanto)
	}
	
	method desacelerar(cuanto){
		velocidad = 0.max(velocidad - cuanto)
	}
	
	method irHaciaElSol(){direccion = 10}
	method escparDelSol(){direccion = -10}
	method ponerseParaleloAlSol(){direccion = 0}
	method acercarseUnPocoAlSol(){direccion = 10.min(direccion + 1 )}
	method alejarseUnPocoDelSol(){direccion = -10.max(direccion - 1 )}
	method metodoAbtracto() // Para no poder instanciar esta clase
	method cargarCombustible(cuanto){combustible += cuanto}
	method descargarCombustible(cuanto){combustible = 0.max{combustible += cuanto}}
	method prepararViaje(){
		self.descargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method estaTranquila(){
		return combustible >= 4000 and velocidad <=12000 and self.adicionalTranquilidad()
	}
	
	method adicionalTranquilidad() //Método abstracto 
	
	method recibirAmenaza(){
		self.escapar()
		self.avisar()
	}
	
	method escapar()
	method avisar()
	
	method estaDeRelajo(){
		return self.estaTranquila() and self.tienePocaActividad()}
	method tienePocaActividad()
	
	}


class NaveBaliza inherits NaveEspacial{
	var colorBaliza
	var cambioDeColor= false
	
	method cambiarColorDeBaliza(colorNuevo){
		colorBaliza = colorNuevo
		cambioDeColor= true
	}
	
	override method prepararViaje(){
		super() //para que haga lo de la superclase
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	override method adicionalTranquilidad() = colorBaliza != "rojo"
	
	override method escapar(){self.irHaciaElSol()} 
	override method avisar(){self.cambiarColorDeBaliza("rojo")}
	
	override method tienePocaActividad()= not cambioDeColor
}

class NaveDePasajeros inherits NaveEspacial{
	const cantidadDePasajeros
	var racionesComida = 0 
	var racionesBebida = 0 
	var racionesDeComidaServidas = 0
	
	method cargarComida(cuanto){racionesComida+= cuanto}
	
	method cargarBebida(cuanto){racionesBebida+= cuanto}
	
	method decargarComida(cuanto){
		racionesComida=0.max(racionesComida - cuanto )
		racionesDeComidaServidas += cuanto 
	}
	
	method decargarBebida(cuanto){racionesBebida=0.max(racionesBebida - cuanto ) }	

	override method prepararViaje(){
		super()
		self.cargarComida(4 * cantidadDePasajeros)
		self.cargarBebida(6 * cantidadDePasajeros)
		self.acercarseUnPocoAlSol()
		
	}
	
	override method adicionalTranquilidad() = true 
	override method escapar(){self.acelerar(velocidad)} 
	override method avisar(){
		self.decargarComida(cantidadDePasajeros)
		self.decargarBebida( 2* cantidadDePasajeros)
		
	}
	override method tienePocaActividad()= racionesDeComidaServidas < 50
	
}

class NaveDeCombate inherits NaveEspacial{
	var estaVisible = true
	var misilesDesplegados = false 
	const mensajes = []
	
	method ponerseVisible(){estaVisible = true}
	method ponerseInvisible(){estaVisible = false}
	method estaInvisible()= not estaVisible 
	
	method desplegarMisiles(){misilesDesplegados = true}
	method replegarMisiles(){misilesDesplegados = false}
	method misilesDesplegados()= misilesDesplegados 
	
	method emitirMensaje(mensaje){mensajes.add(mensaje)}
	method mensajesEmitidos() = mensajes
	method primerMensajeEmitido() = mensajes.first()
	method ultimoMensajeEmitido() = mensajes.last()
	method esEscueta() = not mensajes.any({m => m.length() >30}) // mensajes.all({m => m.length() <=30}) 
	method emitioMensaje(mensaje) = mensajes.contains(mensaje)
	
	override method prepararViaje(){
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	override method adicionalTranquilidad() = not self.misilesDesplegados()
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	override method tienePocaActividad()= self.esEscueta()
}
	

class NaveHopital inherits NaveDePasajeros {
	var  quirofanosPreparados = false
	
	method prepararQuirofanos(){quirofanosPreparados= true}
	method noPrepararQuirofanos(){quirofanosPreparados= false}	
	override method adicionalTranquilidad()= not quirofanosPreparados
	override method recibirAmenaza(){
		super()
		self.prepararQuirofanos()
	}
}

class NaveSigilosa inherits NaveDeCombate {
	override method adicionalTranquilidad(){
		return super() and not self.estaInvisible()
	}
	
	override method escapar(){
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}

}


	
	
