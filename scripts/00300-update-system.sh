printf "\n\n##### Beginning 00300-update-system.sh\n\n" >> /root/report/build-report.txt

printf "\n## UPDATE THE APT SOURCES \n\n"

cat <<EOF > /etc/apt/sources.list
deb http://ftp.us.debian.org/debian jessie main contrib non-free

deb http://httpredir.debian.org/debian jessie-updates main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free

deb http://http.debian.net/debian jessie-backports main contrib non-free

deb http://packages.dotdeb.org jessie all

deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7
EOF

cd /root

printf "\n## INSTALL THE DOTDEB GPG KEY ###\n"

# gpg key for Dotdeb

echo "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG/MacGPG2 v2.0.14 (Darwin)

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
=Wpa7
-----END PGP PUBLIC KEY BLOCK-----" | apt-key add -

# less secure command to blindly trust innerweb data
#wget -q -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -
# gpg source location to verify correctness: http://www.dotdeb.org/dotdeb.gpg

printf "\n## INSTALL THE ORACLE MYSQL GPG KEY ###\n"

# gpg key for Oracle Community MySQL Server 5.7

echo "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1

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
UHLh9aA+AKCHDkOBKBrGb8tOg9BIub3LFhMvHQCeIOOot1hHHUlsTIXAUrD8+ubI
eZaIZQQTEQIAHQUCPj6jDAUJCWYBgAULBwoDBAMVAwIDFgIBAheAABIJEIxxjTtQ
cuH1B2VHUEcAAQFxjgCeKVTBNefwxq1A6IbRr9s/Gu8r+AIAniiKdI1lFhOduUKH
AVprO3s8XerMiGUEExECAB0FAkeslLQFCQ0wWKgFCwcKAwQDFQMCAxYCAQIXgAAS
CRCMcY07UHLh9QdlR1BHAAEBrpIAn38+BlBI815Dou9VXMIAsQEk4G3tAJ9+Cz69
Y/Xwm611lzteJrCAA32+aYhlBBMRAgAdBQsHCgMEAxUDAgMWAgECF4AFAktwL8oF
CRDz86cAEgdlR1BHAAEBCRCMcY07UHLh9bDbAJ4mKWARqsvx4TJ8N1hPJF2oTjke
SgCeMVJljxmD+Jd4SscjSvTgFG6Q1WCIbwQwEQIALwUCTnc9rSgdIGJ1aWxkQG15
c3FsLmNvbSB3aWxsIHN0b3Agd29ya2luZyBzb29uAAoJEIxxjTtQcuH1tT0An3EM
rSjEkUv29OX05JkLiVfQr0DPAJwKtL1ycnLPv15pGMvSzav8JyWN3Ih7BDARAgA7
BQJCdzX1NB0AT29wcy4uLiBzaG91bGQgaGF2ZSBiZWVuIGxvY2FsISBJJ20gKnNv
KiBzdHVwaWQuLi4ACgkQOcor9D1qil/vRwCdFo08f66oKLiuEAqzlf9iDlPozEEA
n2EgvCYLCCHjfGosrkrU3WK5NFVgiI8EMBECAE8FAkVvAL9IHQBTaG91bGQgaGF2
ZSBiZWVuIGEgbG9jYWwgc2lnbmF0dXJlLCBvciBzb21ldGhpbmcgLSBXVEYgd2Fz
IEkgdGhpbmtpbmc/AAoJEDnKK/Q9aopfoPsAn3BVqKOalJeF0xPSvLR90PsRlnmG
AJ44oisY7Tl3NJbPgZal8W32fbqgbIkBHAQSAQIABgUCS8IiAwAKCRDc9Osew28O
Lx5CB/91LHRH0qWjPPyIrv3DTQ06x2gljQ1rQ1MWZNuoeDfRcmgbrZxdiBzf5Mmd
36liFiLmDIGLEX8vyT+Q9U/Nf1bRh/AKFkOx9PDSINWYbE6zCI2PNKjSWFarzr+c
QvfQqGX0CEILVcU1HDxZlir1nWpRcccnasMBFp52+koc6PNFjQ13HpHbM3IcPHaa
V8JD3ANyFYS4l0C/S4etDQdX37GruVb9Dcv9XkC5TS2KjDIBsEs89isHrH2+3Zlx
dLsE7LxJ9DWLxbZAND9OiiuThjAGK/pYJb+hyLLuloCg85ZX81/ZLqEOKyl55xuT
vCqltSPmSUObCuWAH+OagBdYSduxiQEiBBABAgAMBQJJKmigBQMAEnUAAAoJEJcQ
uJvKV618U4wIAKk/45VnuUf9w1j7fvdzgWdIjT9Lk9dLQAGB13gEVZEVYqtYF5cE
Zzyxl8c7NUTCTNX3qLIdul114A4CQQDg5U9bUwwUKaUfGLaz380mtKtM9V9A4fl9
H2Gfsdumr8RPDQihfUUqju+d0ycdmcUScj48Nctx0xhCCWNjOFPERHi9hjRQq7x6
RKyFTLjM5ftdInHCo9S+mzyqz9O+iMgX68Mm+AVgdWSC9L6yGnw6H97GD28oRMGW
BTzsmCyqf9I3YutH8mGXRot3QbSJD7/AeZVh1BQwVoJnCT8Eo1pc/OYZkRRndE1t
hrX0yjuFwTeOzvqeHlgzEW/FtOCBW7iR0WSJASIEEAECAAwFAkozTogFAwASdQAA
CgkQlxC4m8pXrXwXiAf+Ked6Mgd98YyTyNiLHhllPulboCnKgj430jLzkfgv7ytV
Cu1xMfKrRWRw3fA9LC19mzNQX/So/o/ywsk0nUG2sfEs5FiMk+aC957Ic/MDagmX
qKapZROJbzbZ/KNj9rPCG9kXPGa9sUn6vk39nnv4hri30tNKpM0fMxRhpcoNoCrN
l4rs/QTpdRpp7KBuNaMEtDU7R7OjMDL4qT+BcCmYMIYW4dIV7tmaC0VxtcszZcVC
kxSigRMPZHwxSx37GdCx9/+TqlA4vGL6NQSxZKv+Kqa+WTqBngOl6YGO6FxdiXEl
iNRpf1mafmz6h8XgYXFGpehjuX1n60Iz0BffuWbpL4kBIgQQAQIADAUCSkRyCgUD
ABJ1AAAKCRCXELibyletfPaaB/9FCSmYwz7mvzOfHZOlEAYeLnCS290XGW89o4FY
Tbw0PBOulygyqj2TMCK68RCNU2KFs/bXBHeS+dDzitMAfSaULYi7LJuCCmrDM5SX
5aLSj6+TxkDQDR1K1ZE3y6qd4Kx3VeeoN7Wu+oLj/3Jjbbe0uYCQ+/PniRra9f0Z
0neTExZ7CGtVBIsKS1CnKBTR26MZMOom2eTRZwGFUX1PzuW/dbZ4Z0+J6XMdTm2t
d7OYYWPbV3noblkUrxyjtGtO3ip3Oe3zSCWHUFMaaEuXOMw8tN51wy6ybcPVAH0h
OiBwb3iCFJ/20QqaZEno6edYzkqf0pwvrcTmiPb+Vj0fnjBJiQEiBBABAgAMBQJK
Vj5HBQMAEnUAAAoJEJcQuJvKV61845AH/R3IkGIGOB/7x3fI0gOkOS0uFljDxysi
M8FV06BfXbFpRgFMZxAhNFUdKCDN98MDkFBd5S5aGkvhAHS7PVwQ8/BIyJaJeUG3
AXmrpFV/c9kYn1+YW5OQ9E7tKu5l5UOj1Y/weNtC04u6Rh/nrp6CvMBhH2nvhSBZ
+2kO2auqtFOhuK6+wUHGixt5EK8RAKs3Sf6nkP2EJUHzy1Q8ec5YDiaV24AVkPFB
ZMCkpD3Z+seIGrL4zUkV7PPY4zd9g34Oqj8JvtnA4AD/Z1vBLujLixcQdt9aieOy
SA9DAVgHbe2wVS4zi5nBURsmD5u96CUOwNK1sOV+ACtdIv/T5qSUVweJASIEEAEC
AAwFAkpoCoQFAwASdQAACgkQlxC4m8pXrXysfQf+IJyIPhTphk0kGPQY3v9e3znW
30VahyZxoL6q25eeQWGmVeTFlU4JThUEyzgYGip8i9qBsFPJ9XgOL5bxTGv7/WOK
7eX8e+gXHB3A2QYbrM0GFZKN3BCkbA++HmvJXU58tf+aBCB0ObG+rPn6QUNSPibu
4tp65TaPVPSVHjNTTICxu3sneHB+okJcc5z1ubme8nAytKb6x0JM/keNSXAev2ZN
7zG5m+Pqw7/DQ/gCogzGML1bulP2rSh8bYpJPC3vAVuHTmxsbhRBg4l7j5KiHf4q
MBrVzRy+YiHhwpf2p8JbCGF141+HUD1VMeGeXnNO/9SO+dC2OGUf8WrV4FIpxIkB
IgQQAQIADAUCSnkuCgUDABJ1AAAKCRCXELibyletfBjrCACDd/zvoveoNlNiUUBa
zelcGXwaxSvUMSROUQNkxkoMzfA+aFpYFHWEwDfLqndpoJTIkgkESd5fODJT26oL
FekLvx3mpzfGz8l39KzDM1i6+7Mtg7DnA3kvfVIuZBNDwqoTS6hHKcGa0MJDgzZQ
qJ9Ke/7T7eY+HzktUBLjzUY2kv5VV8Ji0p6xY27jT73xiDov00ZbBFN+xBtx2iRm
jjgnPtjt/zU5sLiv9fUOA+Pb53gBT+mXMNx2tsg07Kmuz7vfjR5ydoY7guyB3X1v
UK9yAmCW1Gq67eRG934SujZFikO/oZUrwRrQu2jj5v8B7xwtcCFCdpZAIRabD4BT
glvPiQEiBBABAgAMBQJKjl+9BQMAEnUAAAoJEJcQuJvKV618DTwH/3DzIl1zwr6T
TtTfTBH9FSDdhvaUEPKCbLT3WZWzIHREaLEENcQ85cGoYoBeJXVBIwBczZUpGy4p
qFjYcWQ9vKFm2Nt1Nrs+v9tKc+9GECH0Y1a+9GDYqnepcN2O/3HLASCEpXFwQhVe
01G+lupGgqYfMgTG9RByTkMzVXB9ER5gijGCzjTflYAOFUx2eBBLYa3w/ZZpT+nw
RmEUaDpfwq06UPrzMZuhol7SGPZUNz4lz4p2NF8Td9bkhOiJ3+gORRohbq0HdaRd
vSDoP/aGsQltfeF5p0KEcpIHx5B05H1twIkOGFTxyx3nTWqauEJy2a+Wl5ZBl0hB
2TqwAE9Z54KJASIEEAECAAwFAkqgEkcFAwASdQAACgkQlxC4m8pXrXwyXwf/UPzz
+D+n19JWivha7laUxuDzMQCKTcEjFCu4QVZ1rqcBFPoz0Tt74/X75QdmxZizqX1E
6lbFEsbVjL2Mt5zZjedS1vbSbrmn4hV4pHZr08dbflZkNX105g8ZlpsqQ7VyUt5Y
tWCn0tGNn4B5Eb6WMeqxQteujV3B7AtMH+CD0ja+A2/p0rHIpqScz8aupksBMCrY
qhoT+7/qXNEVkjNmcu2NmHxfv6dL5Xy/0iJjie2umStu8WTfRTpYmnv2gEhbCdb/
zhFvG61GgTBJqv9MvBVGRxnJFd4lNqlucsadD+UM7WjV3v5VuN2r9KD9wocd/s22
ELCRA2wKccvR/nWBkIkBIgQQAQIADAUCSqgQAAUDABJ1AAAKCRCXELibyletfAT8
B/9cPhH8DlHoiv+cK8rAJMomZqVqOyy4BwsRrakycVlg7/yvMs74anynSoUf0Lgs
XADQ29Hmrpf+zC5E5/jPGWNK81x2VBVoB8nZkMSAnkZfOw+mWu9IAj2NLcsvt9JY
NmAq5R7RrirHsDQ2DIYxRgaE/5CVEVry9YQEj18A13/SYyoB4FWpDI4fRfUWJbUJ
rYmfg0p+4zL0YS9F11UhsHUu+g1W1c83N54ozI1v0l3HUwVayzII4E/YNrIkpOaO
+o8Rz9g6M6jCg3mwn+OfiZVJO++VOiguJF5KzoZIICMxXE3t5hL87Kroi7UkNwm+
YHw3ZaLEBm0BWAXw4DsJZcpViQEiBBABAgAMBQJKuceJBQMAEnUAAAoJEJcQuJvK
V6188KEH/24QK2LV1l424Wx3T9G4bJFRWWuuEkTpYJw6ss72lqus9t7BsoGaNLMH
QzKAlca9wLTqY826q4nv9anEqwWZ+Di8kE+UAMUq2BFTL0EvOMJ6i1ZyE8cUFVb1
+09tpBWJJS7t3z00uMMMznGuHzSm4MgCnGhAsOgiuHdPWSlnHnqNJa/SB6UVQxtc
DOaqQlLIvhd2HVqrOBRtER3td/YgLO6HSxXpXtz8DBa2NYQYSwAdlqJAPLBnBsLX
wbCswuIDMZZv8BJwUNBEJkokOMv5CXxhPrP5kxWvyBvsIhTk8ph2GIh/ZRVNDAsC
hbuU1EJBACpwaMrcgwjPtI7/KTgeZVSJASIEEAECAAwFAkreCMYFAwASdQAACgkQ
lxC4m8pXrXyOQQf7BvRm/3PvFCCksyjBW4EVBW7z/Ps/kBK6bIE9Q7f7QlXFIcGG
UIpArufXWbV+G4a3Z8LFeFJTovNePfquwpFjneUZn1CG+oVS1AfddvYhAsgkLhQq
MbaNJIJ1y4D/H3xvCna/s7Teufud0JLXoLBedFXeB5Cg2KlEoxINqMo+lm/VGJmb
ykwqoRvxZLDfnbFag5zG59+OWw4TC8nzlIQYIBn22YiWRk5zsCJA40O+KL1vwBiF
DrREhALQc/YBJKYrRX3ZV4U/EeYDKB0NCBk1W1tXGCee3uhM0S5VFc1j7Pg58ECu
ntH5xOy+KMNFljiQwvWfbaFTJvCjFQS+OplXb4kBIgQQAQIADAUCSu86VAUDABJ1
AAAKCRCXELibyletfGs8CACteI2BmKs24GF80JeWTOQIcvHnCdV7hKZOltbNPBbD
v6qTt3iX2GVa10iYhI5Eg3Ojt/hKFJTMlfYZyI1peFodGjv7Lk5lu7zaNBvT1pBC
P+eJspi6rGpSuhtMSb4O5jPclRBmbY+w9wctLyZf1zG+slSdw8adcRXQNFqrvVIZ
YOmu2S8FunqLfxpjewiFiDPzAzmbWzMoO2PLCYFhwV6Eh2jO33OGbvBmyHNFZBfX
5F/+kiyeT47MEhrfhytJ6ZOdpxtX8HvbvzPZcDLOI80W6rPTG76KW06ZiZrJ81YC
a6a7D01y7BYyW2HoxzYcuumjRkGF4nqK4Mw+wefCp0H/iQEiBBABAgAMBQJLAF3a
BQMAEnUAAAoJEJcQuJvKV618/q0H/ibXDQG2WQmC1LoT4H+ezXjPgDg8aiuz6f4x
ibTmrO+L4ScMX+zK0KZVwp6Kau28Nx+gO0oAUW8mNxhd+cl0ZaY+7RIkxEvkooKK
sArBmZT+xrE6CgHlAs3D4Mc+14nfD0aZaUbEiobWvXlYLl27MELLcWyeMlgbeNou
cc473JddvmHSRRM5F9Qp28CvWDEXYqhq1laoaho8+ceipvzyuO3OTwjuAOqhefOH
zAvFrRli99ML8xzF1ZOvBct+36SuYxDXyIhkSd7aG9Us0lW6W5SiJYt4cDyI0JDh
bhZN0tzWYKcKMZMxf8w3jW4sfQL0prhHrARqqPiU8OTUH/VNX5CJASIEEAECAAwF
AksRgasFAwASdQAACgkQlxC4m8pXrXydogf/a31ofmYFMoE3p9SqGt/v28iyO0j9
A1LmqKwEhJkxff/X/Qa7pafGQ9J90JQkxYKMxydWPspTbDFMccZWkBK132vZp9Q3
FHKpnDPDLK2S25miTReeAAQNgMMFLeyy7ZHi5YsKwLbKxcSo7/m0jlitNYlmt94i
mFNpg/mHGsy6O+rLeQTAopuIzP3VwN6ItL5gIFxqWPmf/V0xh/vxTwLqJ66vECD8
vyHrHblUzgiXHgyYbZPxAa2SRRd34V38phaZ/QsTkss+Sd/QeHChWyU9d6KengWw
cr/nDO+K/hhmnO5Oqz02Upwyxrgi6484HQUN/Smf44VBsSD1DBjaAKjMr4kBIgQQ
AQIADAUCSyNN1AUDABJ1AAAKCRCXELibyletfCWiB/9cEZtdFVcsxpE3hJzM6PBP
f+1QKuJORve/7MqNEb3TMWFgBxyOfvD7uMpCJyOrqq5AbUQfZfj9K7qmzWUMuoYc
eGIlbdmHFBJwtmaF0BiyHaobgY/9RbdCNcbtzrW34feiW9aDZyvCoLHEVkCCQACS
v3FwdYVkkRB5eihvpwJk5tpScdIA12YLqzmVTFdhrZuYvtDdQHjgoLMO8B9s9kok
7D2TSpveVzXXPH68Z3JkVubhHT7cs+n+9PRvcaVJtsX2VTUY5eFVqmGuAUVrvp2a
N8cKQ+mVcCQrVVIhT9o8YB5925MUx2VJml0y0nkBQuMZyzMEOVGkuU/G+pVrRmmA
iQEiBBABAgAMBQJLJyaSBQMAEnUAAAoJEJcQuJvKV618eU0IAKnVh6ymId9C3ZqV
yxwTnOB8RMQceJzwCLqk2RT0dPhN5ZwUcQN7lCp9hymMutC8FdKRK/ESK21vJF2/
576Pln4fIeOIbycBAEvqrL14epATj53uBizoNOTuwb1kximFERuW3MP4XiFUJB0t
Pws2vR5UU3t6GoQJJwNoIbz9DK2L6X/Qz3Tb9if6bPSKU6JR1Yn3Hos9ogg21vWC
xgMTKUuPAYhmYjSvkqH3BihXi+c17MVvE7W5GJbQHuJo+MgSxu044qnvDHZpf4Mz
c30XcG1ohjxefNyeiY2bzdI2yCaCtmWOlCW1Sc2oiE0zwO6lD4hY5XmC2XqlMLsK
B5VNXJGJASIEEAECAAwFAks4Ze4FAwASdQAACgkQlxC4m8pXrXyWXggAon2abiNv
Rzx97364Mjx4IlFvM1tVebzNbOkDwZS1ABqTDGgq/ffZA/VZrU+h2eL97cQyGxJE
Q5kkm/v1iobEZEFMT0pv9WMzfidqzhdKdcpbbxdaErIjD5fBACKdjazAUeH7zce2
v+bBN0l9LZoRiXbNugG938lkJ2E4ZTYYfvftL/e4RzOgqR9VD/A5MzxfXFbCVhar
HbeT8OwZy4Oz2UDaDszHsNKoG1WNpOSf2HTMBPNcsOSY/hIBRWNxnzdYOkWt7lae
LNmN1eUEwzk4J7GnlambPIctOdoEUriMSaeyTkLZGejKnwi/PqARyDW1FsReKNHD
753ZMViUnAsq2IkBIgQQAQIADAUCS0oyJwUDABJ1AAAKCRCXELibyletfGodCAC5
hjmxwquHSb8ZL0RifIL3j3iU6U7qLK1TQKkTqgELfUzeF9f8NuNRtxLmzNk1T7YI
9iji6NAtnuy43v61OMbqlkV8x69qNP36Owv408wXxEt0s5ViZuVOZJAY075cYRho
pgfmhkh4hbkAoKCLajOR0WUEEsDHsqqj8XLJuGRREURy8TJWaB/cotXsgiJf99gt
+gIwIn8tyb3+WVIUHWfw2+Drpd3nfcMqgeO54PePJo0BWWjaar+wgC/76Se286IH
cYMrml/AdnvxZaIKmxZmkTmDMCfMnVjRYSKBGjQ9Uu7dws7SMsbbd34f8Jt9nyuR
qMcl4INAXthWY/S3SdiliQEiBBABAgAMBQJLW/5mBQMAEnUAAAoJEJcQuJvKV618
1L8IAKq3ZOQHzqaOoz5wnvj51YG8nZoW5RG7HOb3mL1D9b+FTTzaIxsLf7STagPw
KtM57rU/7ehHIuO/9QQNQ3Mudw17ZiwD0l5X7iG8/AflWnc6bXfTz18IplRuqyVc
0qQeJZhT7MBpklcS4ZGZHPQdtAh4Aw5YXihrbbq6jV7jCzUmFz4XcT8CkJHIUGoF
R0vTmFqlAt2K1imwGMh2IEamPOJ0wsTbBfZbhmkB03RToEjIipGZM+NtKS/NL2RJ
YWZ+FCCcEMoRgmlVmATWw3natgLWwN4Z6K4rGXONWi/0wyFgxZpmjdHmjcXaIgz8
EroVsLbnaV/8yG7cgK5e6M0Fk1iJASIEEAECAAwFAkttIfgFAwASdQAACgkQlxC4
m8pXrXyR3QgAksvAMfqC+ACUEWSVAlepDFR1xI45UwBa2UeBY7KjOOCiZlkGREvx
20IOv1gExyPlzNxDeqmYsl2mleEoH6QlXaJRd8MxIVfAnjAt8izwU2dfDwflTTWg
GQYf8q7qeAv1XC34yNge0JaTD1C55QpmcO51f2ojMsAi36bBJO4Dr59jhVYiDjQA
DS/d7FpAznlhH9SGUq6ekYb2jxCSrvt0wRtMyk6YGgts4xEHcN0wC9VTobaXo9xv
sqhtUK44Gdvptq1cBFX8byzD6fN8nXp+v8qhtlPYDqb4muqTh2UXXiWMtvPXo7kk
ZQ8CvI3YbZ10F1IDLt20VJWFZaJYL2fzyokCIgQQAQIADAUCQYHLhQWDBiLZBwAK
CRCq4+bOZqFEaKgvEACCErnaHGyUYa0wETjj6DLEXsqeOiXad4i9aBQxnD35GUgc
FofC/nCY4XcnCMMEnmdQ9ofUuU3OBJ6BNJIbEusAabgLooebP/3KEaiCIiyhHYU5
jarpZAh+Zopgs3Oc11mQ1tIaS69iJxrGTLodkAsAJAeEUwTPq9fHFFzC1eGBysoy
FWg4bIjz/zClI+qyTbFA5g6tRoiXTo8ko7QhY2AA5UGEg+83Hdb6akC04Z2QRErx
KAqrphHzj8XpjVOsQAdAi/qVKQeNKROlJ+iq6+YesmcWGfzeb87dGNweVFDJIGA0
qY27pTb2lExYjsRFN4Cb13NfodAbMTOxcAWZ7jAPCxAPlHUG++mHMrhQXEToZnBF
E4nbnC7vOBNgWdjUgXcpkUCkop4b17BFpR+k8ZtYLSS8p2LLz4uAeCcSm2/msJxT
7rC/FvoH8428oHincqs2ICo9zO/Ud4HmmO0O+SsZdVKIIjinGyOVWb4OOzkAlnnh
EZ3o6hAHcREIsBgPwEYVTj/9ZdC0AO44Nj9cU7awaqgtrnwwfr/o4V2gl8bLSklt
ZU27/29HeuOeFGjlFe0YrDd/aRNsxbyb2O28H4sG1CVZmC5uK1iQBDiSyA7Q0bbd
ofCWoQzm5twlpKWnY8Oe0ub9XP5p/sVfck4FceWFHwv+/PC9RzSl33lQ6vM2wIkC
IgQTAQIADAUCQp8KHAWDBQWacAAKCRDYwgoJWiRXzyE+D/9uc7z6fIsalfOYoLN6
0ajAbQbI/uRKBFugyZ5RoaItusn9Z2rAtn61WrFhu4uCSJtFN1ny2RERg40f56pT
ghKrD+YEt+Nze6+FKQ5AbGIdFsR/2bUk+ZZRSt83e14Lcb6ii/fJfzkoIox9ltki
fQxqY7Tvk4noKu4oLSc8O1Wsfc/y0B9sYUUCmUfcnq58DEmGie9ovUslmyt5NPnv
eXxp5UeaRc5Rqt9tK2B4A+7/cqENrdZJbAMSunt2+2fkYiRunAFPKPBdJBsY1sxe
L/A9aKe0viKEXQdAWqdNZKNCi8rd/oOP99/9lMbFudAbX6nL2DSb1OG2Z7NWEqgI
AzjmpwYYPCKeVz5Q8R+if9/fe5+STY/55OaI33fJ2H3v+U435VjYqbrerWe36xJI
tcJeqUzW71fQtXi1CTEl3w2ch7VF5oj/QyjabLnAlHgSlkSi6p7By5C2MnbCHlCf
PnIinPhFoRcRGPjJe9nFwGs+QblvS/Chzc2WX3s/2SWm4gEUKRX4zsAJ5ocyfa/v
kxCkSxK/erWlCPf/J1T70+i5waXDN/E3enSet/WL7h94pQKpjz8OdGL4JSBHuAVG
A+a+dknqnPF0KMKLhjrgV+L7O84FhbmAP7PXm3xmiMPriXf+el5fZZequQoIagf8
rdRHHhRJxQgI0HNknkaOqs8dtrkCDQQ+PqMdEAgA7+GJfxbMdY4wslPnjH9rF4N2
qfWsEN/lxaZoJYc3a6M02WCnHl6ahT2/tBK2w1QI4YFteR47gCvtgb6O1JHffOo2
HfLmRDRiRjd1DTCHqeyX7CHhcghj/dNRlW2Z0l5QFEcmV9U0Vhp3aFfWC4Ujfs3L
U+hkAWzE7zaD5cH9J7yv/6xuZVw411x0h4UqsTcWMu0iM1BzELqX1DY7LwoPEb/O
9Rkbf4fmLe11EzIaCa4PqARXQZc4dhSinMt6K3X4BrRsKTfozBu74F47D8Ilbf5v
SYHbuE5p/1oIDznkg/p8kW+3FxuWrycciqFTcNz215yyX39LXFnlLzKUb/F5GwAD
BQf+Lwqqa8CGrRfsOAJxim63CHfty5mUc5rUSnTslGYEIOCR1BeQauyPZbPDsDD9
MZ1ZaSafanFvwFG6Llx9xkU7tzq+vKLoWkm4u5xf3vn55VjnSd1aQ9eQnUcXiL4c
nBGoTbOWI39EcyzgslzBdC++MPjcQTcA7p6JUVsP6oAB3FQWg54tuUo0Ec8bsM8b
3Ev42LmuQT5NdKHGwHsXTPtl0klk4bQk4OajHsiy1BMahpT27jWjJlMiJc+IWJ0m
ghkKHt926s/ymfdf5HkdQ1cyvsz5tryVI3Fx78XeSYfQvuuwqp2H139pXGEkg0n6
KdUOetdZWhe70YGNPw1yjWJT1IhUBBgRAgAMBQJOdz3tBQkT+wG4ABIHZUdQRwAB
AQkQjHGNO1By4fUUmwCbBYr2+bBEn/L2BOcnw9Z/QFWuhRMAoKVgCFm5fadQ3Afi
+UQlAcOphrnJ
=JIsu
-----END PGP PUBLIC KEY BLOCK-----" | apt-key add -

# how to programmatically install the gpg key blindly
#gpg --keyserver hkp://keys.gnupg.net --recv-keys 5072E1F5
#gpg --export -a 5072e1f5 > pubkey_mysql.asc
#sudo apt-key add pubkey_mysql.asc

printf "\n## SET DEBIAN_FRONTEND=noninteractive ###\n"
export DEBIAN_FRONTEND=noninteractive

printf "\n## UPDATE THE SYSTEM ###\n"

apt-get -y update

printf "\n## UPGRADE THE SYSTEM\n\n"

apt-get -y dist-upgrade
apt-get -y upgrade

printf "\n## INSTALL THE FIRST BATCHES OF PACKAGES ###\n"

#TODO Set this back to more full install
# Full list of intended packages
#apt-get -y install sudo tcl perl python3 tmux ssh openssl openssl-blacklist libnet-ssleay-perl fail2ban git curl imagemagick expect

apt-get -y install sudo perl python3 ssh openssl openssl-blacklist libnet-ssleay-perl fail2ban curl expect

printf "\n## CLEAN UP ###\n"

printf "\nFirst autoremove of packages\n\n"

apt-get -y autoremove
