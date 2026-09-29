# Ragebaiters Gaming

Statische Website mit öffentlicher Spieleübersicht, anonymer Fehler-Meldung und einer geschützten Verwaltungsseite unter `#/admin`.

## Supabase einrichten

1. Lege ein Supabase-Projekt an und führe den vollständigen Inhalt von [`supabase/schema.sql`](supabase/schema.sql) im **SQL Editor** aus.
2. Lege unter **Authentication → Users** die Team-Nutzer an. Diese Nutzer dürfen anschließend die Verwaltung verwenden.
3. Trage die Projekt-URL und den **anon/public key** in den beiden Konstanten am Anfang von [`assets/app.js`](assets/app.js) ein. Den `service_role`-Key niemals in eine Website eintragen.
4. Deploye die Dateien wie bisher. Die Seite braucht keinen Server; sie nutzt Supabases REST-API und Auth direkt.

## Verwendung

- `#/` zeigt ausschließlich in der Verwaltung als aktiv markierte Spiele.
- `#/report` erlaubt Besucher:innen eine Fehler-Meldung ohne Login.
- `#/admin` bietet Login, Anlegen/Bearbeiten/Veröffentlichen von Spielen und Bearbeiten von Bug-Status bzw. internen Notizen.

Die mitgelieferten RLS-Policies erlauben allen angemeldeten Supabase-Auth-Nutzern Verwaltungszugriff. Für getrennte Rollen sollte die im SQL kommentierte Profile-/Admin-Prüfung ergänzt werden.
