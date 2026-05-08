## 🎯 Getting Started

```bash
# Check Caddy version
caddy version

# Validate configuration
caddy validate --config /etc/caddy/Caddyfile

# Test configuration
caddy run --config /etc/caddy/Caddyfile

# Check service status
sudo systemctl status caddy

# Test the service
curl http://localhost
```

## ⚙️ Configuration

### Main Configuration File

**Location**: `/etc/caddy/Caddyfile`

```bash
# Edit configuration
sudoedit /etc/caddy/Caddyfile

# After editing, always restart the service
sudo systemctl restart caddy
```

## 📚 Learn More

- [Getting Started](https://caddyserver.com/docs/getting-started)
- [Caddyfile Tutorial](https://caddyserver.com/docs/caddyfile-tutorial)
- [Caddyfile Concepts](https://caddyserver.com/docs/caddyfile/concepts)
- [Configuration Reference](https://caddyserver.com/docs/caddyfile)
- [Automatic HTTPS](https://caddyserver.com/docs/automatic-https)
- [Community Forum](https://caddy.community/)

**Happy learning! 🚀**
