How to setup repository
---
`curl -s --compressed "https://packages.univrs.cloud/public.key" | gpg --dearmor | sudo tee /usr/share/keyrings/virgo-packages-keyring.gpg > /dev/null`

`curl -s --compressed -o /etc/apt/sources.list.d/virgo.sources "https://packages.univrs.cloud/virgo.sources"`

`apt update`

`apt install virgo-api virgo-ui virgo-ups`
