// ============================================================
//  CONFIGURACIÓN SUPABASE — Sabor Andino
//  Supabase → Project Settings → API
//    · Project URL  → reemplaza SUPABASE_URL
//    · anon public  → reemplaza SUPABASE_KEY
// ============================================================
const SUPABASE_URL = 'https://zmznzwqsvictbkoyptyx.supabase.co'
const SUPABASE_KEY = 'sb_publishable_j9hLVDoKlK2sw4Q_98IX7Q__-UG9G40'

const { createClient } = supabase
const db = createClient(SUPABASE_URL, SUPABASE_KEY)
