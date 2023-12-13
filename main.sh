#!/bin/bash

failo_pavadinimas="rezultatai.txt"
vartotojo_vardas=""

function registruotis {
    read -p "Įveskite savo vardą: " vardas
    echo "$vardas 0 0" >> "$failo_pavadinimas"
    echo "Sėkmingai užregistruota!"
    vartotojo_vardas="$vardas"
}

function prisijungti {
    read -p "Įveskite savo vardą: " vardas
    rezultatas=$(grep "^$vardas " "$failo_pavadinimas")
    if [ -n "$rezultatas" ]; then
        vartotojo_vardas="$vardas"
        echo "Prisijungėte sėkmingai!"
    else
        echo "Vartotojas nerastas. Bandykite dar kartą arba užsiregistruokite."
    fi
}

function meniu {
    echo "----- MENIU -----"
    echo "1. Registruotis"
    echo "2. Prisijungti"
    echo "3. Baigti darbą"
    echo "4. Dokumentacija"
    read -p "Pasirinkite veiksmą: " veiksmas

    case $veiksmas in
        1) if [ -z "$vartotojo_vardas" ]; then registruotis; else echo "Jūs jau prisijungęs!"; fi ;;
        2) if [ -z "$vartotojo_vardas" ]; then prisijungti; else echo "Jūs jau prisijungęs!"; fi ;;
        3) exit ;;
        4) dokumentacija ;;
        *) echo "Neteisingas pasirinkimas. Bandykite dar kartą."
    esac
}

function zaidimo_meniu {
    echo "----- ZAIDIMO MENIU -----"
    echo "1. Mesti kauliuką"
    echo "2. Baigti darbą"
    read -p "Pasirinkite veiksmą: " veiksmas

    case $veiksmas in
        1) mesti_kauliuka ;;
        2) exit ;;
        *) echo "Neteisingas pasirinkimas. Bandykite dar kartą."
    esac
}

function mesti_kauliuka {
    akys=0
    for ((i=0; i<5; i++)); do
        ridenimas=$((RANDOM % 6 + 1))
        echo "Kauliuko ridenimas $((i+1)): $ridenimas"
        sleep 0.5
        akys=$((akys + ridenimas))
    done

    echo "Viso akys: $akys"

    awk -v vardas="$vartotojo_vardas" -v akys="$akys" '$1 == vardas { $3 += 1 } 1' "$failo_pavadinimas" > temp.txt && mv temp.txt "$failo_pavadinimas"

    if [ "$akys" -ge 20 ]; then
        awk -v vardas="$vartotojo_vardas" '$1 == vardas { $2 += 1 } 1' "$failo_pavadinimas" > temp.txt && mv temp.txt "$failo_pavadinimas"
        echo "Sveikiname! Jūs surinkote daugiau nei 20 akių!"
    fi

    echo "Jūs laimėjote: $(awk -v vardas="$vartotojo_vardas" '$1 == vardas { print $2 }' "$failo_pavadinimas") kartu/-us"
    echo "Zaidimu suzaista: $(awk -v vardas="$vartotojo_vardas" '$1 == vardas { print $3 }' "$failo_pavadinimas")"

    zaidimo_meniu
}

function dokumentacija {
echo ""
    echo "Dokumentacija:"
    echo ""
    echo "Ši programa leidžia registruotis ir prisijungti prie žaidimo."
    echo "Žaidimo taisyklės - vartotojas susikuria paskyrą arba prisijungia prie jau egzistuojančios paskyros, ir tuomet gali žaisti"
    echo "Žaidimo eiga - vartotojas/žaidėjas meta kauliuką 5 kartus, ir jei bendras iškritusių akučių skaičius yra 20 arba daugiau, tuomet jis laimi."
    echo "zaidimo tikslas - surinki kuo daugiau pergalių, pavyzdžiui jus ir jūsų draugas susikuriate po paskyrą, paieliui kiekvienas zaidziate zaidimą tris kartus, ir tas kuris turės daugiau pergalių, laimės"
    echo ""
    echo "Funkcijos:"
    echo ""
    echo "1. Registruotis - leidžia įvesti savo vardą ir užsiregistruoti"
    echo "2. Prisijungti - leidžia prisijungti su jau sukurta vartotojo paskyra"
    echo "3. Baigti darbą - programa baigia darba"
    echo "4. Mesti Kauliuką - pradedamas žaidimas - metamas kauliukas 5 kartus ir išvedamas iškritusių akučių skaičius, laimėjimų skaičius ir sužaistų žaidimų skaičius"
    echo""
}

while true; do
    meniu
    if [ -n "$vartotojo_vardas" ]; then
        echo "Vartotojo vardas: $vartotojo_vardas"
        zaidimo_meniu
    fi
done

