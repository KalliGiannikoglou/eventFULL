--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

-- Started on 2023-01-16 23:09:33

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE eventfulldb;
--
-- TOC entry 3460 (class 1262 OID 16728)
-- Name: eventfulldb; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE eventfulldb WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Greek_Greece.1253';


\connect eventfulldb

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 16928)
-- Name: event; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event (
    "time" time without time zone,
    event_photo text,
    date date,
    event_id integer NOT NULL,
    description text,
    event_title character varying(100),
    z_cinema boolean,
    z_dance boolean,
    z_music boolean,
    z_kids boolean,
    z_food boolean,
    z_exhibition boolean,
    z_drinks boolean,
    fk1_location_id integer,
    fk2_user_id integer,
    location_name character varying(100),
    organiser_name character varying(100),
    z_theatre boolean
);


--
-- TOC entry 218 (class 1259 OID 16964)
-- Name: event_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_comments (
    text text,
    comment_id integer NOT NULL
);


--
-- TOC entry 217 (class 1259 OID 16963)
-- Name: event_comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_comments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3461 (class 0 OID 0)
-- Dependencies: 217
-- Name: event_comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_comments_comment_id_seq OWNED BY public.event_comments.comment_id;


--
-- TOC entry 209 (class 1259 OID 16927)
-- Name: event_event_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3462 (class 0 OID 0)
-- Dependencies: 209
-- Name: event_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_event_id_seq OWNED BY public.event.event_id;


--
-- TOC entry 228 (class 1259 OID 17129)
-- Name: eventcomments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eventcomments (
    commenttext character varying(300) NOT NULL,
    comment_id integer NOT NULL,
    fk1_event_id integer NOT NULL,
    fk2_user_id integer NOT NULL,
    username character varying(100)
);


--
-- TOC entry 227 (class 1259 OID 17128)
-- Name: eventcomments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.eventcomments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3463 (class 0 OID 0)
-- Dependencies: 227
-- Name: eventcomments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.eventcomments_comment_id_seq OWNED BY public.eventcomments.comment_id;


--
-- TOC entry 219 (class 1259 OID 16972)
-- Name: follows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.follows (
    fk1_user_id integer NOT NULL,
    fk2_user_id integer NOT NULL,
    username1 character varying(100),
    username2 character varying(100)
);


--
-- TOC entry 224 (class 1259 OID 16997)
-- Name: has; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.has (
    fk1_event_id integer NOT NULL,
    fk2_user_id integer NOT NULL,
    fk3_comment_id integer NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 17011)
-- Name: has2; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.has2 (
    fk1_location_id integer NOT NULL,
    fk2_user_id integer NOT NULL,
    fk3_comment_id integer NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16982)
-- Name: interested; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interested (
    fk1_user_id integer NOT NULL,
    fk2_event_id integer NOT NULL,
    username character varying(100)
);


--
-- TOC entry 222 (class 1259 OID 16987)
-- Name: invite; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invite (
    fk1_user_id integer NOT NULL,
    fk2_user_id integer NOT NULL,
    fk3_event_id integer NOT NULL,
    username1 character varying(100),
    username2 character varying(100)
);


--
-- TOC entry 223 (class 1259 OID 16992)
-- Name: likes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.likes (
    likesok boolean,
    fk1_user_id integer NOT NULL,
    fk2_comment_id integer NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 17006)
-- Name: likes2; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.likes2 (
    likesok boolean,
    fk1_user_id integer NOT NULL,
    fk2_comment_id integer NOT NULL
);


--
-- TOC entry 212 (class 1259 OID 16937)
-- Name: location; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location (
    location_id integer NOT NULL,
    location_photo text,
    location_name character varying(100),
    address character varying(100),
    phone character varying(10),
    z_parking boolean,
    z_transportation boolean,
    z_accessible boolean,
    z_outdoor boolean,
    z_indoor boolean,
    z_wc boolean,
    z_pets boolean,
    username character varying(100)
);


--
-- TOC entry 216 (class 1259 OID 16955)
-- Name: location_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_comments (
    text text,
    comment_id integer NOT NULL
);


--
-- TOC entry 215 (class 1259 OID 16954)
-- Name: location_comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.location_comments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3464 (class 0 OID 0)
-- Dependencies: 215
-- Name: location_comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.location_comments_comment_id_seq OWNED BY public.location_comments.comment_id;


--
-- TOC entry 211 (class 1259 OID 16936)
-- Name: location_location_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.location_location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3465 (class 0 OID 0)
-- Dependencies: 211
-- Name: location_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.location_location_id_seq OWNED BY public.location.location_id;


--
-- TOC entry 230 (class 1259 OID 17136)
-- Name: locationcomments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locationcomments (
    commenttext character varying(300) NOT NULL,
    comment_id integer NOT NULL,
    fk1_location_id integer NOT NULL,
    fk2_user_id integer NOT NULL,
    username character varying(100)
);


--
-- TOC entry 229 (class 1259 OID 17135)
-- Name: locationcomments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locationcomments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3466 (class 0 OID 0)
-- Dependencies: 229
-- Name: locationcomments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locationcomments_comment_id_seq OWNED BY public.locationcomments.comment_id;


--
-- TOC entry 220 (class 1259 OID 16977)
-- Name: request; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.request (
    fk1_user_id integer NOT NULL,
    fk2_user_id integer NOT NULL,
    username1 character varying(100),
    username2 character varying(100)
);


--
-- TOC entry 214 (class 1259 OID 16946)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    username character varying(100),
    email character varying(100),
    user_id integer NOT NULL,
    password character varying(100),
    bio text,
    social_media text,
    user_photo text,
    refresh_token text
);


--
-- TOC entry 213 (class 1259 OID 16945)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3467 (class 0 OID 0)
-- Dependencies: 213
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 3226 (class 2604 OID 16931)
-- Name: event event_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event ALTER COLUMN event_id SET DEFAULT nextval('public.event_event_id_seq'::regclass);


--
-- TOC entry 3230 (class 2604 OID 16967)
-- Name: event_comments comment_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_comments ALTER COLUMN comment_id SET DEFAULT nextval('public.event_comments_comment_id_seq'::regclass);


--
-- TOC entry 3231 (class 2604 OID 17132)
-- Name: eventcomments comment_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventcomments ALTER COLUMN comment_id SET DEFAULT nextval('public.eventcomments_comment_id_seq'::regclass);


--
-- TOC entry 3227 (class 2604 OID 16940)
-- Name: location location_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location ALTER COLUMN location_id SET DEFAULT nextval('public.location_location_id_seq'::regclass);


--
-- TOC entry 3229 (class 2604 OID 16958)
-- Name: location_comments comment_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_comments ALTER COLUMN comment_id SET DEFAULT nextval('public.location_comments_comment_id_seq'::regclass);


--
-- TOC entry 3232 (class 2604 OID 17139)
-- Name: locationcomments comment_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locationcomments ALTER COLUMN comment_id SET DEFAULT nextval('public.locationcomments_comment_id_seq'::regclass);


--
-- TOC entry 3228 (class 2604 OID 16949)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 3434 (class 0 OID 16928)
-- Dependencies: 210
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('21:00:00', 'event18mammamia.jpg', '2023-02-01', 18, 'κινηματογραφική προβολή της ταινίας ''Mamma Mia''', 'Κινηματογραφική Προβολή ', true, false, false, false, false, false, false, 4, 15, 'University of Thessaly', 'someUser', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('18:30:00', 'event10zografiki.jpg', '2023-02-22', 10, 'Σας περιμένουμε σε μια ακόμα έκθεση ζωγραφικής που διοργανώνεται από τους φοιτητές του Πανεπιστημίου Θεσσαλίας! ', 'Έκθεση Ζωγραφικής', false, false, false, true, false, true, true, 5, 15, 'Πολιτιστικό Κέντρο', 'someUser', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('23:00:00', 'event17party.jpg', '2023-02-15', 17, 'Πάρτυ υποδοχής των πρωτοετών φοιτητών', 'Party', false, true, true, true, true, false, true, 1, 15, 'Lab Art', 'someUser', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('22:42:00', 'event26maske.jpg', '2023-02-25', 26, 'Ένα πάρτυ για να γιορτάσουμε το καρναβάλι! Βάλτε τις πιο ευφάνταστες στολές και ελάτε να παρτάρουμε! Θα γίνει διαγωνισμός καλύτερης στολής οπότε βάλτε τα δυνατά σας!', 'Μασκέ Πάρτυ ', false, true, true, false, false, false, true, 4, 18, 'University of Thessaly', 'XristosKonst', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('17:00:00', 'event23photography.png', '2023-04-05', 23, 'Φωτογράφοι από όλο τον κόσμο έρχονται στον Βόλο για μια κοινή έκθεση', 'Έκθεση Φωτογραφίας', false, false, false, false, false, true, false, 5, 9, 'Πολιτιστικό Κέντρο', 'christos', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('21:00:00', 'event21theatrical.jpg', '2023-03-02', 21, 'Η νέα παράσταση της ομάδας φοιτητών του Πανεπιστημίου Θεσσαλίας παρουσιάζουν τη νέα τους παράσταση! Μην την χάσετε!   ', 'Θεατρική Παράσταση', false, false, false, false, false, false, false, 4, 9, 'University of Thessaly', 'christos', true);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('17:30:00', 'event19theat.jpg', '2023-02-28', 19, 'Νέα παράσταση του Πολιτιστικού Συλλόγου του Βόλου ', 'Theatrical Play', false, false, false, false, false, false, false, 5, 15, 'Πολιτιστικό Κέντρο', 'someUser', true);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('22:09:00', 'event27neon.jpg', '2023-02-28', 27, 'Θεματικό πάρτυ με neon! Ελάτε να χορέψουμε φορώντας αξεσουάρ από neon', 'Neon Πάρτυ', false, true, true, false, false, false, true, 6, 20, 'Θεατράκι Αναύρου', 'kellakiXD', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('18:00:00', 'event22mouseio_kerameikis.jpg', '2023-01-31', 22, 'Το νέο μουσείο κεραμικών του Βόλου ανοίγει ξανά τις πόρτες του..     ', 'Εγκαίνια Μουσείου', false, false, false, false, false, true, false, 7, 9, 'Αρχαιολογικό Μουσείο Βόλου', 'christos', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('22:15:00', 'event13lalaland.jpg', '2023-02-21', 13, 'Το Πανεπιστήμιο Θεσσαλίας σας προσκαλεί στην κινηματογραφική προβολή της ταινίας "Lalaland"  ', 'Κινηματογραφική Προβολή', true, false, false, false, false, false, false, 4, 15, 'University of Thessaly', 'someUser', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('21:00:00', 'event8satti.jpg', '2022-12-16', 8, 'Συναυλία με τη Μαρίνα Σαττι', 'Συναυλία', false, false, false, true, true, true, true, 1, 15, 'Lab Art', 'someUser', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('23:00:00', 'defaultEvent.png', '2022-09-15', 25, 'Πάρτυ υποδοχής πρωτοετών φοιτητών!! Μη το χάσετε', 'Party', false, true, true, false, false, false, true, 1, 15, 'Lab Art', 'someUser', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('18:30:00', 'event24vivlio.jpg', '2023-03-03', 24, 'Το νέο βιβλίο μου με τίτλο ''Η ζωή ανάμεσα σε δύο κόσμους'' κυκλοφόρησε!!           ', 'Παρουσίαση Βιβλίου', false, false, false, true, false, true, false, 5, 9, 'Πολιτιστικό Κέντρο', 'christos', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('00:00:00', 'event9ekthesi.jpg', '2022-12-31', 9, 'έκθεση φωτογραφίας από τον Κ. Χ. ', 'Έκθεση Φωτογραφίας', false, false, false, true, false, true, false, 3, 15, 'National Theatre', 'someUser', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('21:30:00', 'event12christmas_concert.jpg', '2022-12-25', 12, 'Παραδοσιακά κάλαντα από την χορωδία του Πανεπιστημίου ', 'Χριστουγεννιάτικη συναυλία ', false, false, true, false, false, false, false, 4, 15, 'University of Thessaly', 'someUser', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('23:00:00', 'event16christmas_party.jpg', '2023-01-07', 16, 'Καλως ορίζουμε τη νέα χρονιά με ένα πάρτυ ! Σας περιμένουμε όλους εκεί!  ', 'Πάρτυ ', false, true, true, false, false, false, true, 1, 15, 'Lab Art', 'someUser', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('21:00:00', 'event11christmas_party.jpg', '2022-12-25', 11, 'Το πιο αξέχαστο Χριστουγεννιάτικο πάρτυ! ', 'Χριστουγεννιάτικο Πάρτυ ', false, true, true, false, true, false, true, 1, 16, 'Lab Art', 'kalliG', false);
INSERT INTO public.event ("time", event_photo, date, event_id, description, event_title, z_cinema, z_dance, z_music, z_kids, z_food, z_exhibition, z_drinks, fk1_location_id, fk2_user_id, location_name, organiser_name, z_theatre) VALUES ('21:30:00', 'event15christmas-party.jpeg', '2022-12-24', 15, 'Σας περιμένουμε όλους εκεί!', 'Χριστουγεννιάτικο Πάρτυ ', false, true, true, false, true, false, true, 6, 9, 'Θεατράκι Άναυρου', 'christos', false);


--
-- TOC entry 3442 (class 0 OID 16964)
-- Dependencies: 218
-- Data for Name: event_comments; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3452 (class 0 OID 17129)
-- Dependencies: 228
-- Data for Name: eventcomments; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('amazing play', 4, 3, 9, 'christos');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('so excited', 5, 9, 15, 'someUser');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('so excited!!!!!!!!!', 6, 3, 15, 'someUser');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('Ανυπομονώωωωωω <3', 26, 9, 15, 'someUser');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('Τελεια! Ανυπομονω', 28, 10, 9, 'christos');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('Ανυπομονώωωωωωωω <3', 29, 5, 15, 'someUser');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('So excited!!', 30, 16, 15, 'someUser');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('So excited!!', 31, 16, 15, 'someUser');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('Εξαιρετικό έργο! Ανυπομονούμε :)', 32, 21, 9, 'christos');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('Εξαιρετικό έργο! Ανυπομονούμε :)', 33, 21, 9, 'christos');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('Η καλύτερη ταινία που έχει βγει! ανυπομονώ να την ξαναδώ', 34, 13, 9, 'christos');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('Εξαιρετική πρωτοβουλία', 35, 22, 9, 'christos');
INSERT INTO public.eventcomments (commenttext, comment_id, fk1_event_id, fk2_user_id, username) VALUES ('Πολυ ωραια δράση! Μπραβο', 36, 10, 9, 'christos');


--
-- TOC entry 3443 (class 0 OID 16972)
-- Dependencies: 219
-- Data for Name: follows; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.follows (fk1_user_id, fk2_user_id, username1, username2) VALUES (15, 16, 'someUser', 'kalliG');
INSERT INTO public.follows (fk1_user_id, fk2_user_id, username1, username2) VALUES (19, 15, 'maraqui', 'someUser');
INSERT INTO public.follows (fk1_user_id, fk2_user_id, username1, username2) VALUES (16, 15, 'kalliG', 'someUser');
INSERT INTO public.follows (fk1_user_id, fk2_user_id, username1, username2) VALUES (9, 15, 'christos', 'someUser');
INSERT INTO public.follows (fk1_user_id, fk2_user_id, username1, username2) VALUES (18, 15, 'XristosKonst', 'someUser');
INSERT INTO public.follows (fk1_user_id, fk2_user_id, username1, username2) VALUES (15, 21, 'someUser', 'zoeeee');
INSERT INTO public.follows (fk1_user_id, fk2_user_id, username1, username2) VALUES (15, 18, 'someUser', 'XristosKonst');


--
-- TOC entry 3448 (class 0 OID 16997)
-- Dependencies: 224
-- Data for Name: has; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3450 (class 0 OID 17011)
-- Dependencies: 226
-- Data for Name: has2; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3445 (class 0 OID 16982)
-- Dependencies: 221
-- Data for Name: interested; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (9, 8, 'christos');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (15, 8, 'someUser');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (15, 9, 'someUser');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (15, 11, 'someUser');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (16, 11, 'kalliG');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (15, 12, 'someUser');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (9, 13, 'christos');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (15, 13, 'someUser');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (9, 11, 'christos');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (9, 10, 'christos');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (15, 16, 'someUser');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (17, 15, 'maria');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (17, 12, 'maria');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (9, 23, 'christos');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (9, 22, 'christos');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (15, 17, 'someUser');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (16, 18, 'kalliG');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (18, 26, 'XristosKonst');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (20, 27, 'kellakiXD');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (15, 22, 'someUser');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (15, 26, 'someUser');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (9, 18, 'christos');
INSERT INTO public.interested (fk1_user_id, fk2_event_id, username) VALUES (18, 18, 'XristosKonst');


--
-- TOC entry 3446 (class 0 OID 16987)
-- Dependencies: 222
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.invite (fk1_user_id, fk2_user_id, fk3_event_id, username1, username2) VALUES (15, 9, 11, 'someUser', 'christos');
INSERT INTO public.invite (fk1_user_id, fk2_user_id, fk3_event_id, username1, username2) VALUES (16, 9, 10, 'kalliG', 'christos');
INSERT INTO public.invite (fk1_user_id, fk2_user_id, fk3_event_id, username1, username2) VALUES (15, 9, 10, 'someUser', 'christos');
INSERT INTO public.invite (fk1_user_id, fk2_user_id, fk3_event_id, username1, username2) VALUES (15, 16, 10, 'someUser', 'kalliG');
INSERT INTO public.invite (fk1_user_id, fk2_user_id, fk3_event_id, username1, username2) VALUES (15, 9, 16, 'someUser', 'christos');
INSERT INTO public.invite (fk1_user_id, fk2_user_id, fk3_event_id, username1, username2) VALUES (9, 15, 18, 'christos', 'someUser');
INSERT INTO public.invite (fk1_user_id, fk2_user_id, fk3_event_id, username1, username2) VALUES (18, 15, 18, 'XristosKonst', 'someUser');
INSERT INTO public.invite (fk1_user_id, fk2_user_id, fk3_event_id, username1, username2) VALUES (18, 15, 22, 'XristosKonst', 'someUser');
INSERT INTO public.invite (fk1_user_id, fk2_user_id, fk3_event_id, username1, username2) VALUES (15, 16, 18, 'someUser', 'kalliG');


--
-- TOC entry 3447 (class 0 OID 16992)
-- Dependencies: 223
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3449 (class 0 OID 17006)
-- Dependencies: 225
-- Data for Name: likes2; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3436 (class 0 OID 16937)
-- Dependencies: 212
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.location (location_id, location_photo, location_name, address, phone, z_parking, z_transportation, z_accessible, z_outdoor, z_indoor, z_wc, z_pets, username) VALUES (5, 'location5politistiko.jpg', 'Πολιτιστικό Κέντρο', 'Πολιτιστικό Κέντρο Βόλος', '2421011115', true, true, true, false, true, true, false, 'someUser');
INSERT INTO public.location (location_id, location_photo, location_name, address, phone, z_parking, z_transportation, z_accessible, z_outdoor, z_indoor, z_wc, z_pets, username) VALUES (3, 'location3theatro.jpg', 'National Theatre', 'Αγίου Κωνσταντίνου 22, Αθήνα ', '2421094785', false, true, true, false, true, true, false, 'christos');
INSERT INTO public.location (location_id, location_photo, location_name, address, phone, z_parking, z_transportation, z_accessible, z_outdoor, z_indoor, z_wc, z_pets, username) VALUES (6, 'location6anauros.webp', 'Θεατράκι Αναύρου', 'Πλαστήρα 19, Βόλος 382 22', '00000', true, true, true, true, false, false, true, 'someUser');
INSERT INTO public.location (location_id, location_photo, location_name, address, phone, z_parking, z_transportation, z_accessible, z_outdoor, z_indoor, z_wc, z_pets, username) VALUES (1, 'location1labart.jpg', 'Lab Art', 'Lab Art, Volos', '6934108666', true, true, false, true, true, true, false, 'someUser');
INSERT INTO public.location (location_id, location_photo, location_name, address, phone, z_parking, z_transportation, z_accessible, z_outdoor, z_indoor, z_wc, z_pets, username) VALUES (7, 'defaultLocation.png', 'Αρχαιολογικό Μουσείο Βόλου', 'Αθανασάκη 1, Βόλος 382 22', '2421000000', true, true, true, false, true, true, false, 'someUser');
INSERT INTO public.location (location_id, location_photo, location_name, address, phone, z_parking, z_transportation, z_accessible, z_outdoor, z_indoor, z_wc, z_pets, username) VALUES (2, 'location2Theatre-Volou.jpg', 'Δημοτικό Θέατρο Βόλου', 'Δημοτικό Θέατρο Βόλος 383 34', '2421099999', false, true, true, false, true, true, false, 'christos');
INSERT INTO public.location (location_id, location_photo, location_name, address, phone, z_parking, z_transportation, z_accessible, z_outdoor, z_indoor, z_wc, z_pets, username) VALUES (8, 'defaultLocation.png', 'Μουσείο Σύχρονης Τέχνης', 'Λεωφόρος Καλλιρρόης', '2111019000', false, true, true, false, true, true, false, NULL);
INSERT INTO public.location (location_id, location_photo, location_name, address, phone, z_parking, z_transportation, z_accessible, z_outdoor, z_indoor, z_wc, z_pets, username) VALUES (4, 'location4university.jpg', 'University of Thessaly', 'Φιλελλήνων 1, Βόλος', '1234567891', true, true, true, true, true, true, false, 'someUser');


--
-- TOC entry 3440 (class 0 OID 16955)
-- Dependencies: 216
-- Data for Name: location_comments; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3454 (class 0 OID 17136)
-- Dependencies: 230
-- Data for Name: locationcomments; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.locationcomments (commenttext, comment_id, fk1_location_id, fk2_user_id, username) VALUES ('sdfdsfdsf', 1, 1, 9, 'christos');
INSERT INTO public.locationcomments (commenttext, comment_id, fk1_location_id, fk2_user_id, username) VALUES ('This place is awesome', 2, 3, 16, 'kalliG');
INSERT INTO public.locationcomments (commenttext, comment_id, fk1_location_id, fk2_user_id, username) VALUES ('Πολύ χρήσιμο για την πόλη μας! Μπραβο', 3, 5, 9, 'christos');
INSERT INTO public.locationcomments (commenttext, comment_id, fk1_location_id, fk2_user_id, username) VALUES ('amazing theatre!', 4, 7, 9, 'christos');
INSERT INTO public.locationcomments (commenttext, comment_id, fk1_location_id, fk2_user_id, username) VALUES ('woooow', 5, 7, 9, 'christos');
INSERT INTO public.locationcomments (commenttext, comment_id, fk1_location_id, fk2_user_id, username) VALUES ('Ανυπομονουμέεεεεε', 6, 1, 9, 'christos');


--
-- TOC entry 3444 (class 0 OID 16977)
-- Dependencies: 220
-- Data for Name: request; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.request (fk1_user_id, fk2_user_id, username1, username2) VALUES (16, 9, 'kalliG', 'christos');
INSERT INTO public.request (fk1_user_id, fk2_user_id, username1, username2) VALUES (19, 9, 'maraqui', 'christos');
INSERT INTO public.request (fk1_user_id, fk2_user_id, username1, username2) VALUES (20, 15, 'kellakiXD', 'someUser');
INSERT INTO public.request (fk1_user_id, fk2_user_id, username1, username2) VALUES (21, 15, 'zoeeee', 'someUser');


--
-- TOC entry 3438 (class 0 OID 16946)
-- Dependencies: 214
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users (username, email, user_id, password, bio, social_media, user_photo, refresh_token) VALUES ('maraqui', 'mbourelou@yahoo.gr', 19, '$2a$10$wUV0mw5Apxp.sZZsKORqvuDaEgcT9Ik37czJMqFt.ER6juEYFAlVu', 'Αν μπορούσα θα ήμουν επαγγελματίας προσκεκλημένη σε πάρτυ! Hit me up people <33', 'https://www.instagram.com/ble_me/', 'user19maraqui.jpg', NULL);
INSERT INTO public.users (username, email, user_id, password, bio, social_media, user_photo, refresh_token) VALUES ('kellakiXD', 'kellakixd@gmail.com', 20, '$2a$10$Tc6XMLiJqubc55jbHaACZukhkt5d1JgJqbpLEg718K/wBBba3/P3G', 'Μου αρέσουν τα πάρτυ, και κυρίως τα θεματικά! Follow me για τα καλύτερα πάρτυ της πόλης!', 'https://www.instagram.com/kelly.nanou/', 'user20kelly.jpg', NULL);
INSERT INTO public.users (username, email, user_id, password, bio, social_media, user_photo, refresh_token) VALUES ('zoeeee', 'zoemous@gmail.com', 21, '$2a$10$2LBL1rYwvbmTPD83KROxOOu8uMG/cYWEKKIL3aClWCuDHCnFruy1e', ' Μου αρέσουν τα ταξίδια και η σύχρονη τέχνη', NULL, 'user21zoe.jpg', NULL);
INSERT INTO public.users (username, email, user_id, password, bio, social_media, user_photo, refresh_token) VALUES ('kalliG', 'kalli@email.com', 16, '$2a$10$UoS1aG8xl0HoTBlPYICCFuXlADFKj501YxcL3Vnq8kY7RcSN2Jq2y', 'Helloooo my friends', 'find me on insta <3', 'user16kallipic.jpg', NULL);
INSERT INTO public.users (username, email, user_id, password, bio, social_media, user_photo, refresh_token) VALUES ('christos', 'christos@gmail.com', 9, '$2a$10$bhAENIIpVZ1AezaMJtWEEeYV3QFlcJBy/6auRi0jU1oA1p.GXVbn.', 'this is my bio!', 'insta: christossssssssssssss', 'user9belvedere.jpg', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImNocmlzdG9zIiwiaWF0IjoxNjY5NjQ4NjcwLCJleHAiOjE2Njk3MzUwNzB9.4pKbzRQFPqkmla2B6CerSxXMW7PCEm8N8fUiG8KMsPw');
INSERT INTO public.users (username, email, user_id, password, bio, social_media, user_photo, refresh_token) VALUES ('maria', 'maria@email.com', 17, '$2a$10$gCQwqyJamvH9sq9rmpmDF.X1s.4jVuxcxQsKw7LcXh0dCrsCkkC8O', NULL, NULL, 'defaultUser.png', NULL);
INSERT INTO public.users (username, email, user_id, password, bio, social_media, user_photo, refresh_token) VALUES ('someUser', 'user@email.com', 15, '$2a$10$CGUYwiYmXljGIx9SqYj18.DN4NXip2yiAmQUfoIADMnsD9HwwgkCi', 'this is my bio!!', 'fb: someuserrrr', 'user15rnduser.png', NULL);
INSERT INTO public.users (username, email, user_id, password, bio, social_media, user_photo, refresh_token) VALUES ('XristosKonst', 'ckonst@gmail.com', 18, '$2a$10$u0OR72aq7J/QeGOQQjR/JeHqfKdt9by7fWKdxB58XCGxNm4TEnJNm', 'hello guys, follow me for the coolest events in town!', 'insta: xristos_konst ', 'user18christosKonst.jpg', NULL);


--
-- TOC entry 3468 (class 0 OID 0)
-- Dependencies: 217
-- Name: event_comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.event_comments_comment_id_seq', 1, false);


--
-- TOC entry 3469 (class 0 OID 0)
-- Dependencies: 209
-- Name: event_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.event_event_id_seq', 27, true);


--
-- TOC entry 3470 (class 0 OID 0)
-- Dependencies: 227
-- Name: eventcomments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.eventcomments_comment_id_seq', 36, true);


--
-- TOC entry 3471 (class 0 OID 0)
-- Dependencies: 215
-- Name: location_comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.location_comments_comment_id_seq', 1, false);


--
-- TOC entry 3472 (class 0 OID 0)
-- Dependencies: 211
-- Name: location_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.location_location_id_seq', 8, true);


--
-- TOC entry 3473 (class 0 OID 0)
-- Dependencies: 229
-- Name: locationcomments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.locationcomments_comment_id_seq', 6, true);


--
-- TOC entry 3474 (class 0 OID 0)
-- Dependencies: 213
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_user_id_seq', 21, true);


--
-- TOC entry 3238 (class 2606 OID 17127)
-- Name: users constraint_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT constraint_name UNIQUE (username);


--
-- TOC entry 3244 (class 2606 OID 16971)
-- Name: event_comments event_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_comments
    ADD CONSTRAINT event_comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 3234 (class 2606 OID 16935)
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (event_id);


--
-- TOC entry 3270 (class 2606 OID 17134)
-- Name: eventcomments eventcomments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventcomments
    ADD CONSTRAINT eventcomments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 3246 (class 2606 OID 16976)
-- Name: follows follows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (fk1_user_id, fk2_user_id);


--
-- TOC entry 3264 (class 2606 OID 17017)
-- Name: has2 has2_fk2_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has2
    ADD CONSTRAINT has2_fk2_user_id_key UNIQUE (fk2_user_id);


--
-- TOC entry 3266 (class 2606 OID 17019)
-- Name: has2 has2_fk3_comment_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has2
    ADD CONSTRAINT has2_fk3_comment_id_key UNIQUE (fk3_comment_id);


--
-- TOC entry 3268 (class 2606 OID 17015)
-- Name: has2 has2_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has2
    ADD CONSTRAINT has2_pkey PRIMARY KEY (fk1_location_id);


--
-- TOC entry 3256 (class 2606 OID 17003)
-- Name: has has_fk2_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has
    ADD CONSTRAINT has_fk2_user_id_key UNIQUE (fk2_user_id);


--
-- TOC entry 3258 (class 2606 OID 17005)
-- Name: has has_fk3_comment_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has
    ADD CONSTRAINT has_fk3_comment_id_key UNIQUE (fk3_comment_id);


--
-- TOC entry 3260 (class 2606 OID 17001)
-- Name: has has_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has
    ADD CONSTRAINT has_pkey PRIMARY KEY (fk1_event_id);


--
-- TOC entry 3250 (class 2606 OID 16986)
-- Name: interested interested_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interested
    ADD CONSTRAINT interested_pkey PRIMARY KEY (fk1_user_id, fk2_event_id);


--
-- TOC entry 3252 (class 2606 OID 16991)
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (fk1_user_id, fk2_user_id, fk3_event_id);


--
-- TOC entry 3262 (class 2606 OID 17010)
-- Name: likes2 likes2_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes2
    ADD CONSTRAINT likes2_pkey PRIMARY KEY (fk1_user_id, fk2_comment_id);


--
-- TOC entry 3254 (class 2606 OID 16996)
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (fk1_user_id, fk2_comment_id);


--
-- TOC entry 3242 (class 2606 OID 16962)
-- Name: location_comments location_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_comments
    ADD CONSTRAINT location_comments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 3236 (class 2606 OID 16944)
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (location_id);


--
-- TOC entry 3272 (class 2606 OID 17141)
-- Name: locationcomments locationcomments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locationcomments
    ADD CONSTRAINT locationcomments_pkey PRIMARY KEY (comment_id);


--
-- TOC entry 3248 (class 2606 OID 16981)
-- Name: request request_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request
    ADD CONSTRAINT request_pkey PRIMARY KEY (fk1_user_id, fk2_user_id);


--
-- TOC entry 3240 (class 2606 OID 16953)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3273 (class 2606 OID 17020)
-- Name: event event_fk1_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_fk1_location_id_fkey FOREIGN KEY (fk1_location_id) REFERENCES public.location(location_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3274 (class 2606 OID 17025)
-- Name: event event_fk2_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_fk2_user_id_fkey FOREIGN KEY (fk2_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3275 (class 2606 OID 17030)
-- Name: follows follows_fk1_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_fk1_user_id_fkey FOREIGN KEY (fk1_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3276 (class 2606 OID 17035)
-- Name: follows follows_fk2_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.follows
    ADD CONSTRAINT follows_fk2_user_id_fkey FOREIGN KEY (fk2_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3291 (class 2606 OID 17110)
-- Name: has2 has2_fk1_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has2
    ADD CONSTRAINT has2_fk1_location_id_fkey FOREIGN KEY (fk1_location_id) REFERENCES public.location(location_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3292 (class 2606 OID 17115)
-- Name: has2 has2_fk2_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has2
    ADD CONSTRAINT has2_fk2_user_id_fkey FOREIGN KEY (fk2_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3293 (class 2606 OID 17120)
-- Name: has2 has2_fk3_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has2
    ADD CONSTRAINT has2_fk3_comment_id_fkey FOREIGN KEY (fk3_comment_id) REFERENCES public.location_comments(comment_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3286 (class 2606 OID 17085)
-- Name: has has_fk1_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has
    ADD CONSTRAINT has_fk1_event_id_fkey FOREIGN KEY (fk1_event_id) REFERENCES public.event(event_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3287 (class 2606 OID 17090)
-- Name: has has_fk2_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has
    ADD CONSTRAINT has_fk2_user_id_fkey FOREIGN KEY (fk2_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3288 (class 2606 OID 17095)
-- Name: has has_fk3_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.has
    ADD CONSTRAINT has_fk3_comment_id_fkey FOREIGN KEY (fk3_comment_id) REFERENCES public.event_comments(comment_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3279 (class 2606 OID 17050)
-- Name: interested interested_fk1_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interested
    ADD CONSTRAINT interested_fk1_user_id_fkey FOREIGN KEY (fk1_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3280 (class 2606 OID 17055)
-- Name: interested interested_fk2_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interested
    ADD CONSTRAINT interested_fk2_event_id_fkey FOREIGN KEY (fk2_event_id) REFERENCES public.event(event_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3281 (class 2606 OID 17060)
-- Name: invite invite_fk1_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_fk1_user_id_fkey FOREIGN KEY (fk1_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3282 (class 2606 OID 17065)
-- Name: invite invite_fk2_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_fk2_user_id_fkey FOREIGN KEY (fk2_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3283 (class 2606 OID 17070)
-- Name: invite invite_fk3_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_fk3_event_id_fkey FOREIGN KEY (fk3_event_id) REFERENCES public.event(event_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3289 (class 2606 OID 17100)
-- Name: likes2 likes2_fk1_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes2
    ADD CONSTRAINT likes2_fk1_user_id_fkey FOREIGN KEY (fk1_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3290 (class 2606 OID 17105)
-- Name: likes2 likes2_fk2_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes2
    ADD CONSTRAINT likes2_fk2_comment_id_fkey FOREIGN KEY (fk2_comment_id) REFERENCES public.location_comments(comment_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3284 (class 2606 OID 17075)
-- Name: likes likes_fk1_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_fk1_user_id_fkey FOREIGN KEY (fk1_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3285 (class 2606 OID 17080)
-- Name: likes likes_fk2_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_fk2_comment_id_fkey FOREIGN KEY (fk2_comment_id) REFERENCES public.event_comments(comment_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3277 (class 2606 OID 17040)
-- Name: request request_fk1_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request
    ADD CONSTRAINT request_fk1_user_id_fkey FOREIGN KEY (fk1_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3278 (class 2606 OID 17045)
-- Name: request request_fk2_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request
    ADD CONSTRAINT request_fk2_user_id_fkey FOREIGN KEY (fk2_user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2023-01-16 23:09:34

--
-- PostgreSQL database dump complete
--

