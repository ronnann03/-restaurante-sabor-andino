/* ========== HAMBURGUESA ========== */
const hamburger  = document.getElementById('hamburger');
const mobileMenu = document.getElementById('mobileMenu');

if (hamburger && mobileMenu) {
  hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('open');
    mobileMenu.classList.toggle('open');
  });

  mobileMenu.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', () => {
      hamburger.classList.remove('open');
      mobileMenu.classList.remove('open');
    });
  });
}

/* ========== SCROLL REVEAL ========== */
const observer = new IntersectionObserver(entries => {
  entries.forEach(e => {
    if (e.isIntersecting) e.target.classList.add('visible');
  });
}, { threshold: 0.1 });

document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

/* ========== NAV SHRINK EN SCROLL ========== */
const navbar = document.getElementById('navbar');
if (navbar) {
  window.addEventListener('scroll', () => {
    navbar.style.padding = window.scrollY > 40 ? '.7rem 4rem' : '1.1rem 4rem';
  });
}

/* ========== FILTRO MENÚ (index.html) ========== */
function filterMenu(cat, btn) {
  document.querySelectorAll('.menu-tab').forEach(t => t.classList.remove('active'));
  btn.classList.add('active');
  document.querySelectorAll('.menu-card').forEach(card => {
    card.style.display = (cat === 'todo' || card.dataset.cat === cat) ? 'block' : 'none';
  });
}

/* ========== CATEGORÍAS CARTA (menu.html) ========== */
function showCat(id, btn) {
  document.querySelectorAll('.menu-cat-section').forEach(s => s.classList.remove('active'));
  document.querySelectorAll('.cat-btn').forEach(b => b.classList.remove('active'));
  document.getElementById(id).classList.add('active');
  btn.classList.add('active');
}

/* ========== RESERVAS (reservas.html) ========== */
const fechaInput = document.getElementById('fecha');
if (fechaInput) {
  fechaInput.min = new Date().toISOString().split('T')[0];
}

function selHorario(btn) {
  if (btn.classList.contains('disabled')) return;
  document.querySelectorAll('.horario-btn').forEach(b => b.classList.remove('selected'));
  btn.classList.add('selected');
}

function submitReserva() {
  const nombre   = document.getElementById('nombre')?.value.trim();
  const email    = document.getElementById('email')?.value.trim();
  const fecha    = document.getElementById('fecha')?.value;
  const personas = document.getElementById('personas')?.value;
  const horario  = document.querySelector('.horario-btn.selected');

  if (!nombre || !email || !fecha || !personas || !horario) {
    alert('Por favor completa todos los campos y selecciona un horario.');
    return;
  }

  document.getElementById('formContainer').style.display = 'none';
  document.getElementById('successMsg').style.display = 'block';
}