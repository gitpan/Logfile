#                              -*- Mode: Perl -*- 
# ITIID           : $ITI$ $Header $__Header$
# Author          : Ulrich Pfeifer
# Created On      : Mon Aug 28 16:37:39 1995
# Last Modified By: Ulrich Pfeifer
# Last Modified On: Sun Mar 24 14:21:39 1996
# Language        : Perl
# Update Count    : 5
# Status          : Unknown, Use with caution!
# 
# (C) Copyright 1995, Universitšt Dortmund, all rights reserved.
# 
# HISTORY
# 
# $Locker: pfeifer $
# $Log: Country.pm,v $
# Revision 0.1.1.1  1996/03/25 11:19:18  pfeifer
# patch1:
#
# Revision 1.1  1996/03/24 13:33:52  pfeifer
# Initial revision
#
# 

package Net::Country;

while (<DATA>) {
    chop;
    ($cc, $rest) = split ' ', $_, 2;
    next unless $cc;
    $country{$cc} = $rest;
    }
close (DATA);

sub Name { $country{uc($_[0])} || $_[0] };

1;

__DATA__
AD   Andorra                                            
AE   United Arab Emirates
AF   Afghanistan
AG   Antigua and Barbuda
AI   Anguilla
AL   Albania
AM   Armenia
AN   Netherland Antilles 
AO   Angola
AQ   Antarctica
AR   Argentina
AS   American Samoa
AT   Austria
AU   Australia
AW   Aruba
AZ   Azerbaidjan
BA   Bosnia-Herzegovina
BB   Barbados
BD   Banglades
BE   Belgium
BF   Burkina Faso
BG   Bulgaria
BH   Bahrain
BI   Burundi
BJ   Benin
BM   Bermuda
BN   Brunei Darussalam
BO   Bolivia
BR   Brazil
BS   Bahamas
BT   Buthan
BV   Bouvet Island
BW   Botswana
BY   Belarus
BZ   Belize
CA   Canada
CC   Cocos (Keeling) Isl.
CF   Central African Rep.
CG   Congo
CH   Switzerland
CI   Ivory Coast
CK   Cook Islands
CL   Chile
CM   Cameroon
CN   China
CO   Colombia
CR   Costa Rica
CS   Czechoslovakia
CU   Cuba
CV   Cape Verde
CX   Christmas Island
CY   Cyprus
CZ   Czech Republic
DE   Germany
DJ   Djibouti
DK   Denmark
DM   Dominica
DO   Dominican Republic
DZ   Algeria
EC   Ecuador
EE   Estonia
EG   Egypt
EH   Western Sahara
ES   Spain
ET   Ethiopia
FI   Finland
FJ   Fiji
FK   Falkland Isl.(Malvinas)
FM   Micronesia
FO   Faroe Islands
FR   France
FX   France (European Ter.)
GA   Gabon
GB   Great Britain (UK)
GD   Grenada
GE   Georgia
GH   Ghana
GI   Gibraltar
GL   Greenland
GP   Guadeloupe (Fr.)
GQ   Equatorial Guinea
GF   Guyana (Fr.)
GM   Gambia
GN   Guinea
GR   Greece
GT   Guatemala
GU   Guam (US)
GW   Guinea Bissau
GY   Guyana
HK   Hong Kong
HM   Heard & McDonald Isl.
HN   Honduras
HR   Croatia
HT   Haiti
HU   Hungary
ID   Indonesia
IE   Ireland
IL   Israel
IN   India
IO   British Indian O. Terr.
IQ   Iraq
IR   Iran
IS   Iceland
IT   Italy
JM   Jamaica
JO   Jordan
JP   Japan
KE   Kenya
KG   Kirgistan
KH   Cambodia
KI   Kiribati
KM   Comoros
KN   St.Kitts Nevis Anguilla
KP   Korea (North)
KR   Korea (South)
KW   Kuwait
KY   Cayman Islands
KZ   Kazachstan
LA   Laos
LB   Lebanon
LC   Saint Lucia
LI   Liechtenstein
LK   Sri Lanka
LR   Liberia
LS   Lesotho
LT   Lithuania
LU   Luxembourg
LV   Latvia
LY   Libya
MA   Morocco
MC   Monaco
MD   Moldavia
MG   Madagascar
MH   Marshall Islands
ML   Mali
MM   Myanmar
MN   Mongolia
MO   Macau
MP   Northern Mariana Isl.
MQ   Martinique (Fr.)
MR   Mauritania
MS   Montserrat
MT   Malta
MU   Mauritius
MV   Maldives
MW   Malawi
MX   Mexico
MY   Malaysia
MZ   Mozambique
NA   Namibia
NC   New Caledonia (Fr.)
NE   Niger
NF   Norfolk Island
NG   Nigeria
NI   Nicaragua
NL   Netherlands
NO   Norway
NP   Nepal
NR   Nauru
NT   Neutral Zone
NU   Niue
NZ   New Zealand
OM   Oman
PA   Panama
PE   Peru
PF   Polynesia (Fr.)
PG   Papua New
PH   Philippines
PK   Pakistan
PL   Poland
PM   St. Pierre & Miquelon
PN   Pitcairn
PT   Portugal
PR   Puerto Rico (US)
PW   Palau
PY   Paraguay
QA   Qatar
RE   Reunion (Fr.)
RO   Romania
RU   Russian Federation
RW   Rwanda
SA   Saudi Arabia
SB   Solomon Islands
SC   Seychelles
SD   Sudan
SE   Sweden
SG   Singapore
SH   St. Helena
SI   Slovenia
SJ   Svalbard & Jan Mayen Is
SK   Slovak Republic
SL   Sierra Leone
SM   San Marino
SN   Senegal
SO   Somalia
SR   Suriname
ST   St. Tome and Principe
SU   Soviet Union
SV   El Salvador
SY   Syria
SZ   Swaziland
TC   Turks & Caicos Islands
TD   Chad
TF   French Southern Terr.
TG   Togo
TH   Thailand
TJ   Tadjikistan
TK   Tokelau
TM   Turkmenistan
TN   Tunisia
TO   Tonga
TP   East Timor
TR   Turkey
TT   Trinidad & Tobago
TV   Tuvalu
TW   Taiwan
TZ   Tanzania
UA   Ukraine
UG   Uganda
UK   United Kingdom
UM   US Minor outlying Isl.
US   United States
UY   Uruguay
UZ   Uzbekistan
VA   Vatican City State
VC   St.Vincent & Grenadines
VE   Venezuela
VG   Virgin Islands (British)
VI   Virgin Islands (US)
VN   Vietnam
VU   Vanuatu
WF   Wallis & Futuna Islands
WS   Samoa
YE   Yemen
YU   Yugoslavia
ZA   South Africa
ZM   Zambia
ZR   Zaire
ZW   Zimbabwe
ARPA   Old style Arpanet
COM   US Commercial
EDU   US Educational
GOV   US Government
INT   International
MIL   US Military
NATO   Nato field
NET   Network
ORG   Non-Profit
