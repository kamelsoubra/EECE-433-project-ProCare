--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-11-22 21:34:58

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 28461)
-- Name: agent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agent (
    agentid character varying(10) NOT NULL,
    agentname character varying(100) NOT NULL,
    commissionrate numeric(5,2) NOT NULL,
    email character varying(100) NOT NULL,
    licensenumber character varying(50) NOT NULL,
    phonenumber character varying(15) NOT NULL,
    CONSTRAINT agent_commissionrate_check CHECK ((commissionrate >= (0)::numeric)),
    CONSTRAINT agent_email_check CHECK (((email)::text ~ '^[A-Za-z0-9._]+@[A-Za-z0-9.]+\.[A-Za-z]{2,}$'::text))
);


ALTER TABLE public.agent OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 28466)
-- Name: policy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.policy (
    policynumber character varying(10) NOT NULL,
    exactcost numeric(10,2) NOT NULL,
    startdate date DEFAULT CURRENT_DATE NOT NULL,
    enddate date NOT NULL,
    insuranceplanname character varying(100),
    CONSTRAINT policy_exactcost_check CHECK ((exactcost >= (0)::numeric))
);


ALTER TABLE public.policy OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 28471)
-- Name: sell; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sell (
    clientid character varying(10) NOT NULL,
    policynumber character varying(10) NOT NULL,
    agentid character varying(10) NOT NULL
);


ALTER TABLE public.sell OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 28474)
-- Name: agentearningsannually; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.agentearningsannually AS
 SELECT s.agentid,
    EXTRACT(year FROM p.startdate) AS year,
    count(s.clientid) AS totalclients,
    sum(p.exactcost) AS totalrevenue,
    round(sum(((a.commissionrate / (100)::numeric) * p.exactcost)), 2) AS totalcommission
   FROM ((public.sell s
     JOIN public.policy p ON (((s.policynumber)::text = (p.policynumber)::text)))
     JOIN public.agent a ON (((s.agentid)::text = (a.agentid)::text)))
  WHERE ((a.email)::text = CURRENT_USER)
  GROUP BY s.agentid, (EXTRACT(year FROM p.startdate))
  ORDER BY (sum(p.exactcost)) DESC;


ALTER VIEW public.agentearningsannually OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 28479)
-- Name: agentearningsannuallyrestricted; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.agentearningsannuallyrestricted AS
 SELECT agentid,
    year,
    totalclients,
    totalrevenue,
    totalcommission
   FROM public.agentearningsannually
  WHERE ((agentid)::text = (( SELECT agent.agentid
           FROM public.agent
          WHERE ((agent.email)::text = 'karim.boukhallil@procare.com'::text)))::text);


ALTER VIEW public.agentearningsannuallyrestricted OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 28483)
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    clientid character varying(10) NOT NULL,
    firstname character varying(50) NOT NULL,
    middlename character varying(50),
    lastname character varying(50) NOT NULL,
    dob date NOT NULL,
    gender character(1) NOT NULL,
    email character varying(100) NOT NULL,
    CONSTRAINT client_dob_check CHECK ((dob < CURRENT_DATE)),
    CONSTRAINT client_email_check CHECK (((email)::text ~ '^[A-Za-z0-9._]+@[A-Za-z0-9.]+\.[A-Za-z]{2,}$'::text)),
    CONSTRAINT client_gender_check CHECK ((gender = ANY (ARRAY['M'::bpchar, 'F'::bpchar])))
);


ALTER TABLE public.client OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 28489)
-- Name: clientaddress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientaddress (
    clientid character varying(10) NOT NULL,
    address text NOT NULL
);


ALTER TABLE public.clientaddress OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 28494)
-- Name: clientdependent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientdependent (
    clientid character varying(10) NOT NULL,
    firstname character varying(50) NOT NULL,
    middlename character varying(50) DEFAULT ''::character varying NOT NULL,
    lastname character varying(50) NOT NULL,
    dob date NOT NULL,
    gender character(1) NOT NULL,
    relationship character varying(50) NOT NULL,
    CONSTRAINT clientdependent_dob_check CHECK ((dob < CURRENT_DATE)),
    CONSTRAINT clientdependent_gender_check CHECK ((gender = ANY (ARRAY['M'::bpchar, 'F'::bpchar])))
);


ALTER TABLE public.clientdependent OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 28500)
-- Name: clientphonenumber; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientphonenumber (
    clientid character varying(10) NOT NULL,
    phonenumber character varying(15) NOT NULL
);


ALTER TABLE public.clientphonenumber OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 28503)
-- Name: doctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctor (
    doctorid character varying(10) NOT NULL,
    firstname character varying(50) NOT NULL,
    middlename character varying(50),
    lastname character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phonenumber character varying(15),
    supervisorhealthcareproviderid character varying(10),
    CONSTRAINT doctor_email_check CHECK (((email)::text ~ '^[A-Za-z0-9._]+@[A-Za-z0-9.]+\.[A-Za-z]{2,}$'::text))
);


ALTER TABLE public.doctor OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 28507)
-- Name: employdoctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employdoctor (
    healthcareproviderid character varying(10) NOT NULL,
    doctorid character varying(10) NOT NULL
);


ALTER TABLE public.employdoctor OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 28510)
-- Name: healthcareprovider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.healthcareprovider (
    healthcareproviderid character varying(10) NOT NULL,
    providername character varying(50) NOT NULL,
    providertype character varying(50) NOT NULL,
    phonenumber character varying(15) NOT NULL,
    address text NOT NULL
);


ALTER TABLE public.healthcareprovider OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 28515)
-- Name: medicalservice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicalservice (
    serviceid character varying(10) NOT NULL,
    servicename character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.medicalservice OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 28520)
-- Name: provide; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provide (
    clientid character varying(10) NOT NULL,
    doctorid character varying(10) NOT NULL,
    serviceid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    servicecost numeric(10,2) NOT NULL,
    CONSTRAINT provide_servicecost_check CHECK ((servicecost >= (0)::numeric))
);


ALTER TABLE public.provide OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 28525)
-- Name: clientservicepaymentsview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.clientservicepaymentsview AS
 WITH clientservicepayments AS (
         SELECT h.healthcareproviderid,
            h.providername AS healthcareprovidername,
            c.clientid,
            concat(c.firstname, ' ', COALESCE(c.middlename, ''::character varying), ' ', c.lastname) AS clientfullname,
            ms.serviceid,
            ms.servicename,
            p.date AS paymentdate,
            to_char((p.date)::timestamp with time zone, 'YYYY-MM'::text) AS revenuemonth,
            p.servicecost AS paymentamount
           FROM (((((public.provide p
             JOIN public.client c ON (((p.clientid)::text = (c.clientid)::text)))
             JOIN public.doctor d ON (((p.doctorid)::text = (d.doctorid)::text)))
             JOIN public.employdoctor ed ON (((d.doctorid)::text = (ed.doctorid)::text)))
             JOIN public.healthcareprovider h ON (((ed.healthcareproviderid)::text = (h.healthcareproviderid)::text)))
             JOIN public.medicalservice ms ON (((p.serviceid)::text = (ms.serviceid)::text)))
        )
 SELECT healthcareproviderid,
    healthcareprovidername,
    clientid,
    clientfullname,
    serviceid,
    servicename,
    paymentdate,
    revenuemonth,
    paymentamount
   FROM clientservicepayments;


ALTER VIEW public.clientservicepaymentsview OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 28530)
-- Name: requestclaim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requestclaim (
    employeeid character varying(10) NOT NULL,
    clientid character varying(10) NOT NULL,
    datecreated date DEFAULT CURRENT_DATE NOT NULL,
    amount numeric(10,2) NOT NULL,
    approvalstatus character varying(50) DEFAULT 'Pending'::character varying NOT NULL,
    decisiondate date,
    CONSTRAINT requestclaim_amount_check CHECK ((amount > (0)::numeric))
);


ALTER TABLE public.requestclaim OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 28536)
-- Name: clientsummaryfiltered; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.clientsummaryfiltered AS
 SELECT rc.clientid,
    concat(c.firstname, ' ', COALESCE(c.middlename, ''::character varying), ' ', c.lastname) AS clientname,
    count(*) AS totalclaims,
    sum(rc.amount) AS totalamount,
    round((((sum(
        CASE
            WHEN ((rc.approvalstatus)::text = 'Rejected'::text) THEN 1
            ELSE 0
        END))::numeric * 100.0) / (count(*))::numeric), 2) AS rejectionrate
   FROM (public.requestclaim rc
     JOIN public.client c ON (((rc.clientid)::text = (c.clientid)::text)))
  WHERE (rc.datecreated >= (now() - '3 mons'::interval))
  GROUP BY rc.clientid, c.firstname, c.middlename, c.lastname
 HAVING ((count(*) > 10) AND (sum(rc.amount) > (100000)::numeric))
  ORDER BY (count(*)) DESC;


ALTER VIEW public.clientsummaryfiltered OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 28541)
-- Name: covers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.covers (
    insuranceplanname character varying(100) NOT NULL,
    healthcareproviderid character varying(10) NOT NULL
);


ALTER TABLE public.covers OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 28544)
-- Name: doctorspecialization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctorspecialization (
    doctorid character varying(10) NOT NULL,
    specialization character varying(50) NOT NULL
);


ALTER TABLE public.doctorspecialization OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 28547)
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    employeeid character varying(10) NOT NULL,
    firstname character varying(50) NOT NULL,
    middlename character varying(50),
    lastname character varying(50) NOT NULL,
    phonenumber character varying(15) NOT NULL,
    email character varying(100) NOT NULL,
    address text,
    salary numeric(10,2) NOT NULL,
    jobtitle character varying(50) NOT NULL,
    CONSTRAINT employee_email_check CHECK (((email)::text ~~ '%@procare.com'::text)),
    CONSTRAINT employee_salary_check CHECK ((salary > (0)::numeric))
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN employee.salary; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employee.salary IS 'Employee salary in USD';


--
-- TOC entry 235 (class 1259 OID 28554)
-- Name: employeedependent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employeedependent (
    employeeid character varying(10) NOT NULL,
    firstname character varying(50) NOT NULL,
    middlename character varying(50) DEFAULT ''::character varying NOT NULL,
    lastname character varying(50) NOT NULL,
    dob date NOT NULL,
    gender character(1) NOT NULL,
    relationship character varying(50) NOT NULL,
    CONSTRAINT employeedependent_dob_check CHECK ((dob < CURRENT_DATE)),
    CONSTRAINT employeedependent_gender_check CHECK ((gender = ANY (ARRAY['M'::bpchar, 'F'::bpchar])))
);


ALTER TABLE public.employeedependent OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 28560)
-- Name: insuranceplan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insuranceplan (
    insuranceplanname character varying(100) NOT NULL,
    plantype character varying(50) NOT NULL,
    description text,
    coveragelevel character varying(50) NOT NULL,
    premium numeric(10,2) NOT NULL,
    deductible numeric(10,2) NOT NULL,
    CONSTRAINT insuranceplan_deductible_check CHECK ((deductible >= (0)::numeric)),
    CONSTRAINT insuranceplan_premium_check CHECK ((premium > (0)::numeric))
);


ALTER TABLE public.insuranceplan OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 28567)
-- Name: healthcareproviderclientcount; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.healthcareproviderclientcount AS
 SELECT h.healthcareproviderid,
    h.providername AS healthcareprovidername,
    ip.coveragelevel AS insuranceplanlevel,
    count(DISTINCT c.clientid) AS clientcount
   FROM ((((((public.provide p
     JOIN public.client c ON (((p.clientid)::text = (c.clientid)::text)))
     JOIN public.sell s ON (((c.clientid)::text = (s.clientid)::text)))
     JOIN public.policy l ON (((s.policynumber)::text = (l.policynumber)::text)))
     JOIN public.insuranceplan ip ON (((l.insuranceplanname)::text = (ip.insuranceplanname)::text)))
     JOIN public.employdoctor ed ON (((p.doctorid)::text = (ed.doctorid)::text)))
     JOIN public.healthcareprovider h ON (((ed.healthcareproviderid)::text = (h.healthcareproviderid)::text)))
  GROUP BY h.healthcareproviderid, h.providername, ip.coveragelevel
  ORDER BY h.healthcareproviderid, ip.coveragelevel;


ALTER VIEW public.healthcareproviderclientcount OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 28572)
-- Name: pays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pays (
    employeeid character varying(10) NOT NULL,
    clientid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    amount numeric(10,2) NOT NULL,
    purpose text,
    CONSTRAINT pays_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT pays_date_check CHECK ((date <= CURRENT_DATE))
);


ALTER TABLE public.pays OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 28580)
-- Name: healthcareproviderservicepayments; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.healthcareproviderservicepayments AS
 SELECT ed.healthcareproviderid,
    c.clientid,
    ms.servicename,
    pr.date,
    p.amount AS amountpaid
   FROM ((((public.employdoctor ed
     JOIN public.provide pr ON (((ed.doctorid)::text = (pr.doctorid)::text)))
     JOIN public.client c ON (((pr.clientid)::text = (c.clientid)::text)))
     JOIN public.medicalservice ms ON (((pr.serviceid)::text = (ms.serviceid)::text)))
     JOIN public.pays p ON (((c.clientid)::text = (p.clientid)::text)))
  WHERE ((ed.healthcareproviderid)::text IN ( SELECT healthcareprovider.healthcareproviderid
           FROM public.healthcareprovider
          WHERE ((lower(replace((healthcareprovider.providername)::text, ' '::text, '.'::text)) || '@healthcare.com'::text) = CURRENT_USER)));


ALTER VIEW public.healthcareproviderservicepayments OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 28585)
-- Name: healthcareproviderservicepaymentsrestricted; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.healthcareproviderservicepaymentsrestricted AS
 SELECT ed.healthcareproviderid,
    ms.servicename,
    pr.date,
    p.amount AS amountpaid
   FROM ((((public.employdoctor ed
     JOIN public.provide pr ON (((ed.doctorid)::text = (pr.doctorid)::text)))
     JOIN public.client c ON (((pr.clientid)::text = (c.clientid)::text)))
     JOIN public.medicalservice ms ON (((pr.serviceid)::text = (ms.serviceid)::text)))
     JOIN public.pays p ON (((c.clientid)::text = (p.clientid)::text)));


ALTER VIEW public.healthcareproviderservicepaymentsrestricted OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 28590)
-- Name: medicalrecords; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicalrecords (
    clientid character varying(10) NOT NULL,
    icdcode character varying(50) NOT NULL,
    datecreated date DEFAULT CURRENT_DATE NOT NULL,
    conditionname character varying(100) NOT NULL,
    description text,
    CONSTRAINT medicalrecords_datecreated_check CHECK ((datecreated <= CURRENT_DATE)),
    CONSTRAINT medicalrecords_icdcode_check CHECK (((icdcode)::text ~ '^[A-Z0-9]{3,4}(\.[A-Z0-9]{1,4})?$'::text))
);


ALTER TABLE public.medicalrecords OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 28598)
-- Name: refer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refer (
    clientid character varying(10) NOT NULL,
    referringdoctorid character varying(10) NOT NULL,
    referreddoctorid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    reason text
);


ALTER TABLE public.refer OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 28604)
-- Name: requestdoctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requestdoctor (
    clientid character varying(10) NOT NULL,
    doctorid character varying(10) NOT NULL,
    healthcareproviderid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.requestdoctor OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 28608)
-- Name: top5monthlyservicesummary; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.top5monthlyservicesummary AS
 WITH rankedservices AS (
         SELECT ed.healthcareproviderid,
            ms.serviceid,
            ms.servicename,
            concat((EXTRACT(year FROM pr.date))::text, '-', lpad((EXTRACT(month FROM pr.date))::text, 2, '0'::text)) AS serviceperiod,
            count(*) AS totaluses,
            sum(pr.servicecost) AS totalgenerated,
            row_number() OVER (PARTITION BY ed.healthcareproviderid, (EXTRACT(year FROM pr.date)), (EXTRACT(month FROM pr.date)) ORDER BY (sum(pr.servicecost)) DESC) AS rank
           FROM ((public.provide pr
             JOIN public.medicalservice ms ON (((pr.serviceid)::text = (ms.serviceid)::text)))
             JOIN public.employdoctor ed ON (((pr.doctorid)::text = (ed.doctorid)::text)))
          GROUP BY ed.healthcareproviderid, ms.serviceid, ms.servicename, (EXTRACT(year FROM pr.date)), (EXTRACT(month FROM pr.date))
        )
 SELECT healthcareproviderid,
    serviceid,
    servicename,
    serviceperiod,
    totaluses,
    totalgenerated
   FROM rankedservices
  WHERE (rank <= 5)
  ORDER BY healthcareproviderid, serviceperiod, totalgenerated DESC;


ALTER VIEW public.top5monthlyservicesummary OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 28613)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    userid integer NOT NULL,
    externalid character varying(10) NOT NULL,
    username character varying(100) NOT NULL,
    passwordhash character varying(100) NOT NULL,
    role character varying(20) NOT NULL,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT role_check CHECK (((role)::text = ANY (ARRAY[('Employee'::character varying)::text, ('Client'::character varying)::text, ('Agent'::character varying)::text, ('Doctor'::character varying)::text, ('HealthcareProvider'::character varying)::text]))),
    CONSTRAINT users_role_check CHECK (((role)::text = ANY (ARRAY[('Employee'::character varying)::text, ('Client'::character varying)::text, ('Agent'::character varying)::text, ('Doctor'::character varying)::text, ('HealthcareProvider'::character varying)::text])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 28619)
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_userid_seq OWNER TO postgres;

--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 246
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;


--
-- TOC entry 4818 (class 2604 OID 28829)
-- Name: users userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);


--
-- TOC entry 5093 (class 0 OID 28461)
-- Dependencies: 215
-- Data for Name: agent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.agent (agentid, agentname, commissionrate, email, licensenumber, phonenumber) FROM stdin;
AGT00001	Rami Hbeish	5.00	rami.h@email.com	L001	71234567
AGT00002	Nour Youssef	6.00	nour.y@email.com	L002	71234568
AGT00003	Leila Bahji	4.00	leila.b@email.com	L003	71234569
AGT00004	Jamil Akl	7.00	jamil.a@email.com	L004	71234570
AGT00005	Mira Khamis	5.00	mira.k@email.com	L005	71234571
AGT00006	Sami Zaatari	6.00	sami.z@email.com	L006	71234572
AGT00007	Nadine Qassem	5.00	nadine.q@email.com	L007	71234573
AGT00008	Tarek Soufi	4.00	tarek.s@email.com	L008	71234574
AGT00009	Hala Chams	5.00	hala.c@email.com	L009	71234575
AGT00010	Ziad Dabbous	6.00	ziad.d@email.com	L010	71234576
\.


--
-- TOC entry 5096 (class 0 OID 28483)
-- Dependencies: 220
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (clientid, firstname, middlename, lastname, dob, gender, email) FROM stdin;
CLI00001	Ali	Jamal	Hajj	1985-02-14	M	ali.hajj@email.com
CLI00002	Lina	Samir	Karam	1990-08-25	F	lina.karam@email.com
CLI00003	Omar	Fouad	Nasr	1987-11-03	M	omar.nasr@email.com
CLI00004	Nour	Rami	Daher	1992-07-19	F	nour.daher@email.com
CLI00005	Rami	Khaled	Saab	1983-05-30	M	rami.saab@email.com
CLI00006	Hiba	Ahmad	Sayegh	1988-12-12	F	hiba.sayegh@email.com
CLI00007	Samir	Fadi	Youssef	1991-01-22	M	samir.youssef@email.com
CLI00008	Layal	Tarek	Khalil	1989-04-15	F	layal.khalil@email.com
CLI00009	Karim	Walid	Assaf	1993-09-17	M	karim.assaf@email.com
CLI00010	Nadine	Ziad	Jaber	1995-03-08	F	nadine.jaber@email.com
\.


--
-- TOC entry 5097 (class 0 OID 28489)
-- Dependencies: 221
-- Data for Name: clientaddress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientaddress (clientid, address) FROM stdin;
CLI00001	15 Cedar Rd, Beirut
CLI00002	28 Maple St, Tripoli
CLI00003	34 Pine Ave, Sidon
CLI00004	56 Jasmine St, Tyre
CLI00004	Banque du Liban, Riad El Solh, Beirut
CLI00005	78 Olive Rd, Zahle
CLI00006	90 Palm Ave, Baabda
CLI00007	12 Cedar Blvd, Byblos
CLI00008	23 Rose Ln, Jounieh
CLI00009	45 Oak St, Nabatieh
CLI00010	67 Birch Ave, Aley
\.


--
-- TOC entry 5098 (class 0 OID 28494)
-- Dependencies: 222
-- Data for Name: clientdependent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientdependent (clientid, firstname, middlename, lastname, dob, gender, relationship) FROM stdin;
CLI00001	Cynthia	Ali	Hajj	2000-01-01	F	Daughter
CLI00001	Dana	Ali	Hajj	2002-02-02	F	Daughter
CLI00003	Ahmad	Omar	Nasr	2001-03-03	M	Son
CLI00005	Elie	Rami	Saab	2003-04-04	M	Son
CLI00007	Sam	Samir	Youssef	2004-05-05	M	Son
CLI00007	Layal	Samir	Youssef	2006-06-06	F	Daughter
CLI00010	Abed	Tarek	Bader	2002-07-07	M	Son
CLI00004	Ghazi	Saad	Batrouni	2001-08-08	M	Son
CLI00006	Nada	Dani	Kanj	2003-09-09	F	Daughter
CLI00006	Kamal	Dani	Kanj	2005-10-10	M	Son
\.


--
-- TOC entry 5099 (class 0 OID 28500)
-- Dependencies: 223
-- Data for Name: clientphonenumber; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientphonenumber (clientid, phonenumber) FROM stdin;
CLI00001	71234567
CLI00001	01860123
CLI00002	70345678
CLI00003	71456789
CLI00004	70567890
CLI00005	71678901
CLI00006	70789012
CLI00007	71890123
CLI00008	70901234
CLI00009	71234567
CLI00010	70345678
\.


--
-- TOC entry 5106 (class 0 OID 28541)
-- Dependencies: 232
-- Data for Name: covers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.covers (insuranceplanname, healthcareproviderid) FROM stdin;
Basic Health Plan	HCP00001
Flexible Care Plan	HCP00001
Essential Coverage	HCP00002
Comprehensive Plan	HCP00003
Essential Coverage	HCP00004
High Deductible Health Plan	HCP00005
Family Protection Plan	HCP00006
Premium Wellness Plan	HCP00007
Student Health Plan	HCP00008
Senior Advantage Plan	HCP00009
Preventive Care Plan	HCP00010
Premium Wellness Plan	HCP00010
\.


--
-- TOC entry 5100 (class 0 OID 28503)
-- Dependencies: 224
-- Data for Name: doctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor (doctorid, firstname, middlename, lastname, email, phonenumber, supervisorhealthcareproviderid) FROM stdin;
DOC00001	Ahmad	Khaled	Khoury	ahmad.khoury@email.com	03456789	HCP00001
DOC00002	Layla	Samir	Kabbani	layla.hariri@email.com	03567890	HCP00002
DOC00003	Ziad	Omar	Rahme	ziad.rahme@email.com	03678901	HCP00003
DOC00004	Rania	Fouad	Jabbour	rania.jabbour@email.com	03789012	HCP00004
DOC00005	Samir	Jamil	Fahed	samir.fahed@email.com	03890123	HCP00005
DOC00006	Dalia	Ziad	Ghanem	dalia.ghanem@email.com	03901234	HCP00006
DOC00007	Omar	Tariq	Husseini	omar.husseini@email.com	03012345	HCP00007
DOC00008	Nour	Sami	Itani	nour.aoun@email.com	03123456	HCP00008
DOC00009	Hiba	Rami	Kassem	hiba.kassem@email.com	03234567	HCP00009
DOC00010	Yara	Ali	Najm	yara.najm@email.com	03345678	HCP00010
\.


--
-- TOC entry 5107 (class 0 OID 28544)
-- Dependencies: 233
-- Data for Name: doctorspecialization; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctorspecialization (doctorid, specialization) FROM stdin;
DOC00001	Cardiology
DOC00001	Internal Medicine
DOC00002	Pediatrics
DOC00003	Orthopedics
DOC00003	Sports Medicine
DOC00004	Obstetrics
DOC00004	Gynecology
DOC00005	Dermatology
DOC00006	Psychiatry
DOC00006	Neurology
DOC00007	General Surgery
DOC00008	Family Medicine
DOC00009	Dentistry
DOC00010	Ophthalmology
\.


--
-- TOC entry 5101 (class 0 OID 28507)
-- Dependencies: 225
-- Data for Name: employdoctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employdoctor (healthcareproviderid, doctorid) FROM stdin;
HCP00001	DOC00001
HCP00001	DOC00005
HCP00002	DOC00002
HCP00003	DOC00003
HCP00004	DOC00004
HCP00005	DOC00006
HCP00006	DOC00007
HCP00007	DOC00008
HCP00008	DOC00009
HCP00009	DOC00010
\.


--
-- TOC entry 5108 (class 0 OID 28547)
-- Dependencies: 234
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (employeeid, firstname, middlename, lastname, phonenumber, email, address, salary, jobtitle) FROM stdin;
EMP00001	Omar	Khaled	Haddad	712345678	omar.haddad@procare.com	12 Main St, Beirut	1500.00	Software Developer
EMP00002	Layla	Samir	Kassem	703456789	layla.kassem@procare.com	34 Elm St, Tripoli	1800.00	Claims Manager
EMP00003	Ziad	Rami	Nassar	714567890	ziad.nassar@procare.com	56 Cedar St, Sidon	2000.00	Marketing Specialist
EMP00004	Hana	Nour	Jebril	705678901	hana.jebril@procare.com	78 Olive St, Tyre	1700.00	HR Coordinator
EMP00005	Fadi	Joe	Salameh	716789012	fadi.salameh@procare.com	90 Palm St, Baabda	1600.00	Claims Specialist
EMP00006	Rania	Tarek	Matar	707890123	rania.matar@procare.com	23 Jasmine St, Zahle	1900.00	UX Designer
EMP00008	Dalia	Ziad	Sayegh	709012345	dalia.sayegh@procare.com	67 Orchid St, Jounieh	1750.00	Customer Service Rep
EMP00009	Noor	Fadi	Ghazal	718912345	noor.ghazal@procare.com	89 Pinetree St, Beirut	2200.00	Account Manager
EMP00010	Sami	Omar	Shams	712345670	sami.shams@procare.com	44 Sunset Ave, Tripoli	1850.00	Financial Coordinator
EMP00007	Karim	Ali	Bou Khalil	718901234	karim.boukhallil@procare.com	45 Rose St, Byblos	2100.00	Sales Executive
\.


--
-- TOC entry 5109 (class 0 OID 28554)
-- Dependencies: 235
-- Data for Name: employeedependent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employeedependent (employeeid, firstname, middlename, lastname, dob, gender, relationship) FROM stdin;
EMP00001	Khaled	Omar	Haddad	2010-05-15	M	Son
EMP00002	Tia	Hadi	Saab	2012-08-20	M	Son
EMP00003	Rami	Ziad	Nassar	2008-03-12	M	Son
EMP00004	Latifa	Abed	Bakri	1957-07-25	F	Parent
EMP00005	Anthony	Fadi	Salameh	2011-09-30	M	Son
EMP00006	Omar	Sami	Mansour	2013-06-10	M	Son
EMP00007	Dalia	Karim	Issa	2009-11-05	F	Daughter
EMP00008	Ziad	Jad	Sabbagh	2014-02-28	M	Son
EMP00009	Fadi	Ayman	Ghazal	1960-04-14	M	Parent
EMP00010	Yara	Sami	Shams	2012-12-18	F	Daughter
\.


--
-- TOC entry 5102 (class 0 OID 28510)
-- Dependencies: 226
-- Data for Name: healthcareprovider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.healthcareprovider (healthcareproviderid, providername, providertype, phonenumber, address) FROM stdin;
HCP00001	HealthFirst Clinic	Clinic	01234567123	Wellness St, Ashrafieh, Beirut
HCP00002	CarePlus Hospital	Hospital	01345678456	Care Rd, Hamra, Beirut
HCP00003	MediQuick Pharmacy	Pharmacy	01456789789	Rx Ave, Jdeideh, Beirut
HCP00004	Family Health Center	Clinic	01567890101	Family Ln, Tripoli
HCP00005	Wellness Medical Group	Specialist Center	01678901202	Health Dr, Sidon
HCP00006	Emergency Care Unit	Hospital	01789012303	Urgent St, Zahle
HCP00007	Pediatric Specialists	Specialist Center	01890123404	Kids Blvd, Byblos
HCP00008	Senior Health Services	Home Care	01901234505	Elder St, Baabda
HCP00009	Dental Wellness Center	Dental Clinic	01012345606	Smile St, Bekaa
HCP00010	Vision Care Center	Specialist Center	01123456707	Sight St, Nabatieh
\.


--
-- TOC entry 5110 (class 0 OID 28560)
-- Dependencies: 236
-- Data for Name: insuranceplan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insuranceplan (insuranceplanname, plantype, description, coveragelevel, premium, deductible) FROM stdin;
Basic Health Plan	HMO	Provides comprehensive health coverage	Silver	200.00	1000.00
Flexible Care Plan	PPO	Offers flexibility in choosing healthcare providers	Gold	300.00	500.00
Comprehensive Plan	POS	Combines HMO and PPO features for more options	Platinum	350.00	300.00
Essential Coverage	EPO	Covers essential health benefits with no out-of-network coverage	Bronze	180.00	1500.00
High Deductible Health Plan	HDHP	Lower premiums with higher deductibles for catastrophic coverage	Bronze	150.00	2500.00
Family Protection Plan	HMO	Family-focused plan with low out-of-pocket costs	Silver	250.00	750.00
Premium Wellness Plan	PPO	High-level coverage with extensive provider network	Platinum	400.00	250.00
Student Health Plan	EPO	Designed for students, with essential coverage	Gold	150.00	1200.00
Senior Advantage Plan	HMO	Tailored for seniors, includes wellness programs	Gold	220.00	800.00
Preventive Care Plan	POS	Focused on preventive care and routine checkups	Silver	170.00	1000.00
\.


--
-- TOC entry 5112 (class 0 OID 28590)
-- Dependencies: 241
-- Data for Name: medicalrecords; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicalrecords (clientid, icdcode, datecreated, conditionname, description) FROM stdin;
CLI00001	A01.0	2024-01-15	Typhoid Fever	Acute bacterial infection
CLI00002	J20.9	2023-11-20	Acute Bronchitis	Inflammation of the bronchial tubes
CLI00003	E11.9	2024-02-03	Type 2 Diabetes	Chronic condition affecting metabolism
CLI00004	I10	2023-05-18	Essential Hypertension	High blood pressure
CLI00005	K21.9	2023-08-22	Gastroesophageal Reflux	Acid reflux in the esophagus
CLI00006	L50.0	2024-03-10	Urticaria	Condition with red, itchy welts
CLI00007	M54.5	2024-06-15	Low Back Pain	Pain in the lower back region
CLI00008	F32.9	2023-09-12	Major Depressive Disorder	Persistent feeling of sadness
CLI00009	N39.0	2024-04-25	Urinary Tract Infection	Bacterial infection in the urinary tract
CLI00010	H52.4	2023-12-30	Presbyopia	Age-related difficulty in seeing close objects
\.


--
-- TOC entry 5103 (class 0 OID 28515)
-- Dependencies: 227
-- Data for Name: medicalservice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicalservice (serviceid, servicename, description) FROM stdin;
MDS00001	General Check-up	Routine examination to assess overall health.
MDS00002	Blood Test	Laboratory analysis to evaluate blood conditions.
MDS00003	X-ray	Imaging technique to view bones and structures.
MDS00004	MRI Scan	Advanced imaging for detailed body analysis.
MDS00005	Physical Therapy	Rehabilitation treatment to improve mobility.
MDS00006	Vaccination	Immunization to prevent diseases.
MDS00007	Allergy Testing	Tests to identify specific allergies.
MDS00008	Ultrasound	Imaging technique using sound waves for diagnosis.
MDS00009	Surgical Consultation	Evaluation and planning for potential surgery.
MDS00010	Dermatology Services	Treatment for skin-related issues.
\.


--
-- TOC entry 5111 (class 0 OID 28572)
-- Dependencies: 238
-- Data for Name: pays; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pays (employeeid, clientid, date, amount, purpose) FROM stdin;
EMP00008	CLI00001	2024-01-10	500.00	Service Fees
EMP00009	CLI00002	2024-02-15	750.00	Claims Processing Fee
EMP00010	CLI00003	2024-03-05	300.00	Policy Issuance Fee
EMP00010	CLI00004	2024-03-20	600.00	Annual Premium Payment
EMP00009	CLI00005	2024-04-08	450.00	Risk Assessment Fee
EMP00008	CLI00006	2024-04-25	800.00	Insurance Consultation Fee
EMP00008	CLI00007	2024-05-12	700.00	Claims Adjustment Fee
EMP00008	CLI00008	2024-06-01	400.00	Coverage Modification Fee
EMP00010	CLI00009	2024-06-18	550.00	Insurance Renewal Fee
EMP00009	CLI00010	2024-07-10	650.00	Services Fees
\.


--
-- TOC entry 5094 (class 0 OID 28466)
-- Dependencies: 216
-- Data for Name: policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.policy (policynumber, exactcost, startdate, enddate, insuranceplanname) FROM stdin;
PNM00001	500.00	2024-01-01	2024-12-31	Basic Health Plan
PNM00002	750.00	2024-02-01	2025-01-31	Flexible Care Plan
PNM00003	1200.00	2024-03-01	2025-02-28	Comprehensive Plan
PNM00004	400.00	2024-04-01	2024-10-01	Essential Coverage
PNM00005	1000.00	2024-05-01	2025-04-30	High Deductible Health Plan
PNM00006	600.00	2024-06-01	2025-05-31	Family Protection Plan
PNM00007	800.00	2024-07-01	2025-06-30	Premium Wellness Plan
PNM00008	350.00	2024-08-01	2024-11-30	Student Health Plan
PNM00009	550.00	2024-09-01	2025-08-31	Senior Advantage Plan
PNM00010	450.00	2024-10-01	2025-09-30	Preventive Care Plan
\.


--
-- TOC entry 5104 (class 0 OID 28520)
-- Dependencies: 228
-- Data for Name: provide; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provide (clientid, doctorid, serviceid, date, servicecost) FROM stdin;
CLI00005	DOC00003	MDS00001	2024-10-01	100.00
CLI00002	DOC00007	MDS00006	2024-10-02	150.00
CLI00009	DOC00001	MDS00004	2024-10-03	200.00
CLI00001	DOC00008	MDS00002	2024-10-04	400.00
CLI00010	DOC00005	MDS00007	2024-10-05	250.00
CLI00004	DOC00002	MDS00005	2024-10-06	80.00
CLI00006	DOC00009	MDS00008	2024-10-07	120.00
CLI00003	DOC00010	MDS00009	2024-10-08	300.00
CLI00008	DOC00006	MDS00003	2024-10-09	500.00
CLI00007	DOC00004	MDS00010	2024-10-10	90.00
CLI00005	DOC00001	MDS00001	2024-10-01	100.00
CLI00002	DOC00001	MDS00010	2024-10-02	150.00
CLI00009	DOC00001	MDS00004	2024-10-04	200.00
CLI00001	DOC00005	MDS00002	2024-10-04	400.00
CLI00010	DOC00005	MDS00009	2024-10-05	250.00
CLI00004	DOC00001	MDS00005	2024-10-06	80.00
CLI00006	DOC00001	MDS00008	2024-10-07	120.00
CLI00008	DOC00005	MDS00003	2024-10-09	500.00
\.


--
-- TOC entry 5113 (class 0 OID 28598)
-- Dependencies: 242
-- Data for Name: refer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refer (clientid, referringdoctorid, referreddoctorid, date, reason) FROM stdin;
CLI00001	DOC00001	DOC00002	2024-10-01	Specialist Consultation
CLI00002	DOC00002	DOC00003	2024-10-02	Further Evaluation
CLI00003	DOC00003	DOC00004	2024-10-03	Surgical Assessment
CLI00004	DOC00004	DOC00005	2024-10-04	Dermatological Concern
CLI00005	DOC00005	DOC00006	2024-10-05	Mental Health Evaluation
CLI00006	DOC00006	DOC00007	2024-10-06	Neurological Assessment
CLI00007	DOC00007	DOC00008	2024-10-07	Family Medicine Follow-up
CLI00008	DOC00008	DOC00009	2024-10-08	Dental Issues
CLI00009	DOC00009	DOC00010	2024-10-09	Vision Check
CLI00010	DOC00010	DOC00001	2024-10-10	General Health Review
\.


--
-- TOC entry 5105 (class 0 OID 28530)
-- Dependencies: 230
-- Data for Name: requestclaim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requestclaim (employeeid, clientid, datecreated, amount, approvalstatus, decisiondate) FROM stdin;
EMP00005	CLI00001	2024-01-05	250.00	Approved	2024-01-10
EMP00002	CLI00002	2024-02-12	500.00	Approved	2024-02-15
EMP00002	CLI00003	2024-03-01	300.00	Pending	\N
EMP00002	CLI00004	2024-03-18	450.00	Approved	2024-03-20
EMP00005	CLI00005	2024-04-05	600.00	Denied	2024-04-08
EMP00002	CLI00006	2024-04-20	400.00	Approved	2024-04-25
EMP00005	CLI00007	2024-05-10	700.00	Pending	\N
EMP00005	CLI00008	2024-06-02	550.00	Approved	2024-06-05
EMP00002	CLI00009	2024-06-15	250.00	Denied	2024-06-18
EMP00002	CLI00010	2024-07-01	650.00	Approved	2024-07-10
EMP00008	CLI00001	2024-11-08	25000.00	Rejected	\N
EMP00009	CLI00001	2024-11-06	25000.00	Rejected	\N
EMP00008	CLI00001	2024-11-07	25000.00	Rejected	\N
EMP00001	CLI00001	2024-10-08	50000.00	Rejected	\N
EMP00008	CLI00001	2024-10-08	25000.00	Rejected	\N
EMP00009	CLI00001	2024-11-16	25000.00	Rejected	\N
EMP00008	CLI00001	2024-09-07	25000.00	Rejected	\N
EMP00008	CLI00001	2024-09-08	25000.00	Rejected	\N
EMP00009	CLI00001	2024-11-10	25000.00	Rejected	\N
EMP00008	CLI00001	2024-11-17	25000.00	Rejected	\N
EMP00001	CLI00001	2024-11-18	50000.00	Rejected	\N
\.


--
-- TOC entry 5114 (class 0 OID 28604)
-- Dependencies: 243
-- Data for Name: requestdoctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requestdoctor (clientid, doctorid, healthcareproviderid, date) FROM stdin;
CLI00001	DOC00001	HCP00001	2024-10-01
CLI00002	DOC00002	HCP00002	2024-10-02
CLI00003	DOC00003	HCP00003	2024-10-03
CLI00004	DOC00004	HCP00004	2024-10-04
CLI00005	DOC00005	HCP00005	2024-10-05
CLI00006	DOC00006	HCP00006	2024-10-06
CLI00007	DOC00007	HCP00007	2024-10-07
CLI00008	DOC00008	HCP00008	2024-10-08
CLI00009	DOC00009	HCP00009	2024-10-09
CLI00010	DOC00010	HCP00010	2024-10-10
\.


--
-- TOC entry 5095 (class 0 OID 28471)
-- Dependencies: 217
-- Data for Name: sell; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sell (clientid, policynumber, agentid) FROM stdin;
CLI00001	PNM00005	AGT00002
CLI00002	PNM00010	AGT00002
CLI00003	PNM00001	AGT00001
CLI00004	PNM00006	AGT00004
CLI00005	PNM00002	AGT00005
CLI00006	PNM00007	AGT00005
CLI00007	PNM00003	AGT00007
CLI00008	PNM00009	AGT00008
CLI00009	PNM00004	AGT00009
CLI00010	PNM00008	AGT00010
\.


--
-- TOC entry 5115 (class 0 OID 28613)
-- Dependencies: 245
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (userid, externalid, username, passwordhash, role, createdat) FROM stdin;
1	EMP00001	omar.haddad@procare.com	$2b$12$examplehashstring	Employee	2024-11-22 17:39:02.317401
2	EMP00002	layla.kassem@procare.com	$2b$12$examplehashstring	Employee	2024-11-22 17:39:02.317401
3	EMP00003	ziad.nassar@procare.com	$2b$12$examplehashstring	Employee	2024-11-22 17:39:02.317401
4	EMP00004	hana.jebril@procare.com	$2b$12$examplehashstring	Employee	2024-11-22 17:39:02.317401
5	EMP00005	fadi.salameh@procare.com	$2b$12$examplehashstring	Employee	2024-11-22 17:39:02.317401
6	EMP00006	rania.matar@procare.com	$2b$12$examplehashstring	Employee	2024-11-22 17:39:02.317401
7	EMP00007	karim.boukhallil@procare.com	$2b$12$examplehashstring	Employee	2024-11-22 17:39:02.317401
8	EMP00008	dalia.sayegh@procare.com	$2b$12$examplehashstring	Employee	2024-11-22 17:39:02.317401
9	EMP00009	noor.ghazal@procare.com	$2b$12$examplehashstring	Employee	2024-11-22 17:39:02.317401
10	EMP00010	sami.shams@procare.com	$2b$12$examplehashstring	Employee	2024-11-22 17:39:02.317401
11	CLI00001	ali.hajj@email.com	$2b$12$examplehashstring	Client	2024-11-22 17:39:14.213381
12	CLI00002	lina.karam@email.com	$2b$12$examplehashstring	Client	2024-11-22 17:39:14.213381
13	CLI00003	omar.nasr@email.com	$2b$12$examplehashstring	Client	2024-11-22 17:39:14.213381
14	CLI00004	nour.daher@email.com	$2b$12$examplehashstring	Client	2024-11-22 17:39:14.213381
15	CLI00005	rami.saab@email.com	$2b$12$examplehashstring	Client	2024-11-22 17:39:14.213381
16	CLI00006	hiba.sayegh@email.com	$2b$12$examplehashstring	Client	2024-11-22 17:39:14.213381
17	CLI00007	samir.youssef@email.com	$2b$12$examplehashstring	Client	2024-11-22 17:39:14.213381
18	CLI00008	layal.khalil@email.com	$2b$12$examplehashstring	Client	2024-11-22 17:39:14.213381
19	CLI00009	karim.assaf@email.com	$2b$12$examplehashstring	Client	2024-11-22 17:39:14.213381
20	CLI00010	nadine.jaber@email.com	$2b$12$examplehashstring	Client	2024-11-22 17:39:14.213381
21	AGT00001	rami.h@email.com	$2b$12$examplehashstring	Agent	2024-11-22 17:39:19.388333
22	AGT00002	nour.y@email.com	$2b$12$examplehashstring	Agent	2024-11-22 17:39:19.388333
23	AGT00003	leila.b@email.com	$2b$12$examplehashstring	Agent	2024-11-22 17:39:19.388333
24	AGT00004	jamil.a@email.com	$2b$12$examplehashstring	Agent	2024-11-22 17:39:19.388333
25	AGT00005	mira.k@email.com	$2b$12$examplehashstring	Agent	2024-11-22 17:39:19.388333
26	AGT00006	sami.z@email.com	$2b$12$examplehashstring	Agent	2024-11-22 17:39:19.388333
27	AGT00007	nadine.q@email.com	$2b$12$examplehashstring	Agent	2024-11-22 17:39:19.388333
28	AGT00008	tarek.s@email.com	$2b$12$examplehashstring	Agent	2024-11-22 17:39:19.388333
29	AGT00009	hala.c@email.com	$2b$12$examplehashstring	Agent	2024-11-22 17:39:19.388333
30	AGT00010	ziad.d@email.com	$2b$12$examplehashstring	Agent	2024-11-22 17:39:19.388333
31	DOC00001	ahmad.khoury@email.com	$2b$12$examplehashstring	Doctor	2024-11-22 17:39:31.48541
32	DOC00002	layla.hariri@email.com	$2b$12$examplehashstring	Doctor	2024-11-22 17:39:31.48541
33	DOC00003	ziad.rahme@email.com	$2b$12$examplehashstring	Doctor	2024-11-22 17:39:31.48541
34	DOC00004	rania.jabbour@email.com	$2b$12$examplehashstring	Doctor	2024-11-22 17:39:31.48541
35	DOC00005	samir.fahed@email.com	$2b$12$examplehashstring	Doctor	2024-11-22 17:39:31.48541
36	DOC00006	dalia.ghanem@email.com	$2b$12$examplehashstring	Doctor	2024-11-22 17:39:31.48541
37	DOC00007	omar.husseini@email.com	$2b$12$examplehashstring	Doctor	2024-11-22 17:39:31.48541
38	DOC00008	nour.aoun@email.com	$2b$12$examplehashstring	Doctor	2024-11-22 17:39:31.48541
39	DOC00009	hiba.kassem@email.com	$2b$12$examplehashstring	Doctor	2024-11-22 17:39:31.48541
40	DOC00010	yara.najm@email.com	$2b$12$examplehashstring	Doctor	2024-11-22 17:39:31.48541
42	HCP00001	healthfirst.clinic@healthcare.com	$2b$12$examplehashstring	HealthcareProvider	2024-11-22 18:23:35.537722
43	HCP00002	careplus.hospital@healthcare.com	$2b$12$examplehashstring	HealthcareProvider	2024-11-22 18:23:35.537722
44	HCP00003	mediquick.pharmacy@healthcare.com	$2b$12$examplehashstring	HealthcareProvider	2024-11-22 18:23:35.537722
45	HCP00004	family.health.center@healthcare.com	$2b$12$examplehashstring	HealthcareProvider	2024-11-22 18:23:35.537722
46	HCP00005	wellness.medical.group@healthcare.com	$2b$12$examplehashstring	HealthcareProvider	2024-11-22 18:23:35.537722
47	HCP00006	emergency.care.unit@healthcare.com	$2b$12$examplehashstring	HealthcareProvider	2024-11-22 18:23:35.537722
48	HCP00007	pediatric.specialists@healthcare.com	$2b$12$examplehashstring	HealthcareProvider	2024-11-22 18:23:35.537722
49	HCP00008	senior.health.services@healthcare.com	$2b$12$examplehashstring	HealthcareProvider	2024-11-22 18:23:35.537722
50	HCP00009	dental.wellness.center@healthcare.com	$2b$12$examplehashstring	HealthcareProvider	2024-11-22 18:23:35.537722
51	HCP00010	vision.care.center@healthcare.com	$2b$12$examplehashstring	HealthcareProvider	2024-11-22 18:23:35.537722
\.


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 246
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_userid_seq', 51, true);


--
-- TOC entry 4844 (class 2606 OID 28622)
-- Name: agent agent_licensenumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_licensenumber_key UNIQUE (licensenumber);


--
-- TOC entry 4846 (class 2606 OID 28624)
-- Name: agent agent_phonenumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_phonenumber_key UNIQUE (phonenumber);


--
-- TOC entry 4848 (class 2606 OID 28626)
-- Name: agent agent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_pkey PRIMARY KEY (agentid);


--
-- TOC entry 4858 (class 2606 OID 28628)
-- Name: clientaddress client_address_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientaddress
    ADD CONSTRAINT client_address_id PRIMARY KEY (clientid, address);


--
-- TOC entry 4860 (class 2606 OID 28630)
-- Name: clientdependent client_dependent_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientdependent
    ADD CONSTRAINT client_dependent_id PRIMARY KEY (clientid, firstname, middlename, lastname);


--
-- TOC entry 4862 (class 2606 OID 28632)
-- Name: clientphonenumber client_phone_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientphonenumber
    ADD CONSTRAINT client_phone_id PRIMARY KEY (clientid, phonenumber);


--
-- TOC entry 4855 (class 2606 OID 28634)
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (clientid);


--
-- TOC entry 4881 (class 2606 OID 28636)
-- Name: covers coverage_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.covers
    ADD CONSTRAINT coverage_id PRIMARY KEY (insuranceplanname, healthcareproviderid);


--
-- TOC entry 4864 (class 2606 OID 28638)
-- Name: doctor doctor_phonenumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_phonenumber_key UNIQUE (phonenumber);


--
-- TOC entry 4866 (class 2606 OID 28640)
-- Name: doctor doctor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_pkey PRIMARY KEY (doctorid);


--
-- TOC entry 4900 (class 2606 OID 28642)
-- Name: requestdoctor doctor_request_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT doctor_request_id PRIMARY KEY (clientid, doctorid, healthcareproviderid, date);


--
-- TOC entry 4869 (class 2606 OID 28644)
-- Name: employdoctor employ_doctor_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT employ_doctor_id PRIMARY KEY (healthcareproviderid, doctorid);


--
-- TOC entry 4890 (class 2606 OID 28646)
-- Name: employeedependent employee_dependent_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employeedependent
    ADD CONSTRAINT employee_dependent_id PRIMARY KEY (employeeid, firstname, middlename, lastname);


--
-- TOC entry 4885 (class 2606 OID 28648)
-- Name: employee employee_phonenumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_phonenumber_key UNIQUE (phonenumber);


--
-- TOC entry 4887 (class 2606 OID 28650)
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employeeid);


--
-- TOC entry 4871 (class 2606 OID 28652)
-- Name: healthcareprovider healthcareprovider_phonenumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcareprovider
    ADD CONSTRAINT healthcareprovider_phonenumber_key UNIQUE (phonenumber);


--
-- TOC entry 4873 (class 2606 OID 28654)
-- Name: healthcareprovider healthcareprovider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcareprovider
    ADD CONSTRAINT healthcareprovider_pkey PRIMARY KEY (healthcareproviderid);


--
-- TOC entry 4892 (class 2606 OID 28656)
-- Name: insuranceplan insuranceplan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insuranceplan
    ADD CONSTRAINT insuranceplan_pkey PRIMARY KEY (insuranceplanname);


--
-- TOC entry 4896 (class 2606 OID 28658)
-- Name: medicalrecords medical_record_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicalrecords
    ADD CONSTRAINT medical_record_id PRIMARY KEY (clientid, icdcode);


--
-- TOC entry 4875 (class 2606 OID 28660)
-- Name: medicalservice medicalservice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicalservice
    ADD CONSTRAINT medicalservice_pkey PRIMARY KEY (serviceid);


--
-- TOC entry 4894 (class 2606 OID 28662)
-- Name: pays payment_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pays
    ADD CONSTRAINT payment_id PRIMARY KEY (employeeid, clientid, date);


--
-- TOC entry 4851 (class 2606 OID 28664)
-- Name: policy policy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policy
    ADD CONSTRAINT policy_pkey PRIMARY KEY (policynumber);


--
-- TOC entry 4877 (class 2606 OID 28666)
-- Name: provide provided_service_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provide
    ADD CONSTRAINT provided_service_id PRIMARY KEY (clientid, doctorid, serviceid, date);


--
-- TOC entry 4898 (class 2606 OID 28668)
-- Name: refer referal_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refer
    ADD CONSTRAINT referal_id PRIMARY KEY (clientid, referringdoctorid, referreddoctorid, date);


--
-- TOC entry 4879 (class 2606 OID 28670)
-- Name: requestclaim request_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT request_id PRIMARY KEY (employeeid, clientid, datecreated);


--
-- TOC entry 4853 (class 2606 OID 28672)
-- Name: sell sell_transaction_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sell
    ADD CONSTRAINT sell_transaction_id PRIMARY KEY (clientid, policynumber, agentid);


--
-- TOC entry 4883 (class 2606 OID 28674)
-- Name: doctorspecialization specialization_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctorspecialization
    ADD CONSTRAINT specialization_id PRIMARY KEY (doctorid, specialization);


--
-- TOC entry 4902 (class 2606 OID 28676)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- TOC entry 4904 (class 2606 OID 28678)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4849 (class 1259 OID 28679)
-- Name: unique_email_agent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_email_agent ON public.agent USING btree (lower((email)::text));


--
-- TOC entry 4856 (class 1259 OID 28680)
-- Name: unique_email_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_email_client ON public.client USING btree (lower((email)::text));


--
-- TOC entry 4867 (class 1259 OID 28681)
-- Name: unique_email_doctor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_email_doctor ON public.doctor USING btree (lower((email)::text));


--
-- TOC entry 4888 (class 1259 OID 28682)
-- Name: unique_email_employee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_email_employee ON public.employee USING btree (lower((email)::text));


--
-- TOC entry 4906 (class 2606 OID 28683)
-- Name: sell fk_agentid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_agentid FOREIGN KEY (agentid) REFERENCES public.agent(agentid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4911 (class 2606 OID 28688)
-- Name: clientphonenumber fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientphonenumber
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4909 (class 2606 OID 28693)
-- Name: clientaddress fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientaddress
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4926 (class 2606 OID 28698)
-- Name: medicalrecords fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicalrecords
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4918 (class 2606 OID 28703)
-- Name: requestclaim fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4924 (class 2606 OID 28708)
-- Name: pays fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pays
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4910 (class 2606 OID 28713)
-- Name: clientdependent fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientdependent
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON DELETE CASCADE;


--
-- TOC entry 4915 (class 2606 OID 28718)
-- Name: provide fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4930 (class 2606 OID 28723)
-- Name: requestdoctor fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4927 (class 2606 OID 28728)
-- Name: refer fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4907 (class 2606 OID 28733)
-- Name: sell fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4922 (class 2606 OID 28738)
-- Name: doctorspecialization fk_doctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctorspecialization
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4913 (class 2606 OID 28743)
-- Name: employdoctor fk_doctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4916 (class 2606 OID 28748)
-- Name: provide fk_doctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON DELETE SET NULL;


--
-- TOC entry 4931 (class 2606 OID 28753)
-- Name: requestdoctor fk_doctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4919 (class 2606 OID 28758)
-- Name: requestclaim fk_employeeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4925 (class 2606 OID 28763)
-- Name: pays fk_employeeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pays
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4923 (class 2606 OID 28768)
-- Name: employeedependent fk_employeeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employeedependent
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4912 (class 2606 OID 28773)
-- Name: doctor fk_healthcare_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT fk_healthcare_provider_id FOREIGN KEY (supervisorhealthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4914 (class 2606 OID 28778)
-- Name: employdoctor fk_healthcareproviderid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4920 (class 2606 OID 28783)
-- Name: covers fk_healthcareproviderid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.covers
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4932 (class 2606 OID 28788)
-- Name: requestdoctor fk_healthcareproviderid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4905 (class 2606 OID 28793)
-- Name: policy fk_insuranceplanname; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policy
    ADD CONSTRAINT fk_insuranceplanname FOREIGN KEY (insuranceplanname) REFERENCES public.insuranceplan(insuranceplanname) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4921 (class 2606 OID 28798)
-- Name: covers fk_insuranceplanname; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.covers
    ADD CONSTRAINT fk_insuranceplanname FOREIGN KEY (insuranceplanname) REFERENCES public.insuranceplan(insuranceplanname) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4908 (class 2606 OID 28803)
-- Name: sell fk_policynumber; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_policynumber FOREIGN KEY (policynumber) REFERENCES public.policy(policynumber) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4928 (class 2606 OID 28808)
-- Name: refer fk_referreddoctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_referreddoctorid FOREIGN KEY (referreddoctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4929 (class 2606 OID 28813)
-- Name: refer fk_referringdoctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_referringdoctorid FOREIGN KEY (referringdoctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4917 (class 2606 OID 28818)
-- Name: provide fk_serviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_serviceid FOREIGN KEY (serviceid) REFERENCES public.medicalservice(serviceid) ON DELETE SET NULL;


--
-- TOC entry 5084 (class 0 OID 28461)
-- Dependencies: 215
-- Name: agent; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.agent ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5088 (class 3256 OID 28823)
-- Name: agent agent_access_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY agent_access_policy ON public.agent USING (true);


--
-- TOC entry 5089 (class 3256 OID 28824)
-- Name: agent agent_row_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY agent_row_policy ON public.agent USING (((email)::text = CURRENT_USER));


--
-- TOC entry 5085 (class 0 OID 28483)
-- Dependencies: 220
-- Name: client; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.client ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5090 (class 3256 OID 28825)
-- Name: client client_row_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY client_row_policy ON public.client USING (((email)::text = CURRENT_USER));


--
-- TOC entry 5091 (class 3256 OID 28826)
-- Name: healthcareprovider healthcare_provider_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY healthcare_provider_policy ON public.healthcareprovider USING (((lower(replace((providername)::text, ' '::text, '.'::text)) || '@healthcare.com'::text) = CURRENT_USER));


--
-- TOC entry 5086 (class 0 OID 28510)
-- Dependencies: 226
-- Name: healthcareprovider; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.healthcareprovider ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5092 (class 3256 OID 28827)
-- Name: requestclaim request_claim_client_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY request_claim_client_policy ON public.requestclaim USING ((((clientid)::text = (( SELECT client.clientid
   FROM public.client
  WHERE (lower((client.email)::text) = CURRENT_USER)))::text) OR (CURRENT_USER = ANY (ARRAY['fadi.salameh@procare.com'::name, 'layla.kassem@procare.com'::name]))));


--
-- TOC entry 5087 (class 0 OID 28530)
-- Dependencies: 230
-- Name: requestclaim; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.requestclaim ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE healthcareproviderclientcount; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.healthcareproviderclientcount TO hr_role;


-- Completed on 2024-11-22 21:34:58

--
-- PostgreSQL database dump complete
--

