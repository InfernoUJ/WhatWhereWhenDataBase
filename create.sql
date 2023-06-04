begin;

DROP TABLE IF EXISTS uczestnicy CASCADE;
CREATE TABLE uczestnicy (
    id SERIAL PRIMARY KEY,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(20) NOT NULL,
    plec CHAR(1),
    data_urodzenia DATE NOT NULL,
    CHECK ((plec = 'M') OR plec = 'F')
);

COPY uczestnicy FROM STDIN DELIMITER ';' NULL 'null';
0;Daniel;Brząkała;F;1974-05-13
1;Tymon;Siemieńczuk;M;1973-09-14
2;Patryk;Kamieniarz;M;2004-02-17
3;Alex;Chuchla;M;1996-08-22
4;Marcelina;Ziegler;F;2003-12-08
5;Norbert;Toś;M;1972-02-18
6;Róża;Wołczyk;F;1973-10-03
7;Aurelia;Wojtak;F;1993-08-07
8;Patryk;Godzik;M;2003-10-23
9;Łukasz;Duczmal;M;1989-06-03
10;Marek;Mikusek;M;1980-12-28
11;Rozalia;Pazera;F;1990-02-03
12;Arkadiusz;Korta;F;1965-09-29
13;Maciej;Flisiak;F;1986-12-01
14;Inga;Gerlach;F;1981-11-21
15;Sara;Kudra;M;1989-03-24
16;Józef;Cieplucha;F;1982-03-09
17;Ryszard;Dulewicz;M;1994-10-22
18;Tymon;Maksym;F;1981-01-16
19;Gustaw;Tórz;F;2011-06-16
20;Borys;Zadora;F;2010-01-22
21;Maurycy;Gwizdek;M;1985-07-16
22;Kacper;Wereda;F;1973-01-29
23;Konrad;Pysz;F;1990-11-10
24;Dagmara;Kij;F;1999-10-06
25;Filip;Fijoł;F;1965-10-01
26;Sonia;Dubel;M;1972-10-19
27;Piotr;Ciemięga;F;1996-12-23
28;Marianna;Wota;M;1967-09-16
29;Maciej;Piotrowiak;F;1977-06-02
30;Kacper;Kołodziejczyk;M;1990-07-05
31;Jan;Petrowicz;M;1997-07-11
\.

DROP TABLE IF EXISTS autor CASCADE;
CREATE TABLE autor(
    id_uczestnika INT PRIMARY KEY,
    ilosc_pytan_odrzuconych INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_autor_uczestnicy
        FOREIGN KEY(id_uczestnika)
            REFERENCES uczestnicy(id)
);

COPY autor FROM STDIN DELIMITER ' ' NULL 'null';
24 9
16 8
7 0
1 3
19 0
\.

DROP TABLE IF EXISTS kategorie CASCADE;
CREATE TABLE kategorie (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(30) NOT NULL UNIQUE
);

COPY kategorie FROM STDIN DELIMITER ',' NULL 'null';
0,Sport
1,Literatura
2,Historia
3,Geografia
4,Nauka
5,Muzyka
6,Sztuka
7,Kino
8,Polityk
9,Technologia
10,Inne
\.

DROP TABLE IF EXISTS pytania CASCADE;
CREATE TABLE pytania (
    id SERIAL PRIMARY KEY,
    tresc TEXT NOT NULL,
    odpowiedz VARCHAR(40) NOT NULL,
    id_kategorii INT,
    CONSTRAINT fk_pytania_kategorie
        FOREIGN KEY(id_kategorii)
            REFERENCES kategorie(id)
);

COPY pytania FROM STDIN DELIMITER ';' NULL 'null';
1;Po 1582 roku, SUCH jest najczęstszym odpowiednikiem HER. SHE i SUCH zostały połączone w tytule serialu grozy w reżyserii Seana Cunninghama. Odtwórz ten tytuł składający się z dwóch słów.;Friday 13th;7
2;Program informacyjny Channel One w dniu 14 maja 2011 roku mówił o bajkowym przedstawieniu obiecanym przez organizatorów ceremonii prezentacji zegarków olimpijskich w Soczi. Zostały one zamontowane, gdy do otwarcia Olimpiady pozostało dokładnie DWADZIEŚCIA MIESIĘCY. Jakie słowa zastąpiliśmy w tekście pytania słowem "TWENTY MONTHS"?;tysiąc i jedna noc;1
3;W chińskim mieście Xian znajduje się pagoda dzikiego YIH. Według legendy pewien mnich modlił się o pomoc podczas wielkiego głodu. I niebo zesłało jedzenie dla pobożnego starca. Kilka tłustych IH wpadło prosto w jego ręce. Podobną historię opowiadał Munchausen, a w jednej z europejskich stolic postawiono im pomnik. Wymień ich imię i nazwisko.;gęsi;2
4;Budując hotel w pobliżu lotniska w Chicago, właściciele zadbali o wszelkie możliwe udogodnienia dla HER. Jednak wkrótce po zajęciu hotelu musieli zainstalować dodatkowe urządzenia, które imitowały szmer fal morskich i rzecznych, szum gałęzi i ciche wycie wiatru. Wymień EE.;izolacja akustyczna;10
5;Projektant Vadim Kibardin stworzył manipulator przeznaczony do walki z dolegliwością zwaną zespołem cieśni nadgarstka. Nazwa tego manipulatora jest taka sama jak tytuł dzieła, którego premiera odbyła się w 1874 roku. Podaj autora tego dzieła.;[Johann] Strauss;5
6;W czasach starożytnych wiele ludów świata przy pochówku oddawało SWOJE ciała. HE odróżnia motocyklistę na motocyklu sportowym, znacznie bardziej niebezpiecznym od innych motocykli, od pozostałych motocyklistów. Wymień JEJ nazwę w dwóch słowach.;pozę embrionalną;10
7;Na opakowaniu słuchawek znanego kanadyjskiego projektanta znajduje się pięć cienkich, poziomych linii równoległych do siebie. Same słuchawki są ułożone tak, aby przypominały THEY, co znajduje odzwierciedlenie w nazwie modelu. Uważa się, że THEY po raz pierwszy pojawiły się w XI wieku. Podaj jedno słowo oznaczające THEY.;noty;9
8;O NIM mówiło się w latach 20. ubiegłego wieku. ONO bylo tematem rozprawy doktorskiej, w której lekarz Caroline Sjönger Philip doszła do wniosku, że immunoalergiczna bronchopneumopatologia jest faktycznie przyczyną zgonów ludzi. Nazwij JEGO w dwóch słowach.;klątwa faraonów;2
9;Baron Robert Baden-Powell uważał, że ludność kolonii powinna być rządzona żelazną ręką, a jeśli jej siła nie zostanie zauważona, ZROBIĆ TO. Etykieta wymaga, aby mężczyzna podczas powitania zrobił TO, ale kobieta nie. Które dwa słowa zastąpiliśmy słowem ZROIC TO?;zdjąć rękawicę;2
10;Komentując porażkę Barcelony z AC Milan, portal championat.com zauważył, że Messi jakby przeniósł się do NIEGO. Inna strona nazwała EGO cudownym kwiatem chińskiej sztuki ludowej. Nazwi EGO za pomocą dwóch słów;teatr cieni;0
11;Elektroniczny alfabet dziecka autorów po naciśnięciu mówi literę, a następnie słowo na tę literę i dźwięk związany z tym słowem. Na przykład Ch - zegar, tykanie, SH - szczeniak, szczekanie. W jednym przypadku dźwięk związany z wypowiadanym słowem jest taki sam jak samo słowo i powtarza się trzykrotnie. Napisz to krótkie słowo.;echo;10
12;Kolizja dwóch samochodów w norweskim miasteczku Bjarkøy, położonym na wyspie w archipelagu Västerålen, od dawna jest omawiana w prasie i nic dziwnego. TAKI samochód i TAKA ciężarówka zderzyły się na TAKIEJ ulicy. Które słowo zastąpiliśmy słowem TAKI?;jedyny;10
13;dignissimos nisi exercitationem tenetur alias cumque inventore placeat corporis facere ea iusto tempora illo fugiat rerum nulla veniam nesciunt ut earum velit laudantium ex itaque fugit neque eum repudiandae dicta eveniet repellat et distinctio blanditiis eligendi;magnam;8
14;animi ducimus beatae dignissimos iste sint ea est fugit eaque nostrum accusantium asperiores voluptates error quaerat placeat magnam ullam suscipit quasi minima quia blanditiis doloremque dolor non accusamus eos veritatis;aspernatur;8
15;vero magnam eos a earum sunt neque in facere sapiente recusandae error cum architecto vel ipsum voluptas laudantium quod quisquam modi ducimus incidunt numquam corrupti veniam itaque et nihil dolor ipsa dicta omnis quasi inventore quis;dolores;7
16;saepe nulla debitis fuga alias molestiae sit nam commodi veniam obcaecati dolore quam pariatur exercitationem at quo quidem perspiciatis eveniet aliquid numquam dolores atque laboriosam beatae ratione esse ab vel iure;perspiciatis;7
17;asperiores vitae debitis consectetur deleniti sint culpa esse perspiciatis a blanditiis qui cum explicabo saepe odio dolorum doloremque molestiae nisi libero fugit ut mollitia modi voluptatum ratione voluptate reiciendis ducimus voluptas dolor incidunt repellat omnis facilis quibusdam ea rerum praesentium ullam corrupti corporis id beatae;sed;6
18;hic deserunt repudiandae omnis fugit quas rem illo fugiat amet natus ea sit porro neque aliquam nostrum consectetur dicta facilis corrupti ullam quae qui deleniti accusantium tempora suscipit sunt in possimus provident tempore;recusandae;0
19;sapiente necessitatibus quae officia est praesentium quisquam perferendis mollitia accusamus rerum assumenda eos quas natus beatae nihil omnis tempore quasi minima vero voluptates saepe quos consequuntur nostrum eligendi porro ad quam magnam deserunt cupiditate tempora possimus ipsum provident earum suscipit incidunt officiis;earum;0
20;dolorum porro quas libero iure excepturi cum beatae natus totam sit perspiciatis ea facere optio reiciendis animi sint voluptas nesciunt dignissimos rem non ullam ipsa maiores aliquam fugit voluptate necessitatibus ducimus repellat suscipit commodi laudantium debitis quam quidem quod fugiat dolore eveniet temporibus obcaecati voluptates expedita officia;ex;0
21;quia expedita iure omnis deserunt quam blanditiis sit nobis labore ratione reiciendis natus laborum nam fugit ullam esse sapiente pariatur iusto obcaecati nostrum error quibusdam vel velit soluta provident at beatae unde eaque quisquam possimus inventore nisi magnam placeat incidunt tempora suscipit a excepturi neque perferendis quod ea;nostrum;10
22;voluptas ratione voluptates perspiciatis consequatur dignissimos libero cupiditate quam necessitatibus in velit vitae impedit reprehenderit eligendi accusamus sunt dolorem commodi asperiores optio quo dolore nulla facere a beatae fugiat facilis amet;iste;1
23;consequuntur dicta praesentium iure quibusdam repellendus accusantium recusandae maiores autem aut similique numquam eius sequi amet aperiam porro fugiat ratione vitae perspiciatis magni quia sint voluptatem commodi neque necessitatibus laborum atque provident cupiditate esse fugit qui sapiente enim voluptatum expedita exercitationem incidunt adipisci asperiores;modi;8
24;quaerat ad odio quidem modi accusantium sint delectus laudantium fugit autem incidunt aliquam molestiae illo a pariatur recusandae maxime ea culpa vero praesentium neque voluptas quae perferendis cum rerum aliquid;ipsa;1
25;tempore laborum perspiciatis enim dignissimos recusandae totam quae omnis dicta est rem nisi soluta debitis vel fugiat ab quasi nesciunt ratione earum hic rerum itaque repellat repellendus illo deleniti et pariatur explicabo temporibus iste sit atque veritatis facere sunt blanditiis molestias error nulla;maiores;6
26;harum quaerat ullam suscipit eligendi earum voluptatibus voluptas reiciendis voluptates blanditiis ut aut aliquid saepe doloribus aspernatur fuga culpa veritatis itaque soluta dolores nihil qui alias ea quia accusamus sapiente ipsa officiis sit et iste omnis optio dolor rem excepturi tempora delectus repudiandae corporis quisquam consequatur vero;praesentium;7
27;eaque aperiam quod odio magnam rerum dicta error reiciendis fugit ab voluptatum ea expedita unde modi perspiciatis voluptate suscipit beatae facilis numquam deserunt at tempore alias quos tenetur quo temporibus pariatur;cumque;8
28;accusamus quisquam odit praesentium in cumque quod a dicta iste quidem iure ad officiis nesciunt natus fugit voluptas ratione quae suscipit sint amet autem id commodi animi facere impedit porro rerum;soluta;8
29;saepe eveniet minus dignissimos amet voluptatem repellat dolor cupiditate totam vero architecto quidem incidunt voluptatibus doloremque voluptatum adipisci fugiat harum in temporibus earum eos odio molestias ab sint quisquam eius deleniti dolores ratione dicta facere voluptates ex explicabo suscipit non qui consequatur pariatur;adipisci;7
30;sapiente ex quod sed impedit aliquid reiciendis ratione nisi et officia doloremque laboriosam ipsa molestias ut esse eos eius corporis delectus amet quis fuga officiis enim vitae aperiam perferendis iusto;saepe;2
31;repellat officia veritatis ipsa quos amet nobis sed unde recusandae rem corrupti natus consequuntur blanditiis pariatur incidunt delectus aperiam molestias quae perferendis a cum velit magnam dolorem doloribus ab esse laboriosam repudiandae animi mollitia dignissimos inventore;quasi;4
32;autem aliquid quos dolore molestias fuga ducimus temporibus ab sunt nemo libero facere tempore hic sed ut ipsa unde vel saepe consectetur ullam distinctio corporis a quis veritatis maiores vitae iure eos explicabo consequatur voluptates facilis totam officia voluptate qui obcaecati enim repellendus officiis doloremque eaque odio illum;cum;10
33;enim reiciendis minima aperiam modi facilis sint dolore eum error necessitatibus voluptas pariatur illum aliquam earum molestias repellendus quod fuga laudantium et sed ad non harum itaque ullam fugiat quisquam odit vero id voluptatum beatae unde maxime nihil tenetur recusandae deleniti nobis;facilis;9
34;quasi quod eveniet earum exercitationem ea beatae ex ab doloribus corporis architecto aut placeat ut consectetur accusantium eaque quisquam quis provident esse voluptas sequi temporibus perferendis labore et sunt aliquid iure repudiandae pariatur tempore obcaecati itaque;distinctio;0
35;reiciendis vitae quam est excepturi rerum aut enim similique vero nulla iusto suscipit animi possimus optio ipsum et voluptatum soluta deleniti ab impedit esse laboriosam iste nihil at nostrum id mollitia sunt perspiciatis hic veritatis autem nobis dolore quas voluptatibus quae pariatur dignissimos tempore debitis reprehenderit minima officiis facilis;iste;0
36;iusto architecto voluptas vero illo consequuntur nisi alias dolores hic asperiores ducimus qui ea earum facilis eos laudantium consequatur impedit obcaecati molestiae recusandae incidunt pariatur aspernatur dignissimos cum quasi itaque accusamus iure blanditiis fugit error atque expedita sapiente repellendus;temporibus;9
37;id quae cumque rem ut neque explicabo ullam rerum architecto eveniet possimus voluptas officia tenetur delectus magni nisi labore quasi aperiam facilis commodi quidem obcaecati laborum tempora deserunt quo repellat sequi corrupti error optio hic consequuntur eius blanditiis modi atque maiores temporibus eligendi alias;quis;3
38;optio molestias ducimus quos facere magni est repudiandae aliquam adipisci repellat doloremque assumenda perferendis ut impedit labore quo sit ipsum amet nulla accusantium eum nostrum nam velit omnis maiores corrupti fuga libero itaque excepturi ea blanditiis temporibus voluptates corporis et reiciendis commodi dolores mollitia;libero;7
39;consequatur officia facilis praesentium alias a voluptatum magnam nihil quos corporis ad laudantium nemo commodi blanditiis inventore impedit eveniet saepe obcaecati animi molestiae laborum sunt culpa aliquid neque enim vero non fugit tenetur tempora ullam aliquam maxime cum rem ex ea;molestiae;0
40;autem modi doloremque nesciunt odit inventore tempore ratione quas reiciendis magnam distinctio illum sed iste pariatur error numquam illo debitis nobis optio ut laborum quos adipisci magni nisi nam officia possimus quisquam fugiat voluptates corrupti aliquid a enim sit vel deserunt aperiam ex cupiditate voluptatum delectus molestias quia dolore;culpa;9
41;sapiente quos ipsam nam quas tenetur ab at earum aperiam expedita vitae cum harum totam illum exercitationem neque nulla quasi dolore amet molestiae aliquid ad ducimus accusantium unde libero impedit magnam reprehenderit obcaecati esse laboriosam maiores inventore perferendis delectus sequi beatae illo repellat eos iste fuga voluptas magni fugiat est;vitae;10
42;voluptates obcaecati ratione sapiente vel quasi laboriosam ad officiis ut quod quis id minus corporis voluptatem sunt harum deleniti enim suscipit sit delectus architecto cumque a quidem facilis iste quo commodi expedita soluta doloremque eum illum sed excepturi veniam totam accusamus;harum;2
43;beatae omnis accusantium saepe doloribus ut nisi unde explicabo dignissimos illo consequuntur nulla fugiat accusamus minima voluptate illum vero eaque debitis repellat alias maxime qui cupiditate deleniti aliquid dolor velit iure natus provident earum numquam eum rem culpa;architecto;9
44;commodi doloribus possimus quasi laboriosam culpa qui eveniet quisquam autem fugiat maxime ratione odio ex non accusantium doloremque voluptatibus consequatur repellendus cumque obcaecati in ipsum eius facilis iusto magni magnam voluptates quis perspiciatis aliquid mollitia soluta ducimus odit placeat vel eaque beatae incidunt aliquam alias;reprehenderit;3
45;placeat quam consequatur eius voluptate voluptates unde cumque assumenda dolorem repellendus neque earum nihil fugit doloremque corrupti vitae ipsum fugiat ex itaque mollitia esse amet possimus odio recusandae a dolores ullam quasi modi dicta minima eum;aut;3
46;nulla perspiciatis libero sint quia provident officia voluptate asperiores tenetur tempora est nam iste nostrum iusto deleniti quo fuga explicabo eius rerum cumque quae voluptas quam pariatur numquam deserunt corporis consectetur maxime;dolore;4
47;minus unde adipisci neque vitae dolorem laudantium aliquam ea illo doloremque asperiores nam facere aut labore ex inventore nobis soluta nesciunt voluptatibus eaque corrupti fugiat reiciendis fugit amet nostrum molestiae nisi molestias quibusdam corporis sit rerum quaerat magni minima sint aliquid in voluptas nemo iste quasi autem voluptate;voluptatum;7
48;sed porro est quo veritatis tenetur error itaque eos dignissimos ad aspernatur eum sapiente qui quidem deleniti corrupti aut sint quasi ut similique minima ducimus dolorem incidunt facilis modi hic aliquam rem iure non distinctio expedita natus fugit minus;itaque;1
49;facere quasi voluptatem vitae natus autem alias blanditiis hic ea soluta ab et aspernatur deserunt adipisci reiciendis exercitationem sunt nesciunt laboriosam odio nisi delectus facilis harum ipsum molestiae earum molestias tempore aut excepturi suscipit non;quod;1
50;voluptatem eligendi veritatis minima odit ut adipisci architecto ipsam labore expedita cum laudantium assumenda magni ratione aspernatur ipsa mollitia est dolor magnam praesentium iste laboriosam vitae deleniti molestias illum reiciendis enim similique repellendus a cupiditate temporibus natus tempora laborum;impedit;2
\.


DROP TABLE IF EXISTS autorzy_pytan CASCADE;
CREATE TABLE autorzy_pytan (
    id_autora INT,
    id_pytania INT,
    PRIMARY KEY(id_autora, id_pytania),
    CONSTRAINT fk_autorzy_patan_uczestnicy
        FOREIGN KEY(id_autora)
            REFERENCES uczestnicy(id),
    CONSTRAINT fk_autorzy_pytan_pytania
        FOREIGN KEY(id_pytania)
            REFERENCES pytania(id)
);

COPY autorzy_pytan FROM STDIN DELIMITER ';' NULL 'null';
24;1
24;2
16;3
24;4
1;5
16;6
1;7
24;8
16;9
7;10
1;11
19;12
16;13
19;14
24;15
16;16
7;17
1;18
19;19
1;20
24;21
7;22
7;23
19;24
1;25
16;26
19;27
7;28
19;29
24;30
19;31
16;32
1;33
19;34
1;35
24;36
16;37
16;38
24;39
7;40
19;41
19;42
16;43
1;44
19;45
19;46
7;47
24;48
19;49
24;50
\.

DROP TABLE IF EXISTS miejscowosci CASCADE;
CREATE TABLE miejscowosci (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(30) NOT NULL
);

COPY miejscowosci FROM STDIN DELIMITER ',' NULL 'null';
0,Łaziska Górne
1,Zambrów
2,Oława
3,Stargard Szczeciński
4,Koszalin
\.


DROP TABLE IF EXISTS adresy CASCADE;
CREATE TABLE adresy (
    id SERIAL PRIMARY KEY,
    miejscowosc INT NOT NULL,
    CONSTRAINT fk_miejscowosci_adresy
        FOREIGN KEY(miejscowosc)
            REFERENCES miejscowosci(id),
    ulica VARCHAR,
    kod_pocztowy VARCHAR(6) NOT NULL,
    numer_budynku VARCHAR(6),
    numer_mieszkania VARCHAR(6)
);

COPY adresy FROM STDIN DELIMITER ',' NULL 'null';
0,0,Tęczowa,38-070,33,94
1,1,Pałacowa,16-985,30,63
2,2,Wiklinowa,89-563,19,29
3,3,Dąbrowskiej,36-443,20,17
4,4,Chopina,26-751,36,24
\.


DROP TABLE IF EXISTS turnieje CASCADE;
CREATE TABLE turnieje (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(30) NOT NULL,
    opis TEXT NOT NULL,
    data_startu DATE NOT NULL,
    data_konca DATE NOT NULL,
    id_adresu INT,
    CONSTRAINT fk_turnieje_adresy
        FOREIGN KEY(id_adresu)
            REFERENCES adresy(id),
    CHECK (data_konca > data_startu)
);

COPY turnieje FROM STDIN DELIMITER ';' NULL 'null';
0;Letni turniej Krakowa;et natus rem illo voluptates;2003-10-1;2003-10-3;1
1;Mistrzostwa Polski;eaque aliquid fugit ratione eveniet;2014-09-22;2014-09-26;0
\.

DROP TABLE IF EXISTS typy_kar CASCADE;
CREATE TABLE typy_kar (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(20) UNIQUE NOT NULL
);

COPY typy_kar FROM STDIN DELIMITER ',' NULL 'null';
0,spoznienie
1,zle zachowanie
2,niesportywna gra
\.

DROP TABLE IF EXISTS zespoly CASCADE;
CREATE TABLE zespoly(
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(20) NOT NULL,
    data_zalozenia DATE NOT NULL DEFAULT CURRENT_DATE,
    data_likwidacji DATE,
    CHECK (data_likwidacji > data_zalozenia)
);

COPY zespoly FROM STDIN DELIMITER ';' NULL 'null';
0;Natus Vincere;2000-02-25;null
1;Troche matematykow;2018-04-20;null
2;Reakcja lancuchowa;2010-03-17;null
3;Wszechmocne jajko;2015-11-11;null
4;Klasyczni klauny;1990-02-28;1999-07-26
\.

DROP TABLE IF EXISTS "role" CASCADE;
CREATE TABLE role (
    id SERIAL PRIMARY KEY,
    nazwa VARCHAR(20) UNIQUE NOT NULL
);

COPY "role" FROM STDIN DELIMITER ' ' NULL 'null';
0 kapitan
1 uczestnik
2 trener
3 gracz_zapasowy
\.

DROP TABLE IF EXISTS sklady_w_zespolach CASCADE;
CREATE TABLE sklady_w_zespolach(
    id_osoby INT NOT NULL,
    id_zespolu INT NOT NULL,
    id_turnieju INT NOT NULL,
    rola INT NOT NULL,
    PRIMARY KEY(id_osoby, id_zespolu, id_turnieju),
    CONSTRAINT fk_sklady_w_zespolach_uczestnicy
        FOREIGN KEY(id_osoby)
            REFERENCES uczestnicy(id),
    CONSTRAINT fk_sklady_w_zespolach_zespoly
        FOREIGN KEY(id_zespolu)
            REFERENCES zespoly(id),
    CONSTRAINT fk_sklady_w_zespolach_rele
        FOREIGN KEY(rola)
            REFERENCES ROLE(id),
    CONSTRAINT fk_sklady_w_zespolach_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id)
);

COPY sklady_w_zespolach FROM STDIN DELIMITER ';' NULL 'null';
20;0;0;0
26;0;0;1
1;0;0;1
14;0;0;1
23;0;0;1
8;0;0;1
19;1;0;0
29;1;0;1
27;1;0;1
7;1;0;1
12;1;0;1
16;1;0;1
21;2;0;0
11;2;0;1
24;2;0;1
9;2;0;1
0;2;0;1
5;2;0;1
4;3;0;0
3;3;0;1
17;3;0;1
28;3;0;1
15;3;0;1
10;3;0;1
25;4;0;0
2;4;0;1
6;4;0;1
13;4;0;1
18;4;0;1
22;4;0;1
21;0;1;0
16;0;1;1
11;0;1;1
27;0;1;1
28;0;1;1
25;0;1;1
13;1;1;0
22;1;1;1
23;1;1;1
7;1;1;1
14;1;1;1
4;1;1;1
1;2;1;0
8;2;1;1
2;2;1;1
5;2;1;1
17;2;1;1
29;2;1;1
9;3;1;0
18;3;1;1
3;3;1;1
10;3;1;1
26;3;1;1
15;3;1;1
12;4;1;0
19;4;1;1
6;4;1;1
0;4;1;1
20;4;1;1
24;4;1;1
\.

DROP TABLE IF EXISTS kary_dla_zespolow CASCADE;
CREATE TABLE kary_dla_zespolow(
    -- PRIMARY KEY nie jest potrzebny
    -- bo po co? - tak nie ma potrzeby(po chwyli przemyślenia)
    typ_kary INT NOT NULL,
    id_zespolu INT NOT NULL,
    id_turnieju INT NOT NULL,
    CONSTRAINT fk_kary_dla_zespolow_typy_kar
        FOREIGN KEY(typ_kary)
            REFERENCES typy_kar(id),
    CONSTRAINT fk_kary_dla_zespolow_zespoly
        FOREIGN KEY(id_zespolu)
            REFERENCES zespoly(id),
    CONSTRAINT fk_kary_dla_zespolow_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id)
);

COPY kary_dla_zespolow FROM STDIN DELIMITER ';' NULL 'null';
2;2;0
1;2;0
0;4;1
\.

DROP TABLE IF EXISTS nagrody CASCADE;
CREATE TABLE nagrody(
    id SERIAL PRIMARY KEY,
    opis VARCHAR(100) UNIQUE NOT NULL
);

COPY nagrody FROM STDIN DELIMITER ',' NULL 'null';
0,peiniędzy
1,bilety do kina
2,nagroda od sponosorow
\.

DROP TABLE IF EXISTS nagrody_w_turniejach CASCADE;
CREATE TABLE nagrody_w_turniejach(
    id_nagrody INT NOT NULL,
    id_turnieju INT NOT NULL,
    miejsce INT NOT NULL,
    PRIMARY KEY(id_turnieju, miejsce),
    CONSTRAINT fk_nagrody_w_turniejach_nagrody
        FOREIGN KEY(id_nagrody)
            REFERENCES nagrody(id),
    CONSTRAINT fk_nagrody_w_turniejach_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id)
);

COPY nagrody_w_turniejach FROM STDIN DELIMITER ';' NULL 'null';
0;0;1
2;0;2
1;0;3
2;1;1
0;1;2
1;1;3
\.

DROP TABLE IF EXISTS zmiany CASCADE;
CREATE TABLE zmiany (
    -- Chyba nie jest portzebny primary key
    -- trzeba tylko trigger dodać
    id_turnieju INT NOT NULL,
    id_zchodzacego INT NOT NULL,
    id_wchodzacego INT NOT NULL,
    numer_pytania INT NOT NULL,
    CONSTRAINT fk_zmiany_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id),
    CONSTRAINT fk_zmiany_uczestnicy_zchodzacy
        FOREIGN KEY(id_zchodzacego)
            REFERENCES uczestnicy(id),
    CONSTRAINT fk_zmiany_uczestnicy_wchodzacy
        FOREIGN KEY(id_wchodzacego)
            REFERENCES uczestnicy(id)
);

COPY zmiany FROM STDIN DELIMITER ';' NULL 'null';
\.

DROP TABLE IF EXISTS poprawne_odpowiedzi CASCADE;
CREATE TABLE poprawne_odpowiedzi(
    id_turnieju INT NOT NULL,
    id_zespolu INT NOT NULL,
    numer_pytania INT NOT NULL,
    PRIMARY KEY(id_turnieju, id_zespolu, numer_pytania),
    CONSTRAINT fk_poprawne_odpowiedzi_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id),
    CONSTRAINT fk_poprawne_odpowiedzi_zespoly
        FOREIGN KEY(id_zespolu)
            REFERENCES zespoly(id)
);

COPY poprawne_odpowiedzi FROM STDIN DELIMITER ';' NULL 'null';
0;0;4
0;0;8
0;0;9
0;0;11
0;0;14
0;0;15
0;0;16
0;0;18
0;0;19
0;0;24
0;0;26
0;0;27
0;0;28
0;0;29
0;0;30
0;0;31
0;0;32
0;0;33
0;0;34
0;0;35
0;1;1
0;1;2
0;1;3
0;1;6
0;1;7
0;1;9
0;1;12
0;1;16
0;1;17
0;1;19
0;1;21
0;1;25
0;1;29
0;1;32
0;1;33
0;1;34
0;2;1
0;2;6
0;2;11
0;2;13
0;2;14
0;2;15
0;2;17
0;2;21
0;2;22
0;2;23
0;2;24
0;2;25
0;2;26
0;2;27
0;2;31
0;2;32
0;2;33
0;2;35
0;2;36
0;3;6
0;3;7
0;3;8
0;3;9
0;3;10
0;3;16
0;3;17
0;3;19
0;3;20
0;3;21
0;3;23
0;3;25
0;3;26
0;3;27
0;3;32
0;3;33
0;3;35
0;4;2
0;4;9
0;4;14
0;4;15
0;4;17
0;4;22
0;4;23
0;4;25
0;4;26
0;4;30
0;4;31
0;4;33
0;4;36
1;0;1
1;0;3
1;0;4
1;0;9
1;0;10
1;0;11
1;0;12
1;0;13
1;1;1
1;1;2
1;1;3
1;1;5
1;1;6
1;1;9
1;1;11
1;1;12
1;1;14
1;2;1
1;2;3
1;2;4
1;2;5
1;2;6
1;2;12
1;2;13
1;3;3
1;3;5
1;3;6
1;3;7
1;3;11
1;3;13
1;3;14
1;4;7
1;4;9
1;4;10
\.

DROP TABLE IF EXISTS organizacja CASCADE;
CREATE TABLE organizacja(
    id_turnieju INT PRIMARY KEY,
    sedzia_glowny INT,
    organizator VARCHAR(30) NOT NULL,
    CONSTRAINT fk_organizacja_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id),
    CONSTRAINT fk_organizacja_uczestnicy
        FOREIGN KEY(sedzia_glowny)
            REFERENCES uczestnicy(id)
);


COPY organizacja FROM STDIN DELIMITER ';' NULL 'null';
0;31;UJ
1;30;UE
\.

DROP TABLE IF EXISTS pytania_na_turniejach CASCADE;
CREATE TABLE pytania_na_turniejach(
    id_turnieju INT NOT NULL,
    id_pytania INT NOT NULL,
    PRIMARY KEY(id_turnieju, id_pytania),
    numer_pytania INT NOT NULL,
    CONSTRAINT fk_pytania_na_turniejach_turnieje
        FOREIGN KEY(id_turnieju)
            REFERENCES turnieje(id),
    CONSTRAINT fk_pytania_na_turniejach_pytania
        FOREIGN KEY(id_pytania)
            REFERENCES pytania(id),
    CHECK ((numer_pytania > 0) AND (numer_pytania <= 36))
);

COPY pytania_na_turniejach FROM STDIN DELIMITER ';' NULL 'null';
0;1;1
0;2;2
0;3;3
0;4;4
0;5;5
0;6;6
0;7;7
0;8;8
0;9;9
0;10;10
0;11;11
0;12;12
0;13;13
0;14;14
0;15;15
0;16;16
0;17;17
0;18;18
0;19;19
0;20;20
0;21;21
0;22;22
0;23;23
0;24;24
0;25;25
0;26;26
0;27;27
0;28;28
0;29;29
0;30;30
0;31;31
0;32;32
0;33;33
0;34;34
0;35;35
0;36;36
1;37;1
1;38;2
1;39;3
1;40;4
1;41;5
1;42;6
1;43;7
1;44;8
1;45;9
1;46;10
1;47;11
1;48;12
1;49;13
1;50;14
\.

commit;

-- Dodanie triggerów do
-- pytania_na_turniejach
begin;
-- Głowne zasady jak dodawać/updatować/usuwać pytania:
--    (numer - kolejność grania tego pytania na turnieju)
-- 1. Nie można dodać pytania, które już było na jakim kołwiek turnieju
-- 2. Dodawać można tylko pytanie o kolejnym numerze
-- 3. Przy update'cie nie może powstać sytuacja, że dwa pytania mają ten sam numer
-- 4. Przy usunięciu pytania, jeśli na turnieju obecnie nie ma pytania z taką kolejnością, 
--    to numery wszystkich pytań o wyższych numerach niż usunięte, zmniejszamy o 1

CREATE OR REPLACE FUNCTION sprawdz_czy_pytanie_juz_bylo_na_turnieju()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.id_pytania IN (SELECT id_pytania FROM pytania_na_turniejach) THEN
        RAISE EXCEPTION 'Pytanie o id % było już grane. Nie można go dodac do turnieju %', NEW.id_pytania, NEW.id_turnieju;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_juz_granych_pytan ON pytania_na_turniejach;
CREATE TRIGGER sprawdzanie_juz_granych_pytan BEFORE INSERT OR UPDATE ON pytania_na_turniejach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_pytanie_juz_bylo_na_turnieju();

-- Jesli jego numer jest conajwyzej od delta wyżej niż maksymalny
CREATE OR REPLACE FUNCTION sprawdz_czy_pytanie_ma_poprawny_numer()
RETURNS TRIGGER
AS $$
BEGIN
    IF(TG_NARGS != 1) THEN
        RAISE EXCEPTION 'Niepoprawna ilość argumantów';
    END IF;

    IF(pg_typeof(TG_ARGV[0]) != 'integer') THEN
        RAISE EXCEPTION 'Niepoprawny typ argumentu';
    END IF;

    IF NEW.numer_pytania != (
        SELECT COALESCE(MAX(numer_pytania), 0)
        FROM pytania_na_turniejach 
        WHERE id_turnieju = NEW.id_turnieju
        GROUP BY id_turnieju) + TG_ARGV[0]
    THEN
        RAISE EXCEPTION 'Pytanie o id % na turnieju % ma niepoprawny numer %', NEW.id_pytania, NEW.id_turnieju, NEW.numer_pytania;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_numeru_pytania ON pytania_na_turniejach;
CREATE TRIGGER sprawdzanie_numeru_pytania BEFORE INSERT ON pytania_na_turniejach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_pytanie_ma_poprawny_numer(1);


CREATE OR REPLACE FUNCTION sprawdz_czy_pytanie_ma_prawie_unikalny_numer()
RETURNS TRIGGER
AS $$
BEGIN
    IF (SELECT COUNT(numer_pytania) 
        FROM pytania_na_turniejach 
        WHERE id_turnieju = NEW.id_turnieju 
        AND numer_pytania = NEW.numer_pytania) > 1 
    THEN
        RAISE EXCEPTION 'Pytanie o id % na turnieju % ma niepoprawny numer %', NEW.id_pytania, NEW.id_turnieju, NEW.numer_pytania;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS sprawdzanie_prawie_unikalnosci_numeru_pytania ON pytania_na_turniejach;
CREATE TRIGGER sprawdzanie_prawie_unikalnosci_numeru_pytania BEFORE UPDATE ON pytania_na_turniejach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_pytanie_ma_prawie_unikalny_numer();

DROP TRIGGER IF EXISTS sprawdzanie_maksymalnego_numeru_pytania ON pytania_na_turniejach;
CREATE TRIGGER sprawdzanie_maksymalnego_numeru_pytania BEFORE UPDATE ON pytania_na_turniejach
FOR EACH ROW EXECUTE PROCEDURE sprawdz_czy_pytanie_ma_poprawny_numer(0);

commit;