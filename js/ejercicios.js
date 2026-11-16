/* =====================================================================
   Registro de etapas y ejercicios del portafolio.
   Para agregar un ejercicio nuevo:
     1. Crear la carpeta ejercicios/<id>/ con las 7 páginas (mer.html,
        mer-e.html, reduccion.html, relacional.html, normalizacion.html,
        algebra.html, sql.html).
     2. Agregar una entrada en EJERCICIOS.
   ===================================================================== */

var ETAPAS = [
  { id: "mer",           nombre: "MER",                archivo: "mer.html",           icono: "◇", notaciones: true,
    descripcion: "Modelo entidad-relación: entidades, atributos y relaciones del problema." },
  { id: "mer-e",         nombre: "MER-E",              archivo: "mer-e.html",         icono: "◈", notaciones: true,
    descripcion: "Modelo entidad-relación extendido: generalización y especialización." },
  { id: "reduccion",     nombre: "Reducción a tablas", archivo: "reduccion.html",     icono: "▤", notaciones: false,
    descripcion: "Reglas para convertir el MER-E en tablas, paso a paso." },
  { id: "relacional",    nombre: "Modelo relacional",  archivo: "relacional.html",    icono: "⊞", notaciones: false,
    descripcion: "Esquema lógico: tablas, tipos, llaves primarias y foráneas." },
  { id: "normalizacion", nombre: "Normalización",      archivo: "normalizacion.html", icono: "≡", notaciones: false,
    descripcion: "Dependencias funcionales y paso por 1FN, 2FN, 3FN y FNBC." },
  { id: "algebra",       nombre: "Álgebra relacional", archivo: "algebra.html",       icono: "σ", notaciones: false,
    descripcion: "Consultas con σ, π, ⋈, ∪, ∩, −, ÷ y su resultado." },
  { id: "sql",           nombre: "Sentencias SQL",     archivo: "sql.html",           icono: "❯", notaciones: false,
    descripcion: "DDL, DML y consultas, probadas en PostgreSQL." }
];

var EJERCICIOS = [
  { id: "aeropuerto", titulo: "Aeropuerto", icono: "✈", carpeta: "ejercicios/aeropuerto/",
    descripcion: "Pilotos, pasajeros, bases, aviones y vuelos." },
  { id: "universidad", titulo: "Universidad", icono: "🎓", carpeta: "ejercicios/universidad/",
    descripcion: "Profesores, estudiantes, sedes, salones y cursos." },
  { id: "gimnasio", titulo: "Gimnasio", icono: "🏋", carpeta: "ejercicios/gimnasio/",
    descripcion: "Entrenadores, socios, sedes, salas y clases grupales." },
  { id: "terminal", titulo: "Terminal de transporte", icono: "🚌", carpeta: "ejercicios/terminal/",
    descripcion: "Conductores, viajeros, terminales, buses y viajes." },
  { id: "teatro", titulo: "Teatro", icono: "🎭", carpeta: "ejercicios/teatro/",
    descripcion: "Actores, espectadores, teatros, salas y funciones." }
];

var NOTACIONES = [
  { id: "chen",      nombre: "Peter Chen" },
  { id: "crowsfoot", nombre: "Crow's Foot" }
];

/* ---------- utilidades ---------- */

function buscarEtapa(id) {
  for (var i = 0; i < ETAPAS.length; i++) {
    if (ETAPAS[i].id === id) { return i; }
  }
  return 0;
}

function leerParametro(nombre, porDefecto) {
  var params = new URLSearchParams(window.location.search);
  var valor = params.get(nombre);
  if (valor === null || valor === "") { return porDefecto; }
  return valor;
}

function notacionActual() {
  var n = leerParametro("n", "chen");
  if (n !== "chen" && n !== "crowsfoot") { n = "chen"; }
  return n;
}

/* Botones Peter Chen / Crow's Foot. Llama a alCambiar(n) en cada clic. */
function pintarSelectorNotacion(contenedorId, alCambiar) {
  var cont = document.getElementById(contenedorId);
  if (!cont) { return; }
  cont.innerHTML = "";
  var actual = notacionActual();
  for (var i = 0; i < NOTACIONES.length; i++) {
    var b = document.createElement("button");
    b.type = "button";
    b.className = "chip" + (NOTACIONES[i].id === actual ? " activo" : "");
    b.textContent = NOTACIONES[i].nombre;
    b.setAttribute("data-n", NOTACIONES[i].id);
    b.addEventListener("click", cambiarNotacion);
    cont.appendChild(b);
  }

  function cambiarNotacion(e) {
    var n = e.currentTarget.getAttribute("data-n");
    var url = new URL(window.location.href);
    url.searchParams.set("n", n);
    history.replaceState(null, "", url.toString());
    var botones = cont.querySelectorAll(".chip");
    for (var j = 0; j < botones.length; j++) {
      botones[j].classList.toggle("activo", botones[j].getAttribute("data-n") === n);
    }
    if (alCambiar) { alCambiar(n); }
  }
}

/* Muestra solo los bloques .vista que coinciden con la notación */
function mostrarVistas(n) {
  var vistas = document.querySelectorAll(".vista");
  for (var i = 0; i < vistas.length; i++) {
    vistas[i].hidden = vistas[i].getAttribute("data-n") !== n;
  }
}

/* ---------- página de un ejercicio (cadena de etapas) ---------- */

function enlaceEtapa(etapa) {
  var href = etapa.archivo;
  if (etapa.notaciones) { href += "?n=" + notacionActual(); }
  return href;
}

function pintarRuta(etapaId) {
  var idx = buscarEtapa(etapaId);

  var ruta = document.getElementById("ruta");
  if (ruta) {
    ruta.innerHTML = "";
    for (var i = 0; i < ETAPAS.length; i++) {
      var a = document.createElement("a");
      a.className = "ruta-nodo";
      if (i < idx) { a.className += " hecho"; }
      if (i === idx) { a.className += " actual"; }
      a.href = enlaceEtapa(ETAPAS[i]);
      a.innerHTML = '<span class="ruta-punto">' + ETAPAS[i].icono + '</span>' +
                    '<span class="ruta-nombre">' + ETAPAS[i].nombre + '</span>';
      ruta.appendChild(a);
    }
  }

  var nav = document.getElementById("siguiente");
  if (nav) {
    var html = "";
    if (idx > 0) {
      var ant = ETAPAS[idx - 1];
      html += '<a class="btn-etapa anterior" href="' + enlaceEtapa(ant) + '">' +
              '<span class="btn-mini">← Anterior</span><span class="btn-titulo">' + ant.nombre + '</span></a>';
    } else {
      html += '<span></span>';
    }
    if (idx < ETAPAS.length - 1) {
      var sig = ETAPAS[idx + 1];
      html += '<a class="btn-etapa siguiente" href="' + enlaceEtapa(sig) + '">' +
              '<span class="btn-mini">Siguiente →</span><span class="btn-titulo">' + sig.nombre + '</span></a>';
    } else {
      html += '<a class="btn-etapa siguiente" href="../../index.html">' +
              '<span class="btn-mini">Fin del recorrido ✦</span><span class="btn-titulo">Volver al portafolio</span></a>';
    }
    nav.innerHTML = html;
  }
}

/* Página de etapa con notaciones: selector + vistas + ruta */
function iniciarEtapa(etapaId) {
  pintarRuta(etapaId);
  activarVisor();
  if (ETAPAS[buscarEtapa(etapaId)].notaciones) {
    mostrarVistas(notacionActual());
    pintarSelectorNotacion("selector-notacion", alCambiarNotacion);
  }

  function alCambiarNotacion(n) {
    mostrarVistas(n);
    pintarRuta(etapaId);
  }
}

/* ---------- seccion.html?s=<etapa> ---------- */

function iniciarSeccion() {
  var idx = buscarEtapa(leerParametro("s", "mer"));
  var etapa = ETAPAS[idx];

  document.title = etapa.nombre + " — Portafolio de Bases de Datos";
  document.getElementById("sec-titulo").textContent = etapa.nombre;
  document.getElementById("sec-desc").textContent = etapa.descripcion;
  document.getElementById("sec-num").textContent = "Etapa " + (idx + 1) + " de " + ETAPAS.length;

  var bloque = document.getElementById("bloque-notacion");
  if (etapa.notaciones) {
    bloque.hidden = false;
    pintarSelectorNotacion("selector-notacion", pintarLista);
  } else {
    bloque.hidden = true;
  }

  var ruta = document.getElementById("ruta");
  ruta.innerHTML = "";
  for (var i = 0; i < ETAPAS.length; i++) {
    var a = document.createElement("a");
    a.className = "ruta-nodo";
    if (i < idx) { a.className += " hecho"; }
    if (i === idx) { a.className += " actual"; }
    a.href = "seccion.html?s=" + ETAPAS[i].id;
    a.innerHTML = '<span class="ruta-punto">' + ETAPAS[i].icono + '</span>' +
                  '<span class="ruta-nombre">' + ETAPAS[i].nombre + '</span>';
    ruta.appendChild(a);
  }

  pintarLista(notacionActual());

  function pintarLista(n) {
    var lista = document.getElementById("lista-ejercicios");
    lista.innerHTML = "";
    for (var k = 0; k < EJERCICIOS.length; k++) {
      var ej = EJERCICIOS[k];
      var href = ej.carpeta + etapa.archivo;
      if (etapa.notaciones) { href += "?n=" + n; }
      var a = document.createElement("a");
      a.className = "card";
      a.href = href;
      a.innerHTML =
        '<span class="num">' + String(k + 1).padStart(2, "0") + '</span>' +
        '<span class="icon">' + ej.icono + '</span>' +
        '<h3>' + ej.titulo + '</h3>' +
        '<p>' + ej.descripcion + '</p>' +
        '<span class="go">Ver ' + etapa.nombre + (etapa.notaciones ? ' · ' + nombreNotacion(n) : '') +
        ' <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M5 12h14M13 6l6 6-6 6"/></svg></span>';
      lista.appendChild(a);
    }
    activarBrillo();
  }
}

function nombreNotacion(id) {
  for (var i = 0; i < NOTACIONES.length; i++) {
    if (NOTACIONES[i].id === id) { return NOTACIONES[i].nombre; }
  }
  return "";
}

/* ---------- visor emergente de diagramas: zoom y arrastre ---------- */

var visor = null;

function crearVisor() {
  visor = document.createElement("div");
  visor.className = "visor";
  visor.innerHTML =
    '<div class="visor-barra">' +
    '  <button type="button" data-accion="menos" title="Alejar">−</button>' +
    '  <span class="visor-zoom">100%</span>' +
    '  <button type="button" data-accion="mas" title="Acercar">+</button>' +
    '  <button type="button" data-accion="ajustar" title="Ver completo">Ajustar</button>' +
    '  <button type="button" data-accion="cerrar" title="Cerrar (Esc)">✕</button>' +
    '</div>' +
    '<div class="visor-lienzo"><div class="visor-contenido"></div></div>' +
    '<p class="visor-ayuda">Rueda del mouse o botones para el zoom · clic izquierdo y arrastrar para moverse · Esc para cerrar</p>';
  document.body.appendChild(visor);

  visor.estado = { escala: 1, x: 0, y: 0, arrastrando: false, ix: 0, iy: 0, ancho: 0, alto: 0 };
  var lienzo = visor.querySelector(".visor-lienzo");

  var botones = visor.querySelectorAll(".visor-barra button");
  for (var i = 0; i < botones.length; i++) {
    botones[i].addEventListener("click", accionVisor);
  }
  lienzo.addEventListener("wheel", ruedaVisor, { passive: false });
  lienzo.addEventListener("mousedown", empezarArrastre);
  window.addEventListener("mousemove", moverArrastre);
  window.addEventListener("mouseup", terminarArrastre);
  document.addEventListener("keydown", teclaVisor);
}

function abrirVisor(e) {
  if (!visor) { crearVisor(); }
  var svgOriginal = e.currentTarget.querySelector("svg");
  var copia = svgOriginal.cloneNode(true);
  var vb = svgOriginal.viewBox.baseVal;
  copia.setAttribute("width", vb.width);
  copia.setAttribute("height", vb.height);
  copia.style.minWidth = "0";
  var contenido = visor.querySelector(".visor-contenido");
  contenido.innerHTML = "";
  contenido.appendChild(copia);
  visor.estado.ancho = vb.width;
  visor.estado.alto = vb.height;
  visor.classList.add("abierto");
  document.body.style.overflow = "hidden";
  ajustarVisor();
}

function cerrarVisor() {
  visor.classList.remove("abierto");
  document.body.style.overflow = "";
}

function aplicarVisor() {
  var s = visor.estado;
  visor.querySelector(".visor-contenido").style.transform =
    "translate(" + s.x + "px," + s.y + "px) scale(" + s.escala + ")";
  visor.querySelector(".visor-zoom").textContent = Math.round(s.escala * 100) + "%";
}

function ajustarVisor() {
  var s = visor.estado;
  var lienzo = visor.querySelector(".visor-lienzo");
  var w = lienzo.clientWidth;
  var h = lienzo.clientHeight;
  s.escala = Math.min(w / s.ancho, h / s.alto) * 0.96;
  s.x = (w - s.ancho * s.escala) / 2;
  s.y = (h - s.alto * s.escala) / 2;
  aplicarVisor();
}

/* zoom manteniendo fijo el punto (px, py) del lienzo */
function zoomVisor(factor, px, py) {
  var s = visor.estado;
  var nueva = Math.min(8, Math.max(0.1, s.escala * factor));
  var real = nueva / s.escala;
  s.x = px - (px - s.x) * real;
  s.y = py - (py - s.y) * real;
  s.escala = nueva;
  aplicarVisor();
}

function accionVisor(e) {
  var accion = e.currentTarget.getAttribute("data-accion");
  var lienzo = visor.querySelector(".visor-lienzo");
  var cx = lienzo.clientWidth / 2;
  var cy = lienzo.clientHeight / 2;
  if (accion === "mas") { zoomVisor(1.25, cx, cy); }
  if (accion === "menos") { zoomVisor(0.8, cx, cy); }
  if (accion === "ajustar") { ajustarVisor(); }
  if (accion === "cerrar") { cerrarVisor(); }
}

function ruedaVisor(e) {
  e.preventDefault();
  var r = e.currentTarget.getBoundingClientRect();
  var factor = e.deltaY < 0 ? 1.15 : 1 / 1.15;
  zoomVisor(factor, e.clientX - r.left, e.clientY - r.top);
}

function empezarArrastre(e) {
  if (e.button !== 0) { return; }
  var s = visor.estado;
  s.arrastrando = true;
  s.ix = e.clientX - s.x;
  s.iy = e.clientY - s.y;
  visor.classList.add("arrastrando");
  e.preventDefault();
}

function moverArrastre(e) {
  if (!visor || !visor.estado.arrastrando) { return; }
  visor.estado.x = e.clientX - visor.estado.ix;
  visor.estado.y = e.clientY - visor.estado.iy;
  aplicarVisor();
}

function terminarArrastre() {
  if (!visor) { return; }
  visor.estado.arrastrando = false;
  visor.classList.remove("arrastrando");
}

function teclaVisor(e) {
  if (e.key === "Escape" && visor && visor.classList.contains("abierto")) { cerrarVisor(); }
}

function activarVisor() {
  var diagramas = document.querySelectorAll(".diagrama.tablero");
  for (var i = 0; i < diagramas.length; i++) {
    diagramas[i].addEventListener("click", abrirVisor);
    diagramas[i].title = "Clic para ver el diagrama completo";
  }
}
