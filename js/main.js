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

function parsearPersonas(texto) {
  const n = parseInt(texto);
  return isNaN(n) ? 11 : n;
}

function parsearHora(texto) {
  const m = texto.match(/(\d+):(\d+)(am|pm)/i);
  if (!m) return '12:00:00';
  let h = parseInt(m[1]);
  const period = m[3].toLowerCase();
  if (period === 'pm' && h !== 12) h += 12;
  if (period === 'am' && h === 12) h = 0;
  return `${String(h).padStart(2, '0')}:${m[2]}:00`;
}

async function submitReserva() {
  const nombre   = document.getElementById('nombre')?.value.trim();
  const apellido = document.getElementById('apellido')?.value.trim();
  const email    = document.getElementById('email')?.value.trim();
  const telefono = document.getElementById('telefono')?.value.trim();
  const fecha    = document.getElementById('fecha')?.value;
  const personas = document.getElementById('personas')?.value;
  const ocasion  = document.getElementById('ocasion')?.value;
  const notas    = document.getElementById('notas')?.value.trim();
  const horario  = document.querySelector('.horario-btn.selected');

  if (!nombre || !email || !fecha || !personas || !horario) {
    alert('Por favor completa todos los campos y selecciona un horario.');
    return;
  }

  const btn = document.querySelector('.submit-btn');
  btn.textContent = 'Confirmando...';
  btn.disabled = true;

  // 1. Upsert cliente (crea o actualiza por email)
  const { data: cliente, error: errCliente } = await db
    .from('clientes')
    .upsert(
      { nombre, apellido: apellido || '', email, telefono: telefono || '' },
      { onConflict: 'email' }
    )
    .select('id')
    .single();

  if (errCliente) {
    alert('Error al registrar cliente: ' + errCliente.message);
    btn.textContent = 'Confirmar Reserva';
    btn.disabled = false;
    return;
  }

  // 2. Buscar mesa disponible con capacidad suficiente
  const numPersonas = parsearPersonas(personas);
  const { data: mesa, error: errMesa } = await db
    .from('mesas')
    .select('id')
    .gte('capacidad', numPersonas)
    .eq('estado', 'disponible')
    .limit(1)
    .maybeSingle();

  if (errMesa || !mesa) {
    alert('No hay mesas disponibles para esa cantidad de personas. Llámanos al (01) 234-5678.');
    btn.textContent = 'Confirmar Reserva';
    btn.disabled = false;
    return;
  }

  // 3. Insertar reserva
  const notaFinal = [
    ocasion ? `Ocasión: ${ocasion}` : '',
    notas
  ].filter(Boolean).join(' · ');

  const { error: errReserva } = await db
    .from('reservas')
    .insert({
      cliente_id:    cliente.id,
      mesa_id:       mesa.id,
      fecha_reserva: fecha,
      hora_reserva:  parsearHora(horario.textContent.trim()),
      num_personas:  numPersonas,
      notas:         notaFinal || null
    });

  if (errReserva) {
    alert('Error al crear la reserva: ' + errReserva.message);
    btn.textContent = 'Confirmar Reserva';
    btn.disabled = false;
    return;
  }

  document.getElementById('formContainer').style.display = 'none';
  document.getElementById('successMsg').style.display = 'block';
}