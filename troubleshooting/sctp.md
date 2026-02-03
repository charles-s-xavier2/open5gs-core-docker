# Problemas com SCTP

Erro comum:
- Porta 38412 não aparece no ss

Solução:
```bash
sudo modprobe sctp
sudo apt install -y lksctp-tools
