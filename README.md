How to setup repository
---
`curl -s --compressed "https://univrs-cloud.github.io/virgo-packages/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/virgo-packages.gpg >/dev/null`

`curl -s --compressed -o /etc/apt/sources.list.d/virgo.list "https://univrs-cloud.github.io/virgo-packages/virgo.list"`

`apt update`

`apt install virgo-api virgo-ui virgo-ups`
