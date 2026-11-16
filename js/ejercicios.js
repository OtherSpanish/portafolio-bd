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
  { id: "aeropuerto", titulo: "Aeropuerto", carpeta: "ejercicios/aeropuerto/",
    descripcion: "Pilotos, pasajeros, bases, aviones y vuelos." }
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
        '<span class="icon">✈</span>' +
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
