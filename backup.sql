--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: aircrafts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aircrafts (
    aircraft_id integer NOT NULL,
    airline_id integer,
    model character varying(50) NOT NULL,
    manufacturer character varying(50) NOT NULL,
    capacity integer,
    range_km integer,
    status character varying(20) DEFAULT 'Active'::character varying,
    CONSTRAINT aircrafts_capacity_check CHECK ((capacity > 0)),
    CONSTRAINT aircrafts_range_km_check CHECK ((range_km > 0)),
    CONSTRAINT aircrafts_status_check CHECK (((status)::text = ANY ((ARRAY['Active'::character varying, 'Maintenance'::character varying, 'Retired'::character varying])::text[])))
);


ALTER TABLE public.aircrafts OWNER TO postgres;

--
-- Name: aircrafts_aircraft_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.aircrafts_aircraft_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.aircrafts_aircraft_id_seq OWNER TO postgres;

--
-- Name: aircrafts_aircraft_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.aircrafts_aircraft_id_seq OWNED BY public.aircrafts.aircraft_id;


--
-- Name: airlines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airlines (
    airline_id integer NOT NULL,
    airline_name text NOT NULL,
    airline_iata character varying(3) NOT NULL,
    airline_icao character varying(4) NOT NULL,
    country text
);


ALTER TABLE public.airlines OWNER TO postgres;

--
-- Name: airlines_airline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.airlines_airline_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.airlines_airline_id_seq OWNER TO postgres;

--
-- Name: airlines_airline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.airlines_airline_id_seq OWNED BY public.airlines.airline_id;


--
-- Name: airport_distances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.airport_distances (
    origin_airport character varying(5) NOT NULL,
    destination_airport character varying(5) NOT NULL,
    distance_km numeric(10,2) NOT NULL
);


ALTER TABLE public.airport_distances OWNER TO postgres;

--
-- Name: cabin_crew_standards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cabin_crew_standards (
    aircraft_model text NOT NULL,
    chief_count integer,
    regular_count integer,
    chef_count integer
);


ALTER TABLE public.cabin_crew_standards OWNER TO postgres;

--
-- Name: cabin_crews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cabin_crews (
    attendant_id integer NOT NULL,
    full_name text NOT NULL,
    age integer,
    gender character varying(10),
    nationality text,
    known_languages text[],
    attendant_type character varying(10),
    vehicle_restrictions text[],
    CONSTRAINT cabin_crews_age_check CHECK ((age >= 18)),
    CONSTRAINT cabin_crews_attendant_type_check CHECK (((attendant_type)::text = ANY ((ARRAY['chief'::character varying, 'regular'::character varying, 'chef'::character varying])::text[]))),
    CONSTRAINT cabin_crews_gender_check CHECK (((gender)::text = ANY ((ARRAY['Male'::character varying, 'Female'::character varying, 'Other'::character varying])::text[])))
);


ALTER TABLE public.cabin_crews OWNER TO postgres;

--
-- Name: cabin_crews_attendant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cabin_crews_attendant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cabin_crews_attendant_id_seq OWNER TO postgres;

--
-- Name: cabin_crews_attendant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cabin_crews_attendant_id_seq OWNED BY public.cabin_crews.attendant_id;


--
-- Name: flight_crews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flight_crews (
    flight_id integer NOT NULL,
    attendant_id integer NOT NULL,
    role character varying(20),
    CONSTRAINT flight_crews_role_check CHECK (((role)::text = ANY ((ARRAY['chief'::character varying, 'regular'::character varying, 'chef'::character varying])::text[])))
);


ALTER TABLE public.flight_crews OWNER TO postgres;

--
-- Name: flight_pilot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flight_pilot (
    id integer NOT NULL,
    flight_id integer,
    pilot_id integer,
    role character varying(20),
    CONSTRAINT flight_pilot_role_check CHECK (((role)::text = ANY ((ARRAY['Captain'::character varying, 'First Officer'::character varying, 'Relief Pilot'::character varying])::text[])))
);


ALTER TABLE public.flight_pilot OWNER TO postgres;

--
-- Name: flight_pilot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.flight_pilot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.flight_pilot_id_seq OWNER TO postgres;

--
-- Name: flight_pilot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.flight_pilot_id_seq OWNED BY public.flight_pilot.id;


--
-- Name: flights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flights (
    flight_id integer NOT NULL,
    airline_id integer,
    flight_number character varying(10) NOT NULL,
    origin_airport character varying(3) NOT NULL,
    destination_airport character varying(3) NOT NULL,
    departure_time timestamp without time zone NOT NULL,
    arrival_time timestamp without time zone NOT NULL,
    aircraft_type character varying(50),
    status character varying(20) DEFAULT 'Scheduled'::character varying,
    duration interval GENERATED ALWAYS AS ((arrival_time - departure_time)) STORED,
    aircraft_id integer,
    distance_km numeric(10,2),
    CONSTRAINT flights_status_check CHECK (((status)::text = ANY ((ARRAY['Scheduled'::character varying, 'Boarding'::character varying, 'Departed'::character varying, 'Delayed'::character varying, 'Cancelled'::character varying, 'Arrived'::character varying])::text[])))
);


ALTER TABLE public.flights OWNER TO postgres;

--
-- Name: flights_flight_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.flights_flight_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.flights_flight_id_seq OWNER TO postgres;

--
-- Name: flights_flight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.flights_flight_id_seq OWNED BY public.flights.flight_id;


--
-- Name: passengers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passengers (
    passenger_id integer NOT NULL,
    flight_number character varying,
    full_name character varying NOT NULL,
    age integer,
    gender character varying,
    nationality character varying,
    seat_type character varying,
    seat_number character varying,
    parent_id integer,
    affiliated_passenger_ids integer[],
    created_at timestamp without time zone
);


ALTER TABLE public.passengers OWNER TO postgres;

--
-- Name: passengers_passenger_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.passengers_passenger_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passengers_passenger_id_seq OWNER TO postgres;

--
-- Name: passengers_passenger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.passengers_passenger_id_seq OWNED BY public.passengers.passenger_id;


--
-- Name: pilot_standards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pilot_standards (
    id integer NOT NULL,
    aircraft_model character varying(50) NOT NULL,
    captains integer NOT NULL,
    first_officers integer NOT NULL,
    relief_pilots integer NOT NULL
);


ALTER TABLE public.pilot_standards OWNER TO postgres;

--
-- Name: pilot_standards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pilot_standards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pilot_standards_id_seq OWNER TO postgres;

--
-- Name: pilot_standards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pilot_standards_id_seq OWNED BY public.pilot_standards.id;


--
-- Name: pilots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pilots (
    pilot_id integer NOT NULL,
    full_name text NOT NULL,
    age integer,
    gender character varying(10),
    nationality text,
    license_level character varying(30),
    flight_hours integer,
    known_aircrafts text[],
    CONSTRAINT pilots_age_check CHECK ((age >= 21)),
    CONSTRAINT pilots_license_level_check CHECK (((license_level)::text = ANY ((ARRAY['Captain'::character varying, 'First Officer'::character varying, 'Relief Pilot'::character varying])::text[])))
);


ALTER TABLE public.pilots OWNER TO postgres;

--
-- Name: pilots_pilot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pilots_pilot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pilots_pilot_id_seq OWNER TO postgres;

--
-- Name: pilots_pilot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pilots_pilot_id_seq OWNED BY public.pilots.pilot_id;


--
-- Name: aircrafts aircraft_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircrafts ALTER COLUMN aircraft_id SET DEFAULT nextval('public.aircrafts_aircraft_id_seq'::regclass);


--
-- Name: airlines airline_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines ALTER COLUMN airline_id SET DEFAULT nextval('public.airlines_airline_id_seq'::regclass);


--
-- Name: cabin_crews attendant_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cabin_crews ALTER COLUMN attendant_id SET DEFAULT nextval('public.cabin_crews_attendant_id_seq'::regclass);


--
-- Name: flight_pilot id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight_pilot ALTER COLUMN id SET DEFAULT nextval('public.flight_pilot_id_seq'::regclass);


--
-- Name: flights flight_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights ALTER COLUMN flight_id SET DEFAULT nextval('public.flights_flight_id_seq'::regclass);


--
-- Name: passengers passenger_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passengers ALTER COLUMN passenger_id SET DEFAULT nextval('public.passengers_passenger_id_seq'::regclass);


--
-- Name: pilot_standards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pilot_standards ALTER COLUMN id SET DEFAULT nextval('public.pilot_standards_id_seq'::regclass);


--
-- Name: pilots pilot_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pilots ALTER COLUMN pilot_id SET DEFAULT nextval('public.pilots_pilot_id_seq'::regclass);


--
-- Data for Name: aircrafts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aircrafts (aircraft_id, airline_id, model, manufacturer, capacity, range_km, status) FROM stdin;
5	1	Airbus A321neo	Airbus	200	7400	Active
6	1	Boeing 777-300ER	Boeing	396	13650	Active
7	1	Airbus A330-300	Airbus	277	11300	Maintenance
8	1	Boeing 737 MAX 8	Boeing	189	6570	Active
9	2	Airbus A320neo	Airbus	186	6500	Active
10	2	Boeing 737-800	Boeing	189	5435	Active
11	2	Airbus A321neo	Airbus	220	7400	Maintenance
12	2	Boeing 737 MAX 9	Boeing	220	6570	Active
13	3	Airbus A350-900	Airbus	293	15000	Active
14	3	Boeing 747-8	Boeing	467	14815	Active
15	3	Airbus A321neo	Airbus	200	7400	Maintenance
16	3	Airbus A320-200	Airbus	180	6100	Active
17	4	Airbus A380-800	Airbus	517	15200	Active
18	4	Boeing 777-200LR	Boeing	317	15700	Active
19	4	Boeing 787-9 Dreamliner	Boeing	296	14100	Active
20	4	Airbus A350-900	Airbus	300	15000	Maintenance
21	5	Airbus A350-1000	Airbus	350	16100	Active
22	5	Boeing 777-300ER	Boeing	396	13650	Active
23	5	Boeing 787-8 Dreamliner	Boeing	254	13620	Active
24	5	Airbus A321neo	Airbus	206	7400	Maintenance
25	6	Boeing 777-200ER	Boeing	336	13400	Active
26	6	Airbus A350-1000	Airbus	331	16100	Active
27	6	Boeing 787-9 Dreamliner	Boeing	216	14100	Active
28	6	Airbus A320neo	Airbus	180	6500	Maintenance
29	7	Airbus A350-900	Airbus	324	15000	Active
30	7	Boeing 787-9	Boeing	276	14100	Active
31	7	Airbus A220-300	Airbus	148	6200	Active
32	7	Airbus A330-200	Airbus	208	13450	Maintenance
33	8	Boeing 787-10 Dreamliner	Boeing	344	11900	Active
34	8	Boeing 737-800	Boeing	189	5435	Active
35	8	Embraer E195-E2	Embraer	132	4800	Active
36	8	Airbus A330-300	Airbus	277	11300	Maintenance
37	9	Airbus A380-800	Airbus	471	15200	Active
38	9	Boeing 777-300ER	Boeing	368	13650	Active
39	9	Airbus A350-900ULR	Airbus	161	18000	Active
40	9	Boeing 787-10 Dreamliner	Boeing	337	11900	Maintenance
41	10	Airbus A321neo	Airbus	194	7400	Active
42	10	Boeing 737-900ER	Boeing	180	5925	Active
43	10	Airbus A350-900	Airbus	306	15000	Active
44	10	Boeing 757-300	Boeing	234	7220	Maintenance
\.


--
-- Data for Name: airlines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.airlines (airline_id, airline_name, airline_iata, airline_icao, country) FROM stdin;
1	Turkish Airlines	TK	THY	Turkey
2	Pegasus Airlines	PC	PGT	Turkey
3	Lufthansa	LH	DLH	Germany
4	Emirates	EK	UAE	United Arab Emirates
5	Qatar Airways	QR	QTR	Qatar
6	British Airways	BA	BAW	United Kingdom
7	Air France	AF	AFR	France
8	KLM Royal Dutch Airlines	KL	KLM	Netherlands
9	Singapore Airlines	SQ	SIA	Singapore
10	Delta Air Lines	DL	DAL	United States
\.


--
-- Data for Name: airport_distances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.airport_distances (origin_airport, destination_airport, distance_km) FROM stdin;
IST	LHR	2494.70
IST	CDG	2218.90
IST	JFK	8047.50
IST	DXB	3030.00
SAW	AMS	2246.50
SAW	FRA	1905.10
SAW	LGW	2523.60
SAW	BCN	2278.70
FRA	IST	1905.10
FRA	LHR	643.70
FRA	CDG	878.50
FRA	AMS	224.50
DXB	JFK	12050.20
DXB	LHR	5545.80
DOH	CDG	5252.40
DOH	JFK	11015.20
LHR	IST	2494.70
LHR	FRA	643.70
CDG	IST	2218.90
CDG	LHR	344.00
\.


--
-- Data for Name: cabin_crew_standards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cabin_crew_standards (aircraft_model, chief_count, regular_count, chef_count) FROM stdin;
Airbus A321neo	1	4	0
Boeing 777-300ER	2	10	1
Airbus A330-300	1	8	1
Boeing 737 MAX 8	1	4	0
Airbus A320neo	1	4	0
Boeing 737-800	1	4	0
Boeing 737 MAX 9	1	5	0
Airbus A350-900	2	10	1
Boeing 747-8	2	14	2
Airbus A320-200	1	4	0
Airbus A380-800	3	18	2
Boeing 777-200LR	2	9	1
Boeing 787-9 Dreamliner	2	8	1
Airbus A350-1000	2	11	1
Boeing 787-8 Dreamliner	2	7	1
\.


--
-- Data for Name: cabin_crews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cabin_crews (attendant_id, full_name, age, gender, nationality, known_languages, attendant_type, vehicle_restrictions) FROM stdin;
1	Makayla Rivas	34	Male	Belgium	{English,Japanese}	regular	{"Boeing 747-8","Airbus A320-200","Airbus A330-300","Boeing 787-8 Dreamliner"}
2	Lisa Howell	47	Female	Brunei Darussalam	{English}	chef	{"Airbus A321neo","Airbus A320-200","Boeing 737-800"}
3	Susan Villanueva	29	Male	Saint Martin	{English,Japanese}	regular	{"Boeing 787-9 Dreamliner","Airbus A330-300","Boeing 777-300ER","Boeing 777-200LR"}
4	John Jackson	49	Female	Korea	{English,Turkish}	regular	{"Boeing 787-9 Dreamliner","Boeing 777-300ER"}
5	Joshua Serrano	25	Male	China	{English,Arabic}	regular	{"Airbus A350-1000","Airbus A380-800","Boeing 787-9 Dreamliner"}
6	Lindsey Ho	42	Female	Maldives	{English,French}	chef	{"Boeing 777-300ER","Boeing 787-8 Dreamliner"}
7	Jack Hodges	35	Male	Antarctica (the territory South of 60 deg S)	{English,German}	regular	{"Boeing 737 MAX 8","Airbus A350-1000","Airbus A350-900","Boeing 737 MAX 9"}
8	Kathleen Graham	31	Male	Cuba	{English,French}	chef	{"Boeing 737 MAX 8","Airbus A350-1000","Boeing 777-300ER","Boeing 747-8"}
9	Marissa Walker	50	Male	Ireland	{English,Turkish}	chef	{"Airbus A350-900","Boeing 737 MAX 9"}
10	Melissa Allen	35	Female	Ghana	{English,Japanese}	regular	{"Boeing 747-8","Boeing 737-800"}
11	Maria Martinez	39	Male	Dominica	{English,German}	regular	{"Boeing 747-8","Airbus A350-1000"}
12	Anna Williams	26	Female	Hong Kong	{English,German}	regular	{"Boeing 787-8 Dreamliner","Boeing 737 MAX 9","Airbus A330-300","Airbus A321neo"}
13	Angela Munoz	38	Female	Kiribati	{English,Spanish}	regular	{"Boeing 787-9 Dreamliner","Airbus A350-1000","Boeing 737-800","Boeing 747-8"}
14	Cassandra Wells	34	Male	Tajikistan	{English,Japanese}	regular	{"Boeing 787-8 Dreamliner","Boeing 777-300ER","Boeing 737 MAX 8"}
15	Sierra Fisher	31	Female	Syrian Arab Republic	{English,Turkish}	chef	{"Boeing 737 MAX 8","Boeing 787-8 Dreamliner","Boeing 737-800"}
16	Amanda Patterson	47	Female	Ethiopia	{English,Japanese}	regular	{"Airbus A330-300","Boeing 777-200LR","Boeing 787-8 Dreamliner","Boeing 787-9 Dreamliner"}
17	Amanda Morgan	48	Male	Sri Lanka	{English,German}	regular	{"Boeing 777-300ER","Airbus A350-1000","Boeing 747-8"}
18	Jeffery Greer	26	Male	Lithuania	{English,Turkish}	chef	{"Airbus A380-800","Boeing 737 MAX 8","Boeing 737-800"}
19	Travis Mcbride	30	Male	Netherlands Antilles	{English,Spanish}	regular	{"Boeing 787-9 Dreamliner","Airbus A321neo","Boeing 737-800"}
20	Daniel Frazier	29	Female	Suriname	{English}	regular	{"Boeing 737 MAX 9","Boeing 787-8 Dreamliner","Boeing 787-9 Dreamliner"}
21	Yvonne Thomas	29	Female	Chad	{English,French}	regular	{"Airbus A321neo","Boeing 747-8","Boeing 787-9 Dreamliner"}
22	Jennifer Payne	28	Female	Serbia	{English,Hindi}	regular	{"Airbus A320-200","Boeing 737 MAX 9","Boeing 777-200LR","Boeing 737-800"}
23	Scott House	31	Male	Guatemala	{English,Italian}	regular	{"Boeing 777-200LR","Airbus A350-900","Boeing 737 MAX 8","Boeing 737-800"}
24	Aaron Beck	39	Female	Equatorial Guinea	{English,Turkish}	regular	{"Airbus A321neo","Airbus A330-300","Boeing 747-8"}
25	Anne Davenport	38	Female	Saint Kitts and Nevis	{English,Hindi}	regular	{"Airbus A350-1000","Airbus A350-900","Airbus A320neo","Boeing 747-8"}
26	Sherry Oliver	43	Female	Tonga	{English,German}	chef	{"Airbus A320neo","Airbus A380-800","Boeing 737 MAX 9","Boeing 787-8 Dreamliner"}
27	Jennifer Vega	25	Male	Malaysia	{English,Japanese}	chef	{"Boeing 787-9 Dreamliner","Airbus A320-200"}
28	Matthew Avila	25	Female	Cayman Islands	{English,German}	regular	{"Airbus A350-900","Airbus A350-1000","Boeing 787-8 Dreamliner","Boeing 737 MAX 8"}
29	Veronica Boone	41	Male	Tanzania	{English,Spanish}	chef	{"Boeing 737 MAX 9","Airbus A350-900","Airbus A380-800"}
30	Michele Kirby	47	Female	Tokelau	{English,German}	regular	{"Airbus A321neo","Boeing 737 MAX 8","Boeing 747-8"}
31	Rachel Jimenez	32	Male	Cayman Islands	{English,Japanese}	regular	{"Airbus A350-1000","Boeing 747-8","Boeing 737 MAX 8"}
32	Gerald Bullock	26	Male	Iraq	{English,Arabic}	chief	{"Boeing 737 MAX 8","Boeing 787-8 Dreamliner","Airbus A350-1000","Airbus A350-900"}
33	Dean Baldwin	50	Male	Bhutan	{English,Spanish}	regular	{"Boeing 787-9 Dreamliner","Boeing 787-8 Dreamliner","Airbus A380-800","Boeing 747-8"}
34	Paul Dennis	44	Female	Israel	{English,Italian}	regular	{"Boeing 737-800","Boeing 777-300ER"}
35	Brandi Cameron	40	Female	Antigua and Barbuda	{English,Arabic}	regular	{"Boeing 777-300ER","Boeing 737 MAX 8","Boeing 747-8"}
36	Daniel Jones	44	Female	Afghanistan	{English,Turkish}	regular	{"Boeing 737 MAX 9","Airbus A321neo"}
37	Jeremy Herman	42	Male	Madagascar	{English,Arabic}	regular	{"Airbus A321neo","Boeing 747-8"}
38	Ian Avery	38	Female	Papua New Guinea	{English,Arabic}	chef	{"Airbus A380-800","Boeing 737-800","Airbus A330-300"}
39	Michael Hall	46	Female	Guyana	{English,Spanish}	regular	{"Boeing 737 MAX 8","Airbus A350-1000","Boeing 737 MAX 9"}
40	Kenneth Williams	40	Male	Qatar	{English,Italian}	regular	{"Airbus A380-800","Boeing 737-800","Airbus A330-300","Boeing 787-8 Dreamliner"}
41	Alexander Cardenas	46	Male	French Southern Territories	{English,Japanese}	regular	{"Airbus A330-300","Boeing 737 MAX 8","Boeing 777-300ER"}
42	Tracy Gibson	48	Female	Cayman Islands	{English}	regular	{"Airbus A320-200","Airbus A380-800"}
43	Adrian Klein	42	Female	Canada	{English,Arabic}	regular	{"Airbus A380-800","Boeing 737 MAX 8","Boeing 747-8"}
44	Kiara Costa	32	Male	Saint Pierre and Miquelon	{English,Spanish}	regular	{"Airbus A320neo","Boeing 777-300ER","Airbus A380-800"}
45	Andrea Pennington	39	Male	Singapore	{English,Japanese}	chief	{"Airbus A380-800","Boeing 737 MAX 8","Boeing 777-200LR"}
46	Gerald Mcgrath	43	Male	Netherlands Antilles	{English,Turkish}	regular	{"Airbus A380-800","Boeing 747-8"}
47	Matthew Haynes	28	Female	Saint Helena	{English,Japanese}	chef	{"Boeing 737 MAX 9","Airbus A350-900","Airbus A320neo","Boeing 787-9 Dreamliner"}
48	Jerry Holt	45	Female	Rwanda	{English,German}	regular	{"Boeing 747-8","Airbus A320neo","Boeing 737-800"}
49	Bryan Sweeney	41	Male	Costa Rica	{English,Spanish}	regular	{"Airbus A380-800","Airbus A320neo"}
50	Christopher Peterson	29	Female	Brazil	{English,Italian}	chef	{"Boeing 737 MAX 9","Airbus A321neo"}
51	Nicole Gomez	26	Female	Mexico	{English,Spanish}	regular	{"Airbus A321neo","Boeing 787-9 Dreamliner","Airbus A320neo"}
52	David Dickerson	35	Male	Falkland Islands (Malvinas)	{English,French}	regular	{"Boeing 737 MAX 9","Boeing 777-300ER","Airbus A320-200","Boeing 777-200LR"}
53	Lori Gray	33	Female	Morocco	{English,German}	regular	{"Boeing 777-300ER","Boeing 737 MAX 8","Airbus A321neo"}
54	Ashley Ritter	39	Female	Moldova	{English,French}	regular	{"Airbus A350-1000","Boeing 787-9 Dreamliner","Airbus A320neo","Airbus A380-800"}
55	Fernando Williams	47	Male	Wallis and Futuna	{English,Turkish}	regular	{"Boeing 787-9 Dreamliner","Airbus A320neo","Boeing 737 MAX 8"}
56	Melinda Boyd	38	Female	Libyan Arab Jamahiriya	{English,Spanish}	regular	{"Airbus A330-300","Boeing 777-200LR","Boeing 747-8","Airbus A380-800"}
57	Christine Martinez	40	Male	Kazakhstan	{English,Turkish}	regular	{"Boeing 737 MAX 9","Boeing 777-200LR","Boeing 747-8"}
58	Vincent Gomez	32	Male	Guadeloupe	{English,Spanish}	regular	{"Airbus A330-300","Boeing 737-800","Airbus A350-900"}
59	Nicole Rodriguez	36	Female	Turkmenistan	{English,French}	chief	{"Airbus A350-1000","Boeing 777-300ER","Boeing 737 MAX 8","Airbus A321neo"}
60	Linda Dawson	40	Male	Monaco	{English,Japanese}	regular	{"Airbus A380-800","Airbus A320neo","Airbus A330-300","Airbus A350-900"}
61	Thomas Sampson	49	Female	Malawi	{English,French}	regular	{"Boeing 737 MAX 9","Boeing 787-8 Dreamliner","Airbus A320neo"}
62	Cassandra Mosley	38	Female	Vietnam	{English,Arabic}	chef	{"Boeing 737 MAX 9","Boeing 787-9 Dreamliner","Boeing 737-800","Boeing 747-8"}
63	Sophia Chambers	37	Male	Guadeloupe	{English,Japanese}	regular	{"Airbus A321neo","Boeing 777-300ER"}
64	Amanda Johnson	44	Female	Tanzania	{English,Italian}	chief	{"Boeing 787-8 Dreamliner","Airbus A380-800","Airbus A350-900"}
65	Leah Bentley	38	Male	Saudi Arabia	{English,Turkish}	chef	{"Airbus A320neo","Boeing 777-300ER","Airbus A320-200"}
66	Zachary Rodriguez	48	Male	Argentina	{English}	regular	{"Airbus A380-800","Airbus A321neo","Airbus A320neo"}
67	Daniel Washington	37	Female	Argentina	{English,Arabic}	regular	{"Airbus A330-300","Airbus A320-200"}
68	Tamara Cruz	28	Male	Israel	{English,Japanese}	chief	{"Airbus A350-900","Boeing 777-200LR","Airbus A380-800"}
69	Tabitha Torres	41	Female	San Marino	{English,Arabic}	regular	{"Airbus A330-300","Airbus A320neo","Boeing 737-800"}
70	Matthew Garcia	49	Female	Gambia	{English}	chef	{"Airbus A320neo","Boeing 777-200LR","Boeing 737-800"}
71	Omar Kelly	39	Male	Paraguay	{English,French}	regular	{"Boeing 747-8","Boeing 787-8 Dreamliner","Airbus A320neo"}
72	Tara Warner DDS	26	Female	Ghana	{English,Turkish}	regular	{"Airbus A320-200","Boeing 787-8 Dreamliner"}
73	Melinda Horn	32	Male	Spain	{English,Italian}	regular	{"Boeing 737-800","Airbus A350-900","Airbus A330-300","Airbus A320neo"}
74	Debbie Munoz	41	Male	Kenya	{English,Japanese}	regular	{"Airbus A350-900","Boeing 747-8"}
75	Bethany Burke	38	Female	Venezuela	{English}	regular	{"Airbus A320neo","Boeing 737 MAX 9","Boeing 737 MAX 8"}
76	Michael Riley	35	Female	Uganda	{English,Arabic}	regular	{"Airbus A320neo","Airbus A320-200","Boeing 747-8","Boeing 737-800"}
77	Jessica Ryan	26	Female	Denmark	{English,Turkish}	regular	{"Airbus A330-300","Boeing 787-9 Dreamliner","Airbus A320neo","Airbus A321neo"}
78	Benjamin Watkins	34	Female	Nigeria	{English,Spanish}	chief	{"Boeing 777-300ER","Boeing 777-200LR"}
79	John Fischer	39	Male	Lebanon	{English,Italian}	chef	{"Airbus A380-800","Airbus A350-1000","Boeing 737-800","Airbus A330-300"}
80	Stephen Salinas	46	Male	Niue	{English,Hindi}	regular	{"Airbus A320neo","Boeing 747-8","Boeing 777-200LR","Boeing 737-800"}
81	Beth Terrell	25	Female	Libyan Arab Jamahiriya	{English,Hindi}	regular	{"Boeing 737-800","Airbus A350-900"}
82	John Castro	38	Female	Sao Tome and Principe	{English,Italian}	regular	{"Airbus A380-800","Boeing 747-8","Airbus A350-900","Boeing 737 MAX 9"}
83	Beth Li	41	Female	El Salvador	{English,Japanese}	chief	{"Airbus A350-1000","Boeing 777-200LR","Airbus A350-900"}
84	Susan Gray	42	Female	Comoros	{English,Spanish}	regular	{"Boeing 737 MAX 9","Airbus A321neo","Airbus A350-1000","Airbus A380-800"}
85	Joshua Cobb	34	Male	Bulgaria	{English,Turkish}	regular	{"Airbus A350-1000","Boeing 737 MAX 8","Boeing 777-200LR","Airbus A321neo"}
86	Erica Oneill	46	Male	Antigua and Barbuda	{English}	regular	{"Airbus A350-900","Boeing 777-200LR","Boeing 737 MAX 9","Airbus A330-300"}
87	David Miller PhD	33	Male	Sweden	{English,Spanish}	regular	{"Airbus A350-1000","Airbus A320neo","Airbus A321neo","Boeing 737 MAX 8"}
88	Brittany Coleman	27	Male	Micronesia	{English,German}	regular	{"Airbus A380-800","Boeing 747-8","Boeing 777-300ER"}
89	Jerry Anderson	40	Male	Turkey	{English,Arabic}	chef	{"Boeing 777-300ER","Airbus A321neo","Airbus A320-200"}
90	Brandon Willis	41	Female	Taiwan	{English,German}	regular	{"Boeing 737 MAX 9","Airbus A321neo"}
91	Lori Wood	35	Female	Austria	{English,Arabic}	regular	{"Airbus A320-200","Boeing 787-8 Dreamliner","Boeing 777-300ER"}
92	Michael Baker	39	Male	Honduras	{English,Hindi}	chef	{"Airbus A321neo","Airbus A320neo","Airbus A350-900"}
93	Savannah Johnson	34	Female	Heard Island and McDonald Islands	{English,French}	regular	{"Airbus A320neo","Boeing 787-9 Dreamliner"}
94	James Stevenson	27	Female	Liechtenstein	{English,Hindi}	chief	{"Airbus A330-300","Boeing 737 MAX 9","Airbus A350-1000","Boeing 777-200LR"}
95	Ashley Bryant	26	Male	South Georgia and the South Sandwich Islands	{English}	regular	{"Boeing 777-200LR","Boeing 737-800"}
96	Rebecca Stone	49	Female	Canada	{English,Italian}	regular	{"Boeing 777-200LR","Airbus A321neo","Boeing 787-9 Dreamliner"}
97	James Perry	30	Female	Cyprus	{English,French}	regular	{"Boeing 737 MAX 8","Airbus A330-300"}
98	Lauren Parker	29	Female	Hungary	{English}	regular	{"Airbus A330-300","Airbus A350-1000","Boeing 747-8","Boeing 737-800"}
99	John Martinez	44	Female	Holy See (Vatican City State)	{English,French}	regular	{"Boeing 777-300ER","Boeing 787-9 Dreamliner","Boeing 787-8 Dreamliner","Boeing 747-8"}
100	Julie Coleman	35	Female	Singapore	{English,Italian}	chef	{"Boeing 737-800","Boeing 787-8 Dreamliner","Airbus A320-200"}
101	David Parker	28	Male	Guatemala	{English}	regular	{"Boeing 747-8","Airbus A330-300"}
102	Alex Schwartz	32	Female	Dominica	{English,Arabic}	regular	{"Boeing 777-200LR","Boeing 777-300ER"}
103	Heather Howard	39	Female	Tajikistan	{English,Spanish}	regular	{"Airbus A321neo","Boeing 777-200LR"}
104	Lisa Sanders	25	Female	United States of America	{English,Japanese}	regular	{"Airbus A350-1000","Airbus A321neo","Airbus A320-200"}
105	Kaitlyn Wade	43	Female	France	{English,Arabic}	regular	{"Airbus A350-1000","Airbus A350-900"}
106	Tiffany Valdez	50	Female	United Arab Emirates	{English,German}	regular	{"Boeing 777-300ER","Boeing 787-8 Dreamliner","Airbus A350-1000","Boeing 737 MAX 8"}
107	Tony Montoya	46	Female	Paraguay	{English,Arabic}	regular	{"Boeing 787-8 Dreamliner","Boeing 777-200LR"}
108	Alejandro Gutierrez	42	Male	Belgium	{English,Japanese}	chief	{"Airbus A320-200","Airbus A330-300"}
109	Laura Wright	28	Female	Russian Federation	{English,Japanese}	chef	{"Boeing 787-8 Dreamliner","Airbus A350-1000","Boeing 777-300ER"}
110	James Harvey	48	Male	American Samoa	{English,Spanish}	regular	{"Boeing 787-9 Dreamliner","Boeing 787-8 Dreamliner","Boeing 777-300ER"}
111	Kylie Watson	36	Female	Guyana	{English,German}	chef	{"Boeing 737-800","Boeing 787-8 Dreamliner"}
112	Martin Frye	33	Female	Luxembourg	{English}	regular	{"Airbus A320-200","Boeing 777-200LR","Airbus A350-900"}
113	Lori Lloyd	34	Male	Singapore	{English,Spanish}	regular	{"Airbus A350-900","Airbus A320-200"}
114	Isabella Ruiz	28	Male	Sao Tome and Principe	{English,French}	regular	{"Airbus A380-800","Airbus A350-900","Airbus A350-1000","Boeing 737 MAX 8"}
115	James Burton	44	Female	Italy	{English,Spanish}	chef	{"Boeing 737-800","Boeing 747-8"}
116	Dana Holland	27	Male	Kuwait	{English,Hindi}	regular	{"Airbus A320-200","Boeing 777-300ER","Boeing 777-200LR","Airbus A321neo"}
117	Tanner James	37	Male	Suriname	{English,German}	regular	{"Boeing 737 MAX 8","Airbus A321neo"}
118	Hector Knight	39	Male	El Salvador	{English,French}	regular	{"Boeing 737 MAX 8","Boeing 737-800","Boeing 777-200LR"}
119	Jesse Holt	37	Female	Mexico	{English,Italian}	regular	{"Airbus A380-800","Boeing 787-8 Dreamliner"}
120	Christy Marks	29	Female	China	{English,Japanese}	regular	{"Airbus A350-900","Boeing 737-800"}
\.


--
-- Data for Name: flight_crews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flight_crews (flight_id, attendant_id, role) FROM stdin;
62	59	chief
62	96	regular
62	116	regular
62	66	regular
62	63	regular
61	59	chief
61	78	chief
61	34	regular
61	106	regular
61	102	regular
61	99	regular
61	14	regular
61	110	regular
61	63	regular
61	3	regular
61	91	regular
61	44	regular
61	8	chef
63	108	chief
63	1	regular
63	58	regular
63	24	regular
63	77	regular
63	12	regular
63	40	regular
63	67	regular
63	56	regular
63	38	chef
64	45	chief
64	87	regular
64	55	regular
64	117	regular
64	28	regular
65	75	regular
65	44	regular
65	76	regular
65	55	regular
66	13	regular
66	118	regular
66	76	regular
66	34	regular
67	59	chief
67	63	regular
67	77	regular
67	24	regular
67	19	regular
68	94	chief
68	22	regular
68	75	regular
68	7	regular
68	86	regular
68	36	regular
69	83	chief
69	68	chief
69	120	regular
69	86	regular
69	74	regular
69	7	regular
69	25	regular
69	23	regular
69	28	regular
69	113	regular
69	114	regular
69	58	regular
69	29	chef
70	82	regular
70	46	regular
70	37	regular
70	101	regular
70	13	regular
70	17	regular
70	99	regular
70	25	regular
70	57	regular
70	21	regular
70	71	regular
70	43	regular
70	56	regular
70	76	regular
70	8	chef
70	62	chef
71	59	chief
71	21	regular
71	85	regular
71	96	regular
71	37	regular
72	108	chief
72	104	regular
72	72	regular
72	116	regular
72	52	regular
73	45	chief
73	64	chief
73	68	chief
73	42	regular
73	43	regular
73	40	regular
73	5	regular
73	66	regular
73	56	regular
73	54	regular
73	88	regular
73	114	regular
73	60	regular
73	33	regular
73	44	regular
73	84	regular
73	82	regular
73	49	regular
73	119	regular
73	46	regular
73	79	chef
73	29	chef
74	94	chief
74	45	chief
74	3	regular
74	96	regular
74	112	regular
74	116	regular
74	95	regular
74	23	regular
74	85	regular
74	118	regular
74	22	regular
74	70	chef
75	54	regular
75	33	regular
75	110	regular
75	19	regular
75	13	regular
75	20	regular
75	99	regular
75	16	regular
75	62	chef
76	64	chief
76	32	chief
76	25	regular
76	113	regular
76	105	regular
76	28	regular
76	112	regular
76	73	regular
76	7	regular
76	86	regular
76	74	regular
76	23	regular
76	47	chef
77	83	chief
77	94	chief
77	31	regular
77	84	regular
77	98	regular
77	17	regular
77	39	regular
77	11	regular
77	114	regular
77	25	regular
77	7	regular
77	5	regular
77	13	regular
77	8	chef
78	59	chief
78	78	chief
78	102	regular
78	91	regular
78	34	regular
78	44	regular
78	52	regular
78	17	regular
78	53	regular
78	3	regular
78	4	regular
78	35	regular
78	8	chef
79	64	chief
79	32	chief
79	40	regular
79	107	regular
79	14	regular
79	110	regular
79	16	regular
79	12	regular
79	91	regular
79	6	chef
80	59	chief
80	90	regular
80	116	regular
80	51	regular
80	37	regular
\.


--
-- Data for Name: flight_pilot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flight_pilot (id, flight_id, pilot_id, role) FROM stdin;
1	62	42	Captain
2	62	38	First Officer
3	61	13	Captain
4	61	44	Relief Pilot
5	63	11	Captain
6	63	22	First Officer
7	64	42	Captain
8	64	48	First Officer
9	65	48	First Officer
10	66	29	Captain
11	66	7	First Officer
12	67	16	Captain
13	67	40	First Officer
14	69	3	Captain
15	69	36	First Officer
16	69	25	Relief Pilot
17	70	3	Captain
18	70	31	Captain
19	70	15	First Officer
20	71	16	Captain
21	71	32	First Officer
22	73	39	Captain
23	73	13	Captain
24	75	45	Captain
25	75	33	Relief Pilot
26	76	3	Captain
27	76	15	First Officer
28	76	25	Relief Pilot
29	78	37	Captain
30	78	44	Relief Pilot
31	80	42	Captain
32	80	24	First Officer
\.


--
-- Data for Name: flights; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flights (flight_id, airline_id, flight_number, origin_airport, destination_airport, departure_time, arrival_time, aircraft_type, status, aircraft_id, distance_km) FROM stdin;
62	1	TK1002	IST	CDG	2025-10-12 09:00:00	2025-10-12 11:45:00	Airbus A321neo	Scheduled	5	2218.90
61	1	TK1001	IST	LHR	2025-10-12 08:00:00	2025-10-12 10:30:00	Boeing 777-300ER	Scheduled	6	2494.70
63	1	TK1003	IST	JFK	2025-10-12 10:00:00	2025-10-12 16:00:00	Airbus A330-300	Scheduled	7	8047.50
64	1	TK1004	IST	DXB	2025-10-12 11:00:00	2025-10-12 15:00:00	Boeing 737 MAX 8	Scheduled	8	3030.00
65	2	PC2001	SAW	AMS	2025-10-12 08:30:00	2025-10-12 11:15:00	Airbus A320neo	Scheduled	9	2246.50
66	2	PC2002	SAW	FRA	2025-10-12 09:15:00	2025-10-12 12:00:00	Boeing 737-800	Scheduled	10	1905.10
67	2	PC2003	SAW	LGW	2025-10-12 10:00:00	2025-10-12 12:45:00	Airbus A321neo	Scheduled	11	2523.60
68	2	PC2004	SAW	BCN	2025-10-12 11:00:00	2025-10-12 13:30:00	Boeing 737 MAX 9	Scheduled	12	2278.70
69	3	LH3001	FRA	IST	2025-10-12 07:00:00	2025-10-12 10:00:00	Airbus A350-900	Scheduled	13	1905.10
70	3	LH3002	FRA	LHR	2025-10-12 08:00:00	2025-10-12 09:30:00	Boeing 747-8	Scheduled	14	643.70
71	3	LH3003	FRA	CDG	2025-10-12 09:00:00	2025-10-12 10:15:00	Airbus A321neo	Scheduled	15	878.50
72	3	LH3004	FRA	AMS	2025-10-12 10:00:00	2025-10-12 11:15:00	Airbus A320-200	Scheduled	16	224.50
73	4	EK4001	DXB	JFK	2025-10-12 07:30:00	2025-10-12 14:00:00	Airbus A380-800	Scheduled	17	12050.20
74	4	EK4002	DXB	LHR	2025-10-12 08:30:00	2025-10-12 12:30:00	Boeing 777-200LR	Scheduled	18	5545.80
75	5	QR5001	DOH	CDG	2025-10-12 09:00:00	2025-10-12 14:00:00	Boeing 787-9 Dreamliner	Scheduled	19	5252.40
76	5	QR5002	DOH	JFK	2025-10-12 10:00:00	2025-10-12 16:00:00	Airbus A350-900	Scheduled	20	11015.20
77	6	BA6001	LHR	IST	2025-10-12 08:00:00	2025-10-12 12:00:00	Airbus A350-1000	Scheduled	21	2494.70
78	6	BA6002	LHR	FRA	2025-10-12 09:30:00	2025-10-12 11:00:00	Boeing 777-300ER	Scheduled	22	643.70
79	7	AF7001	CDG	IST	2025-10-12 07:45:00	2025-10-12 11:15:00	Boeing 787-8 Dreamliner	Scheduled	23	2218.90
80	7	AF7002	CDG	LHR	2025-10-12 08:30:00	2025-10-12 09:45:00	Airbus A321neo	Scheduled	24	344.00
\.


--
-- Data for Name: passengers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passengers (passenger_id, flight_number, full_name, age, gender, nationality, seat_type, seat_number, parent_id, affiliated_passenger_ids, created_at) FROM stdin;
1	TK1001	ogulcan	22	Male	Türkiye	Economy	9B	\N	\N	2025-10-22 01:55:59.261716
2	TK1002	ogulcan	13	Male	Türkiye	Economy	8C	\N	\N	2025-10-22 14:09:43.06833
3	LH3001	ayse	12	Male	Türkiye	Economy	5B	\N	\N	2025-10-22 16:01:35.263892
4	TK1001	ahmet	14	Male	Türkiye	Economy	18B	\N	\N	2025-10-22 19:06:11.9668
5	TK1002	ogulcan	56	Male	Türkiye	Economy	4F	\N	\N	2025-10-22 19:31:17.222431
\.


--
-- Data for Name: pilot_standards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pilot_standards (id, aircraft_model, captains, first_officers, relief_pilots) FROM stdin;
1	Airbus A321neo	1	1	0
2	Boeing 737 MAX 8	1	1	0
3	Airbus A350-900	1	1	1
4	Boeing 777-300ER	1	1	1
5	Airbus A380-800	2	2	1
6	Boeing 747-8	2	2	1
7	Boeing 787-9 Dreamliner	1	1	1
8	Airbus A330-300	1	1	0
9	Boeing 737-800	1	1	0
10	Airbus A320neo	1	1	0
\.


--
-- Data for Name: pilots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pilots (pilot_id, full_name, age, gender, nationality, license_level, flight_hours, known_aircrafts) FROM stdin;
1	John Carter	45	Male	UK	Captain	12500	{"Boeing 777-300ER","Boeing 787-9 Dreamliner"}
2	Ayşe Demir	33	Female	Turkey	First Officer	6100	{"Airbus A321neo","Airbus A320neo"}
3	Michael Brown	39	Male	USA	Captain	11000	{"Airbus A350-900","Boeing 747-8"}
4	Sophie Dubois	31	Female	France	First Officer	5900	{"Airbus A330-300","Airbus A321neo"}
5	Marco Rossi	37	Male	Italy	Relief Pilot	4500	{"Airbus A350-900","Boeing 787-9 Dreamliner"}
6	Omar Al-Fahad	41	Male	Qatar	Captain	9700	{"Airbus A350-1000","Airbus A380-800"}
7	Sarah Kim	34	Female	South Korea	First Officer	6700	{"Boeing 737-800","Airbus A320neo"}
8	James O’Neill	46	Male	Ireland	Captain	10500	{"Boeing 737 MAX 9","Boeing 737 MAX 8"}
9	Natalie Green	30	Female	Australia	First Officer	5400	{"Airbus A350-900","Boeing 787-8 Dreamliner"}
10	Luis Hernandez	38	Male	Spain	Relief Pilot	4300	{"Airbus A321neo","Airbus A320neo"}
11	Hans Müller	44	Male	Germany	Captain	11800	{"Airbus A330-300","Boeing 777-200LR"}
12	Maria Gonzalez	35	Female	Mexico	First Officer	6200	{"Boeing 737-800","Airbus A320-200"}
13	Hassan Al-Zayed	40	Male	UAE	Captain	9900	{"Airbus A380-800","Boeing 777-300ER"}
14	Liam Johnson	29	Male	USA	Relief Pilot	3800	{"Airbus A321neo","Boeing 737 MAX 8"}
15	Elena Petrova	36	Female	Russia	First Officer	5800	{"Airbus A350-900","Boeing 747-8"}
16	Mehmet Kaya	42	Male	Turkey	Captain	10300	{"Boeing 737-800","Airbus A321neo"}
17	Claire Thomas	32	Female	UK	First Officer	6400	{"Airbus A320neo","Airbus A321neo"}
18	Ali Bin Saeed	38	Male	Saudi Arabia	Captain	9600	{"Airbus A350-1000","Boeing 787-9 Dreamliner"}
19	Julia Weber	27	Female	Germany	First Officer	4900	{"Airbus A320-200","Boeing 737 MAX 9"}
20	Ethan Brooks	34	Male	Canada	Relief Pilot	4200	{"Boeing 787-8 Dreamliner","Airbus A350-900"}
21	Abdul Rahman	47	Male	Qatar	Captain	12200	{"Airbus A380-800","Boeing 777-300ER"}
22	Camila Rodriguez	31	Female	Argentina	First Officer	5800	{"Airbus A321neo","Airbus A330-300"}
23	Kenji Takahashi	44	Male	Japan	Captain	11200	{"Boeing 787-9 Dreamliner","Boeing 777-200LR"}
24	Sophia Chen	33	Female	China	First Officer	6100	{"Airbus A320neo","Airbus A321neo"}
25	David Park	28	Male	USA	Relief Pilot	3600	{"Boeing 737 MAX 8","Airbus A350-900"}
26	Fatma Al-Hassan	37	Female	Oman	First Officer	5700	{"Airbus A330-300","Airbus A350-1000"}
27	Carlos Lopez	40	Male	Spain	Captain	9800	{"Airbus A350-900","Boeing 787-8 Dreamliner"}
28	Ingrid Olsen	35	Female	Norway	First Officer	6200	{"Airbus A320-200","Airbus A321neo"}
29	Yusuf Ahmed	39	Male	Egypt	Captain	10200	{"Boeing 737-800","Boeing 737 MAX 9"}
30	Nina Patel	29	Female	India	Relief Pilot	4100	{"Airbus A350-900","Boeing 787-9 Dreamliner"}
31	George White	48	Male	UK	Captain	12700	{"Airbus A380-800","Boeing 747-8"}
32	Elif Şahin	30	Female	Turkey	First Officer	5800	{"Airbus A320neo","Airbus A321neo"}
33	Robert Wilson	37	Male	USA	Relief Pilot	4500	{"Boeing 777-200LR","Boeing 787-9 Dreamliner"}
34	Marta Silva	33	Female	Portugal	First Officer	6000	{"Airbus A330-300","Airbus A321neo"}
35	Ahmad Khalid	45	Male	Pakistan	Captain	10900	{"Boeing 737 MAX 8","Boeing 737 MAX 9"}
36	Lara Novak	34	Female	Czech Republic	First Officer	6400	{"Airbus A350-1000","Airbus A350-900"}
37	Henry Adams	43	Male	USA	Captain	11800	{"Boeing 787-9 Dreamliner","Boeing 777-300ER"}
38	Emma Li	32	Female	Singapore	First Officer	5900	{"Airbus A321neo","Boeing 737-800"}
39	Tariq Al-Masri	41	Male	UAE	Captain	9700	{"Airbus A380-800","Boeing 787-9 Dreamliner"}
40	Lisa Müller	29	Female	Germany	First Officer	5400	{"Airbus A320-200","Airbus A321neo"}
41	Jacob Evans	35	Male	USA	Relief Pilot	4100	{"Airbus A350-900","Boeing 777-200LR"}
42	Ali Yılmaz	38	Male	Turkey	Captain	10100	{"Airbus A321neo","Boeing 737 MAX 8"}
43	Aisha Nasser	30	Female	Kuwait	First Officer	5700	{"Airbus A350-900","Boeing 787-8 Dreamliner"}
44	Mark Stevens	40	Male	Canada	Relief Pilot	4400	{"Airbus A330-300","Boeing 777-300ER"}
45	Hiroshi Yamamoto	46	Male	Japan	Captain	12000	{"Boeing 787-9 Dreamliner","Airbus A350-900"}
46	Anna Petrova	33	Female	Russia	First Officer	6100	{"Airbus A321neo","Boeing 737-800"}
47	Thomas Brown	28	Male	USA	Relief Pilot	3700	{"Airbus A350-1000","Boeing 777-200LR"}
48	Maya Khan	31	Female	Pakistan	First Officer	5500	{"Boeing 737 MAX 8","Airbus A320neo"}
49	Carlos Mendes	42	Male	Brazil	Captain	11100	{"Airbus A350-900","Boeing 787-9 Dreamliner"}
50	Isabella Rossi	35	Female	Italy	First Officer	6000	{"Airbus A321neo","Airbus A320neo"}
51	David Liu	39	Male	China	Captain	10400	{"Airbus A330-300","Boeing 777-300ER"}
\.


--
-- Name: aircrafts_aircraft_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.aircrafts_aircraft_id_seq', 1, false);


--
-- Name: airlines_airline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.airlines_airline_id_seq', 10, true);


--
-- Name: cabin_crews_attendant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cabin_crews_attendant_id_seq', 1, false);


--
-- Name: flight_pilot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flight_pilot_id_seq', 32, true);


--
-- Name: flights_flight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.flights_flight_id_seq', 80, true);


--
-- Name: passengers_passenger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passengers_passenger_id_seq', 5, true);


--
-- Name: pilot_standards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pilot_standards_id_seq', 10, true);


--
-- Name: pilots_pilot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pilots_pilot_id_seq', 51, true);


--
-- Name: aircrafts aircrafts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircrafts
    ADD CONSTRAINT aircrafts_pkey PRIMARY KEY (aircraft_id);


--
-- Name: airlines airlines_airline_iata_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_airline_iata_key UNIQUE (airline_iata);


--
-- Name: airlines airlines_airline_icao_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_airline_icao_key UNIQUE (airline_icao);


--
-- Name: airlines airlines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airlines
    ADD CONSTRAINT airlines_pkey PRIMARY KEY (airline_id);


--
-- Name: airport_distances airport_distances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.airport_distances
    ADD CONSTRAINT airport_distances_pkey PRIMARY KEY (origin_airport, destination_airport);


--
-- Name: cabin_crew_standards cabin_crew_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cabin_crew_standards
    ADD CONSTRAINT cabin_crew_standards_pkey PRIMARY KEY (aircraft_model);


--
-- Name: cabin_crews cabin_crews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cabin_crews
    ADD CONSTRAINT cabin_crews_pkey PRIMARY KEY (attendant_id);


--
-- Name: flight_crews flight_crews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight_crews
    ADD CONSTRAINT flight_crews_pkey PRIMARY KEY (flight_id, attendant_id);


--
-- Name: flight_pilot flight_pilot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight_pilot
    ADD CONSTRAINT flight_pilot_pkey PRIMARY KEY (id);


--
-- Name: flights flights_flight_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_flight_number_key UNIQUE (flight_number);


--
-- Name: flights flights_flight_number_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_flight_number_unique UNIQUE (flight_number);


--
-- Name: flights flights_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (flight_id);


--
-- Name: passengers passengers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT passengers_pkey PRIMARY KEY (passenger_id);


--
-- Name: pilot_standards pilot_standards_aircraft_model_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pilot_standards
    ADD CONSTRAINT pilot_standards_aircraft_model_key UNIQUE (aircraft_model);


--
-- Name: pilot_standards pilot_standards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pilot_standards
    ADD CONSTRAINT pilot_standards_pkey PRIMARY KEY (id);


--
-- Name: pilots pilots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pilots
    ADD CONSTRAINT pilots_pkey PRIMARY KEY (pilot_id);


--
-- Name: aircrafts aircrafts_airline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aircrafts
    ADD CONSTRAINT aircrafts_airline_id_fkey FOREIGN KEY (airline_id) REFERENCES public.airlines(airline_id) ON DELETE CASCADE;


--
-- Name: flights fk_aircraft; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT fk_aircraft FOREIGN KEY (aircraft_id) REFERENCES public.aircrafts(aircraft_id) ON DELETE SET NULL;


--
-- Name: flight_crews flight_crews_attendant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight_crews
    ADD CONSTRAINT flight_crews_attendant_id_fkey FOREIGN KEY (attendant_id) REFERENCES public.cabin_crews(attendant_id);


--
-- Name: flight_crews flight_crews_flight_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight_crews
    ADD CONSTRAINT flight_crews_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES public.flights(flight_id);


--
-- Name: flight_pilot flight_pilot_flight_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight_pilot
    ADD CONSTRAINT flight_pilot_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES public.flights(flight_id) ON DELETE CASCADE;


--
-- Name: flight_pilot flight_pilot_pilot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flight_pilot
    ADD CONSTRAINT flight_pilot_pilot_id_fkey FOREIGN KEY (pilot_id) REFERENCES public.pilots(pilot_id) ON DELETE CASCADE;


--
-- Name: flights flights_airline_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_airline_id_fkey FOREIGN KEY (airline_id) REFERENCES public.airlines(airline_id) ON DELETE CASCADE;


--
-- Name: passengers passengers_flight_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT passengers_flight_number_fkey FOREIGN KEY (flight_number) REFERENCES public.flights(flight_number) ON DELETE CASCADE;


--
-- Name: passengers passengers_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT passengers_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.passengers(passenger_id);


--
-- PostgreSQL database dump complete
--

