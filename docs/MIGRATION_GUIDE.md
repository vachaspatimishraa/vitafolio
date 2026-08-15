# Vitafolio Migration Guide

This guide helps you migrate between different versions of Vitafolio.

---

## Version 1.0 to 1.1 (Upcoming)

### Database Changes

No breaking database changes are planned for version 1.1. Existing resumes will remain compatible.

### API Changes

No API changes are expected for version 1.1.

### Migration Steps

1. Install version 1.1
2. Launch the app
3. Your data will be automatically migrated if needed
4. Verify your resumes are accessible

---

## Version 0.x to 1.0

### Initial Release

This is the first stable release. All data from beta versions will be automatically migrated.

### Migration Steps

1. Install version 1.0
2. Launch the app
3. Your existing data will be automatically migrated
4. Verify all resumes are accessible

---

## Database Schema Migration

When database schema changes occur, follow these steps:

### 1. Backup Current Data

```bash
# Backup database files before migration
cp -r ~/Library/Application\ Support/Vitafolio/ ~/Documents/vitafolio-backup/
```

### 2. Apply Migration

The app will automatically apply schema migrations on launch.

### 3. Verify Migration

1. Open the app
2. Check that all resumes are accessible
3. Verify data integrity
4. Report any issues

---

## Breaking Changes

### Handling Breaking Changes

When breaking changes are introduced:

1. Check the migration guide
2. Backup your data
3. Follow the migration steps
4. Report any issues

---

## Troubleshooting

### Data Loss Prevention

- Always backup before upgrading
- Test upgrades on non-production data first
- Report any data issues immediately

### Migration Failures

If migration fails:

1. Rollback to previous version
2. Restore from backup
3. Contact support
4. Do not attempt manual database modifications

---

## Support

For migration assistance:
- Email: support@vitafolio.app
- GitHub: https://github.com/vitafolio/vitafolio/issues