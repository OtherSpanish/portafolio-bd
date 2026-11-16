/* Brillo que sigue al cursor sobre las tarjetas */
function activarBrillo() {
  var cards = document.querySelectorAll(".card");
  for (var i = 0; i < cards.length; i++) {
    cards[i].addEventListener("mousemove", moverBrillo);
  }
}

function moverBrillo(e) {
  var card = e.currentTarget;
  var r = card.getBoundingClientRect();
  card.style.setProperty("--mx", (e.clientX - r.left) + "px");
  card.style.setProperty("--my", (e.clientY - r.top) + "px");
}

activarBrillo();

/* ── Campo de estrellas en 3D ──
   Cada estrella tiene una profundidad z. Se proyecta con perspectiva:
   las cercanas se ven más grandes, brillantes y se mueven más (paralaje). */
(function () {
  var canvas = document.getElementById("stars");
  if (!canvas) { return; }
  var ctx = canvas.getContext("2d");
  var stars = [];
  var w = 0, h = 0, cx = 0, cy = 0;
  var FOCO = 260;          // distancia focal de la "cámara"
  var PROF = 1600;         // profundidad máxima del espacio
  var VEL = 0.35;          // avance hacia la cámara
  var COLORS = ["#ffffff", "#bb9af7", "#c77dff", "#7aa2f7"];
  var mx = 0, my = 0, px = 0, py = 0;
  var quieto = matchMedia("(prefers-reduced-motion:reduce)").matches;

  function nueva(lejos) {
    return {
      x: (Math.random() - 0.5) * w * 3,
      y: (Math.random() - 0.5) * h * 3,
      z: lejos ? PROF : Math.random() * PROF + 1,
      c: COLORS[Math.floor(Math.random() * COLORS.length)],
      tw: Math.random() * Math.PI * 2,
      sp: Math.random() * 0.03 + 0.008
    };
  }

  function resize() {
    w = canvas.width = innerWidth;
    h = canvas.height = innerHeight;
    cx = w / 2;
    cy = h / 2;
    var count = Math.min(520, Math.floor(w * h / 3800));
    stars = [];
    for (var i = 0; i < count; i++) { stars.push(nueva(false)); }
  }

  function draw() {
    ctx.clearRect(0, 0, w, h);
    px += (mx - px) * 0.05;          // suavizado del paralaje
    py += (my - py) * 0.05;
    for (var i = 0; i < stars.length; i++) {
      var s = stars[i];
      if (!quieto) { s.z -= VEL; }
      if (s.z < 1) { stars[i] = s = nueva(true); }
      var k = FOCO / s.z;                       // factor de perspectiva
      var sx = cx + (s.x - px * (PROF - s.z) * 0.15) * k;
      var sy = cy + (s.y - py * (PROF - s.z) * 0.15) * k;
      if (sx < -20 || sx > w + 20 || sy < -20 || sy > h + 20) { continue; }
      var cerca = 1 - s.z / PROF;               // 0 lejos … 1 cerca
      var r = 0.25 + cerca * cerca * 2.4;
      s.tw += s.sp;
      var a = (0.15 + cerca * 0.85) * (0.6 + Math.abs(Math.sin(s.tw)) * 0.4);
      ctx.globalAlpha = a;
      ctx.fillStyle = s.c;
      ctx.beginPath();
      ctx.arc(sx, sy, r, 0, Math.PI * 2);
      ctx.fill();
      if (r > 1.3) {                            // halo en las cercanas
        ctx.globalAlpha = a * 0.25;
        ctx.beginPath();
        ctx.arc(sx, sy, r * 3, 0, Math.PI * 2);
        ctx.fill();
      }
    }
    ctx.globalAlpha = 1;
    requestAnimationFrame(draw);
  }

  addEventListener("resize", resize);
  addEventListener("mousemove", function (e) {
    mx = (e.clientX - cx) / cx;
    my = (e.clientY - cy) / cy;
  });
  resize();
  draw();
})();
