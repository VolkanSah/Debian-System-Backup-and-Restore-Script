#!/bin/bash

# Konfiguration
BACKUP_DIR="/backup/$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$BACKUP_DIR/backup.log"
EXCLUDE_FILE="/tmp/backup_exclude.txt"

# Funktion zum Loggen
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Backup-Funktion
backup() {
    mkdir -p "$BACKUP_DIR"
    log "Backup gestartet in $BACKUP_DIR"

    # Liste der installierten Pakete speichern
    dpkg --get-selections > "$BACKUP_DIR/installed_packages.list"
    log "Paketliste gespeichert in $BACKUP_DIR/installed_packages.list"

    # Konfigurationsdateien sichern
    tar czf "$BACKUP_DIR/etc_backup.tar.gz" /etc
    log "Konfigurationsdateien gesichert in $BACKUP_DIR/etc_backup.tar.gz"

    # Ausschlussliste erstellen
    cat << EOF > "$EXCLUDE_FILE"
/proc/*
/sys/*
/dev/*
/tmp/*
/run/*
/mnt/*
/media/*
/lost+found
/backup/*
EOF

    # Gesamtes Dateisystem sichern (optional)
    if [ "$FULL_BACKUP" = true ]; then
        log "Starte vollständiges Backup..."
        tar czf "$BACKUP_DIR/full_backup.tar.gz" --exclude-from="$EXCLUDE_FILE" /
        log "Vollständiges Backup abgeschlossen: $BACKUP_DIR/full_backup.tar.gz"
    fi

    log "Backup abgeschlossen."
}

# Wiederherstellungsfunktion
restore() {
    local restore_dir="$1"
    if [ -z "$restore_dir" ]; then
        log "Bitte geben Sie das Backup-Verzeichnis an."
        exit 1
    fi

    log "Starte Wiederherstellung aus $restore_dir"

    # Paketliste wiederherstellen
    if [ -f "$restore_dir/installed_packages.list" ]; then
        sudo dpkg --set-selections < "$restore_dir/installed_packages.list"
        sudo apt-get -y dselect-upgrade
        log "Paketliste wiederhergestellt."
    else
        log "Warnung: Paketliste nicht gefunden."
    fi

    # Konfigurationsdateien wiederherstellen
    if [ -f "$restore_dir/etc_backup.tar.gz" ]; then
        sudo tar xzf "$restore_dir/etc_backup.tar.gz" -C /
        log "Konfigurationsdateien wiederhergestellt."
    else
        log "Warnung: Backup der Konfigurationsdateien nicht gefunden."
    fi

    # Gesamtes Dateisystem wiederherstellen (optional)
    if [ "$FULL_RESTORE" = true ] && [ -f "$restore_dir/full_backup.tar.gz" ]; then
        log "Starte vollständige Wiederherstellung..."
        sudo tar xzf "$restore_dir/full_backup.tar.gz" -C /
        log "Vollständige Wiederherstellung abgeschlossen."
    fi

    log "Wiederherstellung abgeschlossen."
}

# Hauptprogramm
case "$1" in
    backup)
        FULL_BACKUP=false
        [ "$2" = "full" ] && FULL_BACKUP=true
        backup
        ;;
    restore)
        FULL_RESTORE=false
        [ "$3" = "full" ] && FULL_RESTORE=true
        restore "$2"
        ;;
    *)
        echo "Verwendung: $0 {backup|restore} [Optionen]"
        echo "  backup [full]  - Führt ein Backup durch (optional: vollständiges Backup)"
        echo "  restore DIR [full] - Stellt aus dem angegebenen Verzeichnis wieder her"
        exit 1
        ;;
esac

exit 0
