/* Beast PinBall — deployment config.
 * Leave supabaseUrl empty to keep high scores in this browser only (localStorage).
 * To turn on GLOBAL high scores, create the free Supabase project described in
 * backend/README.md and paste the two public values below. The publishable key is
 * designed to be public; Row Level Security in backend/supabase.sql limits it to
 * reading scores and inserting new ones. */
window.BEAST_CONFIG = {
  supabaseUrl: '',          // e.g. 'https://abcdefghijkl.supabase.co'
  supabasePublishableKey: '', // e.g. 'sb_publishable_xxxxxxxx'
  table: 'scores',
  dailyTable: '',           // optional: 'daily_scores' (see backend/supabase.sql) for a global Today's Challenge board
};
