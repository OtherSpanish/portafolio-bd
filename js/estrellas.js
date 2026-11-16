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

/* ── Campo de estrellas ── */
(function () {
  var canvas = document.getElementById("stars");
  if (!canvas) { return; }
  var ctx = canvas.getContext("2d");
  var stars = [];
  var w = 0;
  var h = 0;
  var COLORS = ["#ffffff", "#bb9af7", "#c77dff", "#7aa2f7"];

  function resize() {
    w = canvas.width = innerWidth;
    h = canvas.height = innerHeight;
    var count = Math.min(220, Math.floor(w * h / 9000));
    stars = [];
    for (var i = 0; i < count; i++) {
      stars.push({
        x: Math.random() * w,
        y: Math.random() * h,
        r: Math.random() * 1.4 + 0.3,
        c: COLORS[Math.floor(Math.random() * COLORS.length)],
        tw: Math.random() * Math.PI * 2,
        sp: Math.random() * 0.03 + 0.008
      });
    }
  }

  function draw() {
    ctx.clearRect(0, 0, w, h);
    for (var i = 0; i < stars.length; i++) {
      var s = stars[i];
      s.tw += s.sp;
      var a = 0.35 + Math.abs(Math.sin(s.tw)) * 0.6;
      ctx.globalAlpha = a;
      ctx.fillStyle = s.c;
      ctx.beginPath();
      ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
      ctx.fill();
      if (s.r > 1.1) {
        ctx.globalAlpha = a * 0.4;
        ctx.beginPath();
        ctx.arc(s.x, s.y, s.r * 2.5, 0, Math.PI * 2);
        ctx.fill();
      }
    }
    ctx.globalAlpha = 1;
    requestAnimationFrame(draw);
  }

  addEventListener("resize", resize);
  if (!matchMedia("(prefers-reduced-motion:reduce)").matches) {
    resize();
    draw();
  }
})();
