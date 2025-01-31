# Time Settings for Operating System Logs

**Purpose**: To document and standardize time settings across operating systems to ensure accurate and consistent log timestamps.

---

## Ubuntu

### Default Log Location
- System logs: `/var/log/syslog`
- Authentication logs: `/var/log/auth.log`

### Enhancing Timestamps
1. Edit the rsyslog configuration file:
   ```bash
   sudo nano /etc/rsyslog.conf

Locate the following line (or add it if it doesn't exist): ```$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat```
Comment it out and replace it with: ```$ActionFileDefaultTemplate RSYSLOG_FileFormat```
Restart the rsyslog service: ```sudo systemctl restart rsyslog```
