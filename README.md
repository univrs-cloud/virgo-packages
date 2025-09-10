How to setup repository
---
`curl -s --compressed "https://packages.univrs.cloud/public.key" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/virgo-packages.gpg > /dev/null`

`curl -s --compressed -o /etc/apt/sources.list.d/virgo.list "https://packages.univrs.cloud/virgo.list"`

`apt update`

`apt install virgo-api virgo-ui virgo-ups`
