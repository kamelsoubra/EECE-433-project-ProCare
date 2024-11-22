toc.dat                                                                                             0000600 0004000 0002000 00000150246 14720157250 0014452 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP        *            
    |            kamel    16.4    16.4 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                     0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                    0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                    1262    28460    kamel    DATABASE     �   CREATE DATABASE kamel WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE kamel;
                postgres    false         �            1259    28461    agent    TABLE     �  CREATE TABLE public.agent (
    agentid character varying(10) NOT NULL,
    agentname character varying(100) NOT NULL,
    commissionrate numeric(5,2) NOT NULL,
    email character varying(100) NOT NULL,
    licensenumber character varying(50) NOT NULL,
    phonenumber character varying(15) NOT NULL,
    CONSTRAINT agent_commissionrate_check CHECK ((commissionrate >= (0)::numeric)),
    CONSTRAINT agent_email_check CHECK (((email)::text ~ '^[A-Za-z0-9._]+@[A-Za-z0-9.]+\.[A-Za-z]{2,}$'::text))
);
    DROP TABLE public.agent;
       public         heap    postgres    false         �            1259    28466    policy    TABLE     <  CREATE TABLE public.policy (
    policynumber character varying(10) NOT NULL,
    exactcost numeric(10,2) NOT NULL,
    startdate date DEFAULT CURRENT_DATE NOT NULL,
    enddate date NOT NULL,
    insuranceplanname character varying(100),
    CONSTRAINT policy_exactcost_check CHECK ((exactcost >= (0)::numeric))
);
    DROP TABLE public.policy;
       public         heap    postgres    false         �            1259    28471    sell    TABLE     �   CREATE TABLE public.sell (
    clientid character varying(10) NOT NULL,
    policynumber character varying(10) NOT NULL,
    agentid character varying(10) NOT NULL
);
    DROP TABLE public.sell;
       public         heap    postgres    false         �            1259    28474    agentearningsannually    VIEW     G  CREATE VIEW public.agentearningsannually AS
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
 (   DROP VIEW public.agentearningsannually;
       public          postgres    false    215    215    216    216    217    217    216    217    215         �            1259    28479    agentearningsannuallyrestricted    VIEW     U  CREATE VIEW public.agentearningsannuallyrestricted AS
 SELECT agentid,
    year,
    totalclients,
    totalrevenue,
    totalcommission
   FROM public.agentearningsannually
  WHERE ((agentid)::text = (( SELECT agent.agentid
           FROM public.agent
          WHERE ((agent.email)::text = 'karim.boukhallil@procare.com'::text)))::text);
 2   DROP VIEW public.agentearningsannuallyrestricted;
       public          postgres    false    218    218    218    218    218    215    215         �            1259    28483    client    TABLE     >  CREATE TABLE public.client (
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
    DROP TABLE public.client;
       public         heap    postgres    false         �            1259    28489    clientaddress    TABLE     n   CREATE TABLE public.clientaddress (
    clientid character varying(10) NOT NULL,
    address text NOT NULL
);
 !   DROP TABLE public.clientaddress;
       public         heap    postgres    false         �            1259    28494    clientdependent    TABLE       CREATE TABLE public.clientdependent (
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
 #   DROP TABLE public.clientdependent;
       public         heap    postgres    false         �            1259    28500    clientphonenumber    TABLE     �   CREATE TABLE public.clientphonenumber (
    clientid character varying(10) NOT NULL,
    phonenumber character varying(15) NOT NULL
);
 %   DROP TABLE public.clientphonenumber;
       public         heap    postgres    false         �            1259    28503    doctor    TABLE     �  CREATE TABLE public.doctor (
    doctorid character varying(10) NOT NULL,
    firstname character varying(50) NOT NULL,
    middlename character varying(50),
    lastname character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phonenumber character varying(15),
    supervisorhealthcareproviderid character varying(10),
    CONSTRAINT doctor_email_check CHECK (((email)::text ~ '^[A-Za-z0-9._]+@[A-Za-z0-9.]+\.[A-Za-z]{2,}$'::text))
);
    DROP TABLE public.doctor;
       public         heap    postgres    false         �            1259    28507    employdoctor    TABLE     �   CREATE TABLE public.employdoctor (
    healthcareproviderid character varying(10) NOT NULL,
    doctorid character varying(10) NOT NULL
);
     DROP TABLE public.employdoctor;
       public         heap    postgres    false         �            1259    28510    healthcareprovider    TABLE       CREATE TABLE public.healthcareprovider (
    healthcareproviderid character varying(10) NOT NULL,
    providername character varying(50) NOT NULL,
    providertype character varying(50) NOT NULL,
    phonenumber character varying(15) NOT NULL,
    address text NOT NULL
);
 &   DROP TABLE public.healthcareprovider;
       public         heap    postgres    false         �            1259    28515    medicalservice    TABLE     �   CREATE TABLE public.medicalservice (
    serviceid character varying(10) NOT NULL,
    servicename character varying(100) NOT NULL,
    description text
);
 "   DROP TABLE public.medicalservice;
       public         heap    postgres    false         �            1259    28520    provide    TABLE     M  CREATE TABLE public.provide (
    clientid character varying(10) NOT NULL,
    doctorid character varying(10) NOT NULL,
    serviceid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    servicecost numeric(10,2) NOT NULL,
    CONSTRAINT provide_servicecost_check CHECK ((servicecost >= (0)::numeric))
);
    DROP TABLE public.provide;
       public         heap    postgres    false         �            1259    28525    clientservicepaymentsview    VIEW     �  CREATE VIEW public.clientservicepaymentsview AS
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
 ,   DROP VIEW public.clientservicepaymentsview;
       public          postgres    false    228    220    220    220    220    224    225    226    226    225    228    228    228    228    227    227         �            1259    28530    requestclaim    TABLE     �  CREATE TABLE public.requestclaim (
    employeeid character varying(10) NOT NULL,
    clientid character varying(10) NOT NULL,
    datecreated date DEFAULT CURRENT_DATE NOT NULL,
    amount numeric(10,2) NOT NULL,
    approvalstatus character varying(50) DEFAULT 'Pending'::character varying NOT NULL,
    decisiondate date,
    CONSTRAINT requestclaim_amount_check CHECK ((amount > (0)::numeric))
);
     DROP TABLE public.requestclaim;
       public         heap    postgres    false         �            1259    28536    clientsummaryfiltered    VIEW     �  CREATE VIEW public.clientsummaryfiltered AS
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
 (   DROP VIEW public.clientsummaryfiltered;
       public          postgres    false    220    220    220    220    230    230    230    230         �            1259    28541    covers    TABLE     �   CREATE TABLE public.covers (
    insuranceplanname character varying(100) NOT NULL,
    healthcareproviderid character varying(10) NOT NULL
);
    DROP TABLE public.covers;
       public         heap    postgres    false         �            1259    28544    doctorspecialization    TABLE     �   CREATE TABLE public.doctorspecialization (
    doctorid character varying(10) NOT NULL,
    specialization character varying(50) NOT NULL
);
 (   DROP TABLE public.doctorspecialization;
       public         heap    postgres    false         �            1259    28547    employee    TABLE     *  CREATE TABLE public.employee (
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
    DROP TABLE public.employee;
       public         heap    postgres    false                    0    0    COLUMN employee.salary    COMMENT     F   COMMENT ON COLUMN public.employee.salary IS 'Employee salary in USD';
          public          postgres    false    234         �            1259    28554    employeedependent    TABLE       CREATE TABLE public.employeedependent (
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
 %   DROP TABLE public.employeedependent;
       public         heap    postgres    false         �            1259    28560    insuranceplan    TABLE     �  CREATE TABLE public.insuranceplan (
    insuranceplanname character varying(100) NOT NULL,
    plantype character varying(50) NOT NULL,
    description text,
    coveragelevel character varying(50) NOT NULL,
    premium numeric(10,2) NOT NULL,
    deductible numeric(10,2) NOT NULL,
    CONSTRAINT insuranceplan_deductible_check CHECK ((deductible >= (0)::numeric)),
    CONSTRAINT insuranceplan_premium_check CHECK ((premium > (0)::numeric))
);
 !   DROP TABLE public.insuranceplan;
       public         heap    postgres    false         �            1259    28567    healthcareproviderclientcount    VIEW     ~  CREATE VIEW public.healthcareproviderclientcount AS
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
 0   DROP VIEW public.healthcareproviderclientcount;
       public          postgres    false    226    228    228    236    236    216    216    217    217    220    225    225    226                    0    0 #   TABLE healthcareproviderclientcount    ACL     G   GRANT SELECT ON TABLE public.healthcareproviderclientcount TO hr_role;
          public          postgres    false    237         �            1259    28572    pays    TABLE     \  CREATE TABLE public.pays (
    employeeid character varying(10) NOT NULL,
    clientid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    amount numeric(10,2) NOT NULL,
    purpose text,
    CONSTRAINT pays_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT pays_date_check CHECK ((date <= CURRENT_DATE))
);
    DROP TABLE public.pays;
       public         heap    postgres    false         �            1259    28580 !   healthcareproviderservicepayments    VIEW       CREATE VIEW public.healthcareproviderservicepayments AS
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
 4   DROP VIEW public.healthcareproviderservicepayments;
       public          postgres    false    220    225    225    226    226    227    227    228    228    228    228    238    238         �            1259    28585 +   healthcareproviderservicepaymentsrestricted    VIEW     �  CREATE VIEW public.healthcareproviderservicepaymentsrestricted AS
 SELECT ed.healthcareproviderid,
    ms.servicename,
    pr.date,
    p.amount AS amountpaid
   FROM ((((public.employdoctor ed
     JOIN public.provide pr ON (((ed.doctorid)::text = (pr.doctorid)::text)))
     JOIN public.client c ON (((pr.clientid)::text = (c.clientid)::text)))
     JOIN public.medicalservice ms ON (((pr.serviceid)::text = (ms.serviceid)::text)))
     JOIN public.pays p ON (((c.clientid)::text = (p.clientid)::text)));
 >   DROP VIEW public.healthcareproviderservicepaymentsrestricted;
       public          postgres    false    228    238    238    227    227    228    228    220    225    225    228         �            1259    28590    medicalrecords    TABLE     �  CREATE TABLE public.medicalrecords (
    clientid character varying(10) NOT NULL,
    icdcode character varying(50) NOT NULL,
    datecreated date DEFAULT CURRENT_DATE NOT NULL,
    conditionname character varying(100) NOT NULL,
    description text,
    CONSTRAINT medicalrecords_datecreated_check CHECK ((datecreated <= CURRENT_DATE)),
    CONSTRAINT medicalrecords_icdcode_check CHECK (((icdcode)::text ~ '^[A-Z0-9]{3,4}(\.[A-Z0-9]{1,4})?$'::text))
);
 "   DROP TABLE public.medicalrecords;
       public         heap    postgres    false         �            1259    28598    refer    TABLE     �   CREATE TABLE public.refer (
    clientid character varying(10) NOT NULL,
    referringdoctorid character varying(10) NOT NULL,
    referreddoctorid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    reason text
);
    DROP TABLE public.refer;
       public         heap    postgres    false         �            1259    28604    requestdoctor    TABLE     �   CREATE TABLE public.requestdoctor (
    clientid character varying(10) NOT NULL,
    doctorid character varying(10) NOT NULL,
    healthcareproviderid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL
);
 !   DROP TABLE public.requestdoctor;
       public         heap    postgres    false         �            1259    28608    top5monthlyservicesummary    VIEW     �  CREATE VIEW public.top5monthlyservicesummary AS
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
 ,   DROP VIEW public.top5monthlyservicesummary;
       public          postgres    false    225    225    227    227    228    228    228    228         �            1259    28613    users    TABLE     J  CREATE TABLE public.users (
    userid integer NOT NULL,
    externalid character varying(10) NOT NULL,
    username character varying(100) NOT NULL,
    passwordhash character varying(100) NOT NULL,
    role character varying(20) NOT NULL,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT role_check CHECK (((role)::text = ANY (ARRAY[('Employee'::character varying)::text, ('Client'::character varying)::text, ('Agent'::character varying)::text, ('Doctor'::character varying)::text, ('HealthcareProvider'::character varying)::text]))),
    CONSTRAINT users_role_check CHECK (((role)::text = ANY (ARRAY[('Employee'::character varying)::text, ('Client'::character varying)::text, ('Agent'::character varying)::text, ('Doctor'::character varying)::text, ('HealthcareProvider'::character varying)::text])))
);
    DROP TABLE public.users;
       public         heap    postgres    false         �            1259    28619    users_userid_seq    SEQUENCE     �   CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.users_userid_seq;
       public          postgres    false    245                    0    0    users_userid_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;
          public          postgres    false    246         �           2604    28829    users userid    DEFAULT     l   ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);
 ;   ALTER TABLE public.users ALTER COLUMN userid DROP DEFAULT;
       public          postgres    false    246    245         �          0    28461    agent 
   TABLE DATA           f   COPY public.agent (agentid, agentname, commissionrate, email, licensenumber, phonenumber) FROM stdin;
    public          postgres    false    215       5093.dat �          0    28483    client 
   TABLE DATA           _   COPY public.client (clientid, firstname, middlename, lastname, dob, gender, email) FROM stdin;
    public          postgres    false    220       5096.dat �          0    28489    clientaddress 
   TABLE DATA           :   COPY public.clientaddress (clientid, address) FROM stdin;
    public          postgres    false    221       5097.dat �          0    28494    clientdependent 
   TABLE DATA           o   COPY public.clientdependent (clientid, firstname, middlename, lastname, dob, gender, relationship) FROM stdin;
    public          postgres    false    222       5098.dat �          0    28500    clientphonenumber 
   TABLE DATA           B   COPY public.clientphonenumber (clientid, phonenumber) FROM stdin;
    public          postgres    false    223       5099.dat �          0    28541    covers 
   TABLE DATA           I   COPY public.covers (insuranceplanname, healthcareproviderid) FROM stdin;
    public          postgres    false    232       5106.dat �          0    28503    doctor 
   TABLE DATA              COPY public.doctor (doctorid, firstname, middlename, lastname, email, phonenumber, supervisorhealthcareproviderid) FROM stdin;
    public          postgres    false    224       5100.dat �          0    28544    doctorspecialization 
   TABLE DATA           H   COPY public.doctorspecialization (doctorid, specialization) FROM stdin;
    public          postgres    false    233       5107.dat �          0    28507    employdoctor 
   TABLE DATA           F   COPY public.employdoctor (healthcareproviderid, doctorid) FROM stdin;
    public          postgres    false    225       5101.dat �          0    28547    employee 
   TABLE DATA           ~   COPY public.employee (employeeid, firstname, middlename, lastname, phonenumber, email, address, salary, jobtitle) FROM stdin;
    public          postgres    false    234       5108.dat �          0    28554    employeedependent 
   TABLE DATA           s   COPY public.employeedependent (employeeid, firstname, middlename, lastname, dob, gender, relationship) FROM stdin;
    public          postgres    false    235       5109.dat �          0    28510    healthcareprovider 
   TABLE DATA           t   COPY public.healthcareprovider (healthcareproviderid, providername, providertype, phonenumber, address) FROM stdin;
    public          postgres    false    226       5102.dat �          0    28560    insuranceplan 
   TABLE DATA           u   COPY public.insuranceplan (insuranceplanname, plantype, description, coveragelevel, premium, deductible) FROM stdin;
    public          postgres    false    236       5110.dat �          0    28590    medicalrecords 
   TABLE DATA           d   COPY public.medicalrecords (clientid, icdcode, datecreated, conditionname, description) FROM stdin;
    public          postgres    false    241       5112.dat �          0    28515    medicalservice 
   TABLE DATA           M   COPY public.medicalservice (serviceid, servicename, description) FROM stdin;
    public          postgres    false    227       5103.dat �          0    28572    pays 
   TABLE DATA           K   COPY public.pays (employeeid, clientid, date, amount, purpose) FROM stdin;
    public          postgres    false    238       5111.dat �          0    28466    policy 
   TABLE DATA           `   COPY public.policy (policynumber, exactcost, startdate, enddate, insuranceplanname) FROM stdin;
    public          postgres    false    216       5094.dat �          0    28520    provide 
   TABLE DATA           S   COPY public.provide (clientid, doctorid, serviceid, date, servicecost) FROM stdin;
    public          postgres    false    228       5104.dat �          0    28598    refer 
   TABLE DATA           \   COPY public.refer (clientid, referringdoctorid, referreddoctorid, date, reason) FROM stdin;
    public          postgres    false    242       5113.dat �          0    28530    requestclaim 
   TABLE DATA           o   COPY public.requestclaim (employeeid, clientid, datecreated, amount, approvalstatus, decisiondate) FROM stdin;
    public          postgres    false    230       5105.dat �          0    28604    requestdoctor 
   TABLE DATA           W   COPY public.requestdoctor (clientid, doctorid, healthcareproviderid, date) FROM stdin;
    public          postgres    false    243       5114.dat �          0    28471    sell 
   TABLE DATA           ?   COPY public.sell (clientid, policynumber, agentid) FROM stdin;
    public          postgres    false    217       5095.dat �          0    28613    users 
   TABLE DATA           \   COPY public.users (userid, externalid, username, passwordhash, role, createdat) FROM stdin;
    public          postgres    false    245       5115.dat            0    0    users_userid_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.users_userid_seq', 51, true);
          public          postgres    false    246         �           2606    28622    agent agent_licensenumber_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_licensenumber_key UNIQUE (licensenumber);
 G   ALTER TABLE ONLY public.agent DROP CONSTRAINT agent_licensenumber_key;
       public            postgres    false    215         �           2606    28624    agent agent_phonenumber_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_phonenumber_key UNIQUE (phonenumber);
 E   ALTER TABLE ONLY public.agent DROP CONSTRAINT agent_phonenumber_key;
       public            postgres    false    215         �           2606    28626    agent agent_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_pkey PRIMARY KEY (agentid);
 :   ALTER TABLE ONLY public.agent DROP CONSTRAINT agent_pkey;
       public            postgres    false    215         �           2606    28628    clientaddress client_address_id 
   CONSTRAINT     l   ALTER TABLE ONLY public.clientaddress
    ADD CONSTRAINT client_address_id PRIMARY KEY (clientid, address);
 I   ALTER TABLE ONLY public.clientaddress DROP CONSTRAINT client_address_id;
       public            postgres    false    221    221         �           2606    28630 #   clientdependent client_dependent_id 
   CONSTRAINT     �   ALTER TABLE ONLY public.clientdependent
    ADD CONSTRAINT client_dependent_id PRIMARY KEY (clientid, firstname, middlename, lastname);
 M   ALTER TABLE ONLY public.clientdependent DROP CONSTRAINT client_dependent_id;
       public            postgres    false    222    222    222    222         �           2606    28632 !   clientphonenumber client_phone_id 
   CONSTRAINT     r   ALTER TABLE ONLY public.clientphonenumber
    ADD CONSTRAINT client_phone_id PRIMARY KEY (clientid, phonenumber);
 K   ALTER TABLE ONLY public.clientphonenumber DROP CONSTRAINT client_phone_id;
       public            postgres    false    223    223         �           2606    28634    client client_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (clientid);
 <   ALTER TABLE ONLY public.client DROP CONSTRAINT client_pkey;
       public            postgres    false    220                    2606    28636    covers coverage_id 
   CONSTRAINT     u   ALTER TABLE ONLY public.covers
    ADD CONSTRAINT coverage_id PRIMARY KEY (insuranceplanname, healthcareproviderid);
 <   ALTER TABLE ONLY public.covers DROP CONSTRAINT coverage_id;
       public            postgres    false    232    232                     2606    28638    doctor doctor_phonenumber_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_phonenumber_key UNIQUE (phonenumber);
 G   ALTER TABLE ONLY public.doctor DROP CONSTRAINT doctor_phonenumber_key;
       public            postgres    false    224                    2606    28640    doctor doctor_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_pkey PRIMARY KEY (doctorid);
 <   ALTER TABLE ONLY public.doctor DROP CONSTRAINT doctor_pkey;
       public            postgres    false    224         $           2606    28642    requestdoctor doctor_request_id 
   CONSTRAINT     �   ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT doctor_request_id PRIMARY KEY (clientid, doctorid, healthcareproviderid, date);
 I   ALTER TABLE ONLY public.requestdoctor DROP CONSTRAINT doctor_request_id;
       public            postgres    false    243    243    243    243                    2606    28644    employdoctor employ_doctor_id 
   CONSTRAINT     w   ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT employ_doctor_id PRIMARY KEY (healthcareproviderid, doctorid);
 G   ALTER TABLE ONLY public.employdoctor DROP CONSTRAINT employ_doctor_id;
       public            postgres    false    225    225                    2606    28646 '   employeedependent employee_dependent_id 
   CONSTRAINT     �   ALTER TABLE ONLY public.employeedependent
    ADD CONSTRAINT employee_dependent_id PRIMARY KEY (employeeid, firstname, middlename, lastname);
 Q   ALTER TABLE ONLY public.employeedependent DROP CONSTRAINT employee_dependent_id;
       public            postgres    false    235    235    235    235                    2606    28648 !   employee employee_phonenumber_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_phonenumber_key UNIQUE (phonenumber);
 K   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_phonenumber_key;
       public            postgres    false    234                    2606    28650    employee employee_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employeeid);
 @   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_pkey;
       public            postgres    false    234                    2606    28652 5   healthcareprovider healthcareprovider_phonenumber_key 
   CONSTRAINT     w   ALTER TABLE ONLY public.healthcareprovider
    ADD CONSTRAINT healthcareprovider_phonenumber_key UNIQUE (phonenumber);
 _   ALTER TABLE ONLY public.healthcareprovider DROP CONSTRAINT healthcareprovider_phonenumber_key;
       public            postgres    false    226         	           2606    28654 *   healthcareprovider healthcareprovider_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.healthcareprovider
    ADD CONSTRAINT healthcareprovider_pkey PRIMARY KEY (healthcareproviderid);
 T   ALTER TABLE ONLY public.healthcareprovider DROP CONSTRAINT healthcareprovider_pkey;
       public            postgres    false    226                    2606    28656     insuranceplan insuranceplan_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.insuranceplan
    ADD CONSTRAINT insuranceplan_pkey PRIMARY KEY (insuranceplanname);
 J   ALTER TABLE ONLY public.insuranceplan DROP CONSTRAINT insuranceplan_pkey;
       public            postgres    false    236                     2606    28658     medicalrecords medical_record_id 
   CONSTRAINT     m   ALTER TABLE ONLY public.medicalrecords
    ADD CONSTRAINT medical_record_id PRIMARY KEY (clientid, icdcode);
 J   ALTER TABLE ONLY public.medicalrecords DROP CONSTRAINT medical_record_id;
       public            postgres    false    241    241                    2606    28660 "   medicalservice medicalservice_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.medicalservice
    ADD CONSTRAINT medicalservice_pkey PRIMARY KEY (serviceid);
 L   ALTER TABLE ONLY public.medicalservice DROP CONSTRAINT medicalservice_pkey;
       public            postgres    false    227                    2606    28662    pays payment_id 
   CONSTRAINT     e   ALTER TABLE ONLY public.pays
    ADD CONSTRAINT payment_id PRIMARY KEY (employeeid, clientid, date);
 9   ALTER TABLE ONLY public.pays DROP CONSTRAINT payment_id;
       public            postgres    false    238    238    238         �           2606    28664    policy policy_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.policy
    ADD CONSTRAINT policy_pkey PRIMARY KEY (policynumber);
 <   ALTER TABLE ONLY public.policy DROP CONSTRAINT policy_pkey;
       public            postgres    false    216                    2606    28666    provide provided_service_id 
   CONSTRAINT     z   ALTER TABLE ONLY public.provide
    ADD CONSTRAINT provided_service_id PRIMARY KEY (clientid, doctorid, serviceid, date);
 E   ALTER TABLE ONLY public.provide DROP CONSTRAINT provided_service_id;
       public            postgres    false    228    228    228    228         "           2606    28668    refer referal_id 
   CONSTRAINT        ALTER TABLE ONLY public.refer
    ADD CONSTRAINT referal_id PRIMARY KEY (clientid, referringdoctorid, referreddoctorid, date);
 :   ALTER TABLE ONLY public.refer DROP CONSTRAINT referal_id;
       public            postgres    false    242    242    242    242                    2606    28670    requestclaim request_id 
   CONSTRAINT     t   ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT request_id PRIMARY KEY (employeeid, clientid, datecreated);
 A   ALTER TABLE ONLY public.requestclaim DROP CONSTRAINT request_id;
       public            postgres    false    230    230    230         �           2606    28672    sell sell_transaction_id 
   CONSTRAINT     s   ALTER TABLE ONLY public.sell
    ADD CONSTRAINT sell_transaction_id PRIMARY KEY (clientid, policynumber, agentid);
 B   ALTER TABLE ONLY public.sell DROP CONSTRAINT sell_transaction_id;
       public            postgres    false    217    217    217                    2606    28674 &   doctorspecialization specialization_id 
   CONSTRAINT     z   ALTER TABLE ONLY public.doctorspecialization
    ADD CONSTRAINT specialization_id PRIMARY KEY (doctorid, specialization);
 P   ALTER TABLE ONLY public.doctorspecialization DROP CONSTRAINT specialization_id;
       public            postgres    false    233    233         &           2606    28676    users users_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    245         (           2606    28678    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public            postgres    false    245         �           1259    28679    unique_email_agent    INDEX     [   CREATE UNIQUE INDEX unique_email_agent ON public.agent USING btree (lower((email)::text));
 &   DROP INDEX public.unique_email_agent;
       public            postgres    false    215    215         �           1259    28680    unique_email_client    INDEX     ]   CREATE UNIQUE INDEX unique_email_client ON public.client USING btree (lower((email)::text));
 '   DROP INDEX public.unique_email_client;
       public            postgres    false    220    220                    1259    28681    unique_email_doctor    INDEX     ]   CREATE UNIQUE INDEX unique_email_doctor ON public.doctor USING btree (lower((email)::text));
 '   DROP INDEX public.unique_email_doctor;
       public            postgres    false    224    224                    1259    28682    unique_email_employee    INDEX     a   CREATE UNIQUE INDEX unique_email_employee ON public.employee USING btree (lower((email)::text));
 )   DROP INDEX public.unique_email_employee;
       public            postgres    false    234    234         *           2606    28683    sell fk_agentid    FK CONSTRAINT     �   ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_agentid FOREIGN KEY (agentid) REFERENCES public.agent(agentid) ON UPDATE CASCADE ON DELETE CASCADE;
 9   ALTER TABLE ONLY public.sell DROP CONSTRAINT fk_agentid;
       public          postgres    false    215    217    4848         /           2606    28688    clientphonenumber fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.clientphonenumber
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.clientphonenumber DROP CONSTRAINT fk_clientid;
       public          postgres    false    220    4855    223         -           2606    28693    clientaddress fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.clientaddress
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.clientaddress DROP CONSTRAINT fk_clientid;
       public          postgres    false    221    220    4855         >           2606    28698    medicalrecords fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.medicalrecords
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.medicalrecords DROP CONSTRAINT fk_clientid;
       public          postgres    false    4855    220    241         6           2606    28703    requestclaim fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.requestclaim DROP CONSTRAINT fk_clientid;
       public          postgres    false    220    230    4855         <           2606    28708    pays fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.pays
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 :   ALTER TABLE ONLY public.pays DROP CONSTRAINT fk_clientid;
       public          postgres    false    220    238    4855         .           2606    28713    clientdependent fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.clientdependent
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.clientdependent DROP CONSTRAINT fk_clientid;
       public          postgres    false    220    222    4855         3           2606    28718    provide fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.provide DROP CONSTRAINT fk_clientid;
       public          postgres    false    228    4855    220         B           2606    28723    requestdoctor fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.requestdoctor DROP CONSTRAINT fk_clientid;
       public          postgres    false    243    220    4855         ?           2606    28728    refer fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 ;   ALTER TABLE ONLY public.refer DROP CONSTRAINT fk_clientid;
       public          postgres    false    220    4855    242         +           2606    28733    sell fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 :   ALTER TABLE ONLY public.sell DROP CONSTRAINT fk_clientid;
       public          postgres    false    220    4855    217         :           2606    28738     doctorspecialization fk_doctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.doctorspecialization
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.doctorspecialization DROP CONSTRAINT fk_doctorid;
       public          postgres    false    233    224    4866         1           2606    28743    employdoctor fk_doctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.employdoctor DROP CONSTRAINT fk_doctorid;
       public          postgres    false    225    224    4866         4           2606    28748    provide fk_doctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON DELETE SET NULL;
 =   ALTER TABLE ONLY public.provide DROP CONSTRAINT fk_doctorid;
       public          postgres    false    224    4866    228         C           2606    28753    requestdoctor fk_doctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.requestdoctor DROP CONSTRAINT fk_doctorid;
       public          postgres    false    224    4866    243         7           2606    28758    requestclaim fk_employeeid    FK CONSTRAINT     �   ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.requestclaim DROP CONSTRAINT fk_employeeid;
       public          postgres    false    230    234    4887         =           2606    28763    pays fk_employeeid    FK CONSTRAINT     �   ALTER TABLE ONLY public.pays
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE SET NULL;
 <   ALTER TABLE ONLY public.pays DROP CONSTRAINT fk_employeeid;
       public          postgres    false    238    4887    234         ;           2606    28768    employeedependent fk_employeeid    FK CONSTRAINT     �   ALTER TABLE ONLY public.employeedependent
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.employeedependent DROP CONSTRAINT fk_employeeid;
       public          postgres    false    235    4887    234         0           2606    28773     doctor fk_healthcare_provider_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT fk_healthcare_provider_id FOREIGN KEY (supervisorhealthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE SET NULL;
 J   ALTER TABLE ONLY public.doctor DROP CONSTRAINT fk_healthcare_provider_id;
       public          postgres    false    224    4873    226         2           2606    28778 $   employdoctor fk_healthcareproviderid    FK CONSTRAINT     �   ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.employdoctor DROP CONSTRAINT fk_healthcareproviderid;
       public          postgres    false    225    4873    226         8           2606    28783    covers fk_healthcareproviderid    FK CONSTRAINT     �   ALTER TABLE ONLY public.covers
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.covers DROP CONSTRAINT fk_healthcareproviderid;
       public          postgres    false    232    4873    226         D           2606    28788 %   requestdoctor fk_healthcareproviderid    FK CONSTRAINT     �   ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.requestdoctor DROP CONSTRAINT fk_healthcareproviderid;
       public          postgres    false    243    4873    226         )           2606    28793    policy fk_insuranceplanname    FK CONSTRAINT     �   ALTER TABLE ONLY public.policy
    ADD CONSTRAINT fk_insuranceplanname FOREIGN KEY (insuranceplanname) REFERENCES public.insuranceplan(insuranceplanname) ON UPDATE CASCADE ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.policy DROP CONSTRAINT fk_insuranceplanname;
       public          postgres    false    216    4892    236         9           2606    28798    covers fk_insuranceplanname    FK CONSTRAINT     �   ALTER TABLE ONLY public.covers
    ADD CONSTRAINT fk_insuranceplanname FOREIGN KEY (insuranceplanname) REFERENCES public.insuranceplan(insuranceplanname) ON UPDATE CASCADE ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.covers DROP CONSTRAINT fk_insuranceplanname;
       public          postgres    false    232    236    4892         ,           2606    28803    sell fk_policynumber    FK CONSTRAINT     �   ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_policynumber FOREIGN KEY (policynumber) REFERENCES public.policy(policynumber) ON UPDATE CASCADE ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.sell DROP CONSTRAINT fk_policynumber;
       public          postgres    false    217    216    4851         @           2606    28808    refer fk_referreddoctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_referreddoctorid FOREIGN KEY (referreddoctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.refer DROP CONSTRAINT fk_referreddoctorid;
       public          postgres    false    4866    224    242         A           2606    28813    refer fk_referringdoctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_referringdoctorid FOREIGN KEY (referringdoctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE SET NULL;
 D   ALTER TABLE ONLY public.refer DROP CONSTRAINT fk_referringdoctorid;
       public          postgres    false    224    242    4866         5           2606    28818    provide fk_serviceid    FK CONSTRAINT     �   ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_serviceid FOREIGN KEY (serviceid) REFERENCES public.medicalservice(serviceid) ON DELETE SET NULL;
 >   ALTER TABLE ONLY public.provide DROP CONSTRAINT fk_serviceid;
       public          postgres    false    228    4875    227         �           0    28461    agent    ROW SECURITY     3   ALTER TABLE public.agent ENABLE ROW LEVEL SECURITY;          public          postgres    false    215         �           3256    28823    agent agent_access_policy    POLICY     @   CREATE POLICY agent_access_policy ON public.agent USING (true);
 1   DROP POLICY agent_access_policy ON public.agent;
       public          postgres    false    215         �           3256    28824    agent agent_row_policy    POLICY     W   CREATE POLICY agent_row_policy ON public.agent USING (((email)::text = CURRENT_USER));
 .   DROP POLICY agent_row_policy ON public.agent;
       public          postgres    false    215    215         �           0    28483    client    ROW SECURITY     4   ALTER TABLE public.client ENABLE ROW LEVEL SECURITY;          public          postgres    false    220         �           3256    28825    client client_row_policy    POLICY     Y   CREATE POLICY client_row_policy ON public.client USING (((email)::text = CURRENT_USER));
 0   DROP POLICY client_row_policy ON public.client;
       public          postgres    false    220    220         �           3256    28826 -   healthcareprovider healthcare_provider_policy    POLICY     �   CREATE POLICY healthcare_provider_policy ON public.healthcareprovider USING (((lower(replace((providername)::text, ' '::text, '.'::text)) || '@healthcare.com'::text) = CURRENT_USER));
 E   DROP POLICY healthcare_provider_policy ON public.healthcareprovider;
       public          postgres    false    226    226         �           0    28510    healthcareprovider    ROW SECURITY     @   ALTER TABLE public.healthcareprovider ENABLE ROW LEVEL SECURITY;          public          postgres    false    226         �           3256    28827 (   requestclaim request_claim_client_policy    POLICY     2  CREATE POLICY request_claim_client_policy ON public.requestclaim USING ((((clientid)::text = (( SELECT client.clientid
   FROM public.client
  WHERE (lower((client.email)::text) = CURRENT_USER)))::text) OR (CURRENT_USER = ANY (ARRAY['fadi.salameh@procare.com'::name, 'layla.kassem@procare.com'::name]))));
 @   DROP POLICY request_claim_client_policy ON public.requestclaim;
       public          postgres    false    220    230    230    220         �           0    28530    requestclaim    ROW SECURITY     :   ALTER TABLE public.requestclaim ENABLE ROW LEVEL SECURITY;          public          postgres    false    230                                                                                                                                                                                                                                                                                                                                                                  5093.dat                                                                                            0000600 0004000 0002000 00000001106 14720157250 0014253 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        AGT00001	Rami Hbeish	5.00	rami.h@email.com	L001	71234567
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


                                                                                                                                                                                                                                                                                                                                                                                                                                                          5096.dat                                                                                            0000600 0004000 0002000 00000001145 14720157250 0014261 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        CLI00001	Ali	Jamal	Hajj	1985-02-14	M	ali.hajj@email.com
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


                                                                                                                                                                                                                                                                                                                                                                                                                           5097.dat                                                                                            0000600 0004000 0002000 00000000526 14720157250 0014264 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        CLI00001	15 Cedar Rd, Beirut
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


                                                                                                                                                                          5098.dat                                                                                            0000600 0004000 0002000 00000000705 14720157250 0014264 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        CLI00001	Cynthia	Ali	Hajj	2000-01-01	F	Daughter
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


                                                           5099.dat                                                                                            0000600 0004000 0002000 00000000313 14720157250 0014260 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        CLI00001	71234567
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


                                                                                                                                                                                                                                                                                                                     5106.dat                                                                                            0000600 0004000 0002000 00000000555 14720157250 0014255 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        Basic Health Plan	HCP00001
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


                                                                                                                                                   5100.dat                                                                                            0000600 0004000 0002000 00000001244 14720157250 0014243 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        DOC00001	Ahmad	Khaled	Khoury	ahmad.khoury@email.com	03456789	HCP00001
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


                                                                                                                                                                                                                                                                                                                                                            5107.dat                                                                                            0000600 0004000 0002000 00000000466 14720157250 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        DOC00001	Cardiology
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


                                                                                                                                                                                                          5101.dat                                                                                            0000600 0004000 0002000 00000000271 14720157250 0014243 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        HCP00001	DOC00001
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


                                                                                                                                                                                                                                                                                                                                       5108.dat                                                                                            0000600 0004000 0002000 00000002066 14720157250 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        EMP00001	Omar	Khaled	Haddad	712345678	omar.haddad@procare.com	12 Main St, Beirut	1500.00	Software Developer
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


                                                                                                                                                                                                                                                                                                                                                                                                                                                                          5109.dat                                                                                            0000600 0004000 0002000 00000000710 14720157250 0014251 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        EMP00001	Khaled	Omar	Haddad	2010-05-15	M	Son
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


                                                        5102.dat                                                                                            0000600 0004000 0002000 00000001346 14720157250 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        HCP00001	HealthFirst Clinic	Clinic	01234567123	Wellness St, Ashrafieh, Beirut
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


                                                                                                                                                                                                                                                                                          5110.dat                                                                                            0000600 0004000 0002000 00000001727 14720157250 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        Basic Health Plan	HMO	Provides comprehensive health coverage	Silver	200.00	1000.00
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


                                         5112.dat                                                                                            0000600 0004000 0002000 00000001404 14720157250 0014244 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        CLI00001	A01.0	2024-01-15	Typhoid Fever	Acute bacterial infection
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


                                                                                                                                                                                                                                                            5103.dat                                                                                            0000600 0004000 0002000 00000001245 14720157250 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        MDS00001	General Check-up	Routine examination to assess overall health.
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


                                                                                                                                                                                                                                                                                                                                                           5111.dat                                                                                            0000600 0004000 0002000 00000001076 14720157250 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        EMP00008	CLI00001	2024-01-10	500.00	Service Fees
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


                                                                                                                                                                                                                                                                                                                                                                                                                                                                  5094.dat                                                                                            0000600 0004000 0002000 00000001126 14720157250 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PNM00001	500.00	2024-01-01	2024-12-31	Basic Health Plan
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


                                                                                                                                                                                                                                                                                                                                                                                                                                          5104.dat                                                                                            0000600 0004000 0002000 00000001454 14720157250 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        CLI00005	DOC00003	MDS00001	2024-10-01	100.00
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


                                                                                                                                                                                                                    5113.dat                                                                                            0000600 0004000 0002000 00000001123 14720157250 0014243 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        CLI00001	DOC00001	DOC00002	2024-10-01	Specialist Consultation
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


                                                                                                                                                                                                                                                                                                                                                                                                                                             5105.dat                                                                                            0000600 0004000 0002000 00000002105 14720157250 0014245 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        EMP00005	CLI00001	2024-01-05	250.00	Approved	2024-01-10
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


                                                                                                                                                                                                                                                                                                                                                                                                                                                           5114.dat                                                                                            0000600 0004000 0002000 00000000601 14720157250 0014244 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        CLI00001	DOC00001	HCP00001	2024-10-01
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


                                                                                                                               5095.dat                                                                                            0000600 0004000 0002000 00000000423 14720157250 0014256 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        CLI00001	PNM00005	AGT00002
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


                                                                                                                                                                                                                                             5115.dat                                                                                            0000600 0004000 0002000 00000011422 14720157250 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	EMP00001	omar.haddad@procare.com	$2b$12$examplehashstring	Employee	2024-11-22 17:39:02.317401
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


                                                                                                                                                                                                                                              restore.sql                                                                                         0000600 0004000 0002000 00000125103 14720157250 0015371 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

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

DROP DATABASE kamel;
--
-- Name: kamel; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE kamel WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE kamel OWNER TO postgres;

\connect kamel

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
-- Name: sell; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sell (
    clientid character varying(10) NOT NULL,
    policynumber character varying(10) NOT NULL,
    agentid character varying(10) NOT NULL
);


ALTER TABLE public.sell OWNER TO postgres;

--
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
-- Name: clientaddress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientaddress (
    clientid character varying(10) NOT NULL,
    address text NOT NULL
);


ALTER TABLE public.clientaddress OWNER TO postgres;

--
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
-- Name: clientphonenumber; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientphonenumber (
    clientid character varying(10) NOT NULL,
    phonenumber character varying(15) NOT NULL
);


ALTER TABLE public.clientphonenumber OWNER TO postgres;

--
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
-- Name: employdoctor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employdoctor (
    healthcareproviderid character varying(10) NOT NULL,
    doctorid character varying(10) NOT NULL
);


ALTER TABLE public.employdoctor OWNER TO postgres;

--
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
-- Name: medicalservice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicalservice (
    serviceid character varying(10) NOT NULL,
    servicename character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.medicalservice OWNER TO postgres;

--
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
-- Name: covers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.covers (
    insuranceplanname character varying(100) NOT NULL,
    healthcareproviderid character varying(10) NOT NULL
);


ALTER TABLE public.covers OWNER TO postgres;

--
-- Name: doctorspecialization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.doctorspecialization (
    doctorid character varying(10) NOT NULL,
    specialization character varying(50) NOT NULL
);


ALTER TABLE public.doctorspecialization OWNER TO postgres;

--
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
-- Name: COLUMN employee.salary; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.employee.salary IS 'Employee salary in USD';


--
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
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;


--
-- Name: users userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);


--
-- Data for Name: agent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.agent (agentid, agentname, commissionrate, email, licensenumber, phonenumber) FROM stdin;
\.
COPY public.agent (agentid, agentname, commissionrate, email, licensenumber, phonenumber) FROM '$$PATH$$/5093.dat';

--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.client (clientid, firstname, middlename, lastname, dob, gender, email) FROM stdin;
\.
COPY public.client (clientid, firstname, middlename, lastname, dob, gender, email) FROM '$$PATH$$/5096.dat';

--
-- Data for Name: clientaddress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientaddress (clientid, address) FROM stdin;
\.
COPY public.clientaddress (clientid, address) FROM '$$PATH$$/5097.dat';

--
-- Data for Name: clientdependent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientdependent (clientid, firstname, middlename, lastname, dob, gender, relationship) FROM stdin;
\.
COPY public.clientdependent (clientid, firstname, middlename, lastname, dob, gender, relationship) FROM '$$PATH$$/5098.dat';

--
-- Data for Name: clientphonenumber; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientphonenumber (clientid, phonenumber) FROM stdin;
\.
COPY public.clientphonenumber (clientid, phonenumber) FROM '$$PATH$$/5099.dat';

--
-- Data for Name: covers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.covers (insuranceplanname, healthcareproviderid) FROM stdin;
\.
COPY public.covers (insuranceplanname, healthcareproviderid) FROM '$$PATH$$/5106.dat';

--
-- Data for Name: doctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctor (doctorid, firstname, middlename, lastname, email, phonenumber, supervisorhealthcareproviderid) FROM stdin;
\.
COPY public.doctor (doctorid, firstname, middlename, lastname, email, phonenumber, supervisorhealthcareproviderid) FROM '$$PATH$$/5100.dat';

--
-- Data for Name: doctorspecialization; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.doctorspecialization (doctorid, specialization) FROM stdin;
\.
COPY public.doctorspecialization (doctorid, specialization) FROM '$$PATH$$/5107.dat';

--
-- Data for Name: employdoctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employdoctor (healthcareproviderid, doctorid) FROM stdin;
\.
COPY public.employdoctor (healthcareproviderid, doctorid) FROM '$$PATH$$/5101.dat';

--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (employeeid, firstname, middlename, lastname, phonenumber, email, address, salary, jobtitle) FROM stdin;
\.
COPY public.employee (employeeid, firstname, middlename, lastname, phonenumber, email, address, salary, jobtitle) FROM '$$PATH$$/5108.dat';

--
-- Data for Name: employeedependent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employeedependent (employeeid, firstname, middlename, lastname, dob, gender, relationship) FROM stdin;
\.
COPY public.employeedependent (employeeid, firstname, middlename, lastname, dob, gender, relationship) FROM '$$PATH$$/5109.dat';

--
-- Data for Name: healthcareprovider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.healthcareprovider (healthcareproviderid, providername, providertype, phonenumber, address) FROM stdin;
\.
COPY public.healthcareprovider (healthcareproviderid, providername, providertype, phonenumber, address) FROM '$$PATH$$/5102.dat';

--
-- Data for Name: insuranceplan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.insuranceplan (insuranceplanname, plantype, description, coveragelevel, premium, deductible) FROM stdin;
\.
COPY public.insuranceplan (insuranceplanname, plantype, description, coveragelevel, premium, deductible) FROM '$$PATH$$/5110.dat';

--
-- Data for Name: medicalrecords; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicalrecords (clientid, icdcode, datecreated, conditionname, description) FROM stdin;
\.
COPY public.medicalrecords (clientid, icdcode, datecreated, conditionname, description) FROM '$$PATH$$/5112.dat';

--
-- Data for Name: medicalservice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicalservice (serviceid, servicename, description) FROM stdin;
\.
COPY public.medicalservice (serviceid, servicename, description) FROM '$$PATH$$/5103.dat';

--
-- Data for Name: pays; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pays (employeeid, clientid, date, amount, purpose) FROM stdin;
\.
COPY public.pays (employeeid, clientid, date, amount, purpose) FROM '$$PATH$$/5111.dat';

--
-- Data for Name: policy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.policy (policynumber, exactcost, startdate, enddate, insuranceplanname) FROM stdin;
\.
COPY public.policy (policynumber, exactcost, startdate, enddate, insuranceplanname) FROM '$$PATH$$/5094.dat';

--
-- Data for Name: provide; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provide (clientid, doctorid, serviceid, date, servicecost) FROM stdin;
\.
COPY public.provide (clientid, doctorid, serviceid, date, servicecost) FROM '$$PATH$$/5104.dat';

--
-- Data for Name: refer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refer (clientid, referringdoctorid, referreddoctorid, date, reason) FROM stdin;
\.
COPY public.refer (clientid, referringdoctorid, referreddoctorid, date, reason) FROM '$$PATH$$/5113.dat';

--
-- Data for Name: requestclaim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requestclaim (employeeid, clientid, datecreated, amount, approvalstatus, decisiondate) FROM stdin;
\.
COPY public.requestclaim (employeeid, clientid, datecreated, amount, approvalstatus, decisiondate) FROM '$$PATH$$/5105.dat';

--
-- Data for Name: requestdoctor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requestdoctor (clientid, doctorid, healthcareproviderid, date) FROM stdin;
\.
COPY public.requestdoctor (clientid, doctorid, healthcareproviderid, date) FROM '$$PATH$$/5114.dat';

--
-- Data for Name: sell; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sell (clientid, policynumber, agentid) FROM stdin;
\.
COPY public.sell (clientid, policynumber, agentid) FROM '$$PATH$$/5095.dat';

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (userid, externalid, username, passwordhash, role, createdat) FROM stdin;
\.
COPY public.users (userid, externalid, username, passwordhash, role, createdat) FROM '$$PATH$$/5115.dat';

--
-- Name: users_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_userid_seq', 51, true);


--
-- Name: agent agent_licensenumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_licensenumber_key UNIQUE (licensenumber);


--
-- Name: agent agent_phonenumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_phonenumber_key UNIQUE (phonenumber);


--
-- Name: agent agent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_pkey PRIMARY KEY (agentid);


--
-- Name: clientaddress client_address_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientaddress
    ADD CONSTRAINT client_address_id PRIMARY KEY (clientid, address);


--
-- Name: clientdependent client_dependent_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientdependent
    ADD CONSTRAINT client_dependent_id PRIMARY KEY (clientid, firstname, middlename, lastname);


--
-- Name: clientphonenumber client_phone_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientphonenumber
    ADD CONSTRAINT client_phone_id PRIMARY KEY (clientid, phonenumber);


--
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (clientid);


--
-- Name: covers coverage_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.covers
    ADD CONSTRAINT coverage_id PRIMARY KEY (insuranceplanname, healthcareproviderid);


--
-- Name: doctor doctor_phonenumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_phonenumber_key UNIQUE (phonenumber);


--
-- Name: doctor doctor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_pkey PRIMARY KEY (doctorid);


--
-- Name: requestdoctor doctor_request_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT doctor_request_id PRIMARY KEY (clientid, doctorid, healthcareproviderid, date);


--
-- Name: employdoctor employ_doctor_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT employ_doctor_id PRIMARY KEY (healthcareproviderid, doctorid);


--
-- Name: employeedependent employee_dependent_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employeedependent
    ADD CONSTRAINT employee_dependent_id PRIMARY KEY (employeeid, firstname, middlename, lastname);


--
-- Name: employee employee_phonenumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_phonenumber_key UNIQUE (phonenumber);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employeeid);


--
-- Name: healthcareprovider healthcareprovider_phonenumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcareprovider
    ADD CONSTRAINT healthcareprovider_phonenumber_key UNIQUE (phonenumber);


--
-- Name: healthcareprovider healthcareprovider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.healthcareprovider
    ADD CONSTRAINT healthcareprovider_pkey PRIMARY KEY (healthcareproviderid);


--
-- Name: insuranceplan insuranceplan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insuranceplan
    ADD CONSTRAINT insuranceplan_pkey PRIMARY KEY (insuranceplanname);


--
-- Name: medicalrecords medical_record_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicalrecords
    ADD CONSTRAINT medical_record_id PRIMARY KEY (clientid, icdcode);


--
-- Name: medicalservice medicalservice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicalservice
    ADD CONSTRAINT medicalservice_pkey PRIMARY KEY (serviceid);


--
-- Name: pays payment_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pays
    ADD CONSTRAINT payment_id PRIMARY KEY (employeeid, clientid, date);


--
-- Name: policy policy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policy
    ADD CONSTRAINT policy_pkey PRIMARY KEY (policynumber);


--
-- Name: provide provided_service_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provide
    ADD CONSTRAINT provided_service_id PRIMARY KEY (clientid, doctorid, serviceid, date);


--
-- Name: refer referal_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refer
    ADD CONSTRAINT referal_id PRIMARY KEY (clientid, referringdoctorid, referreddoctorid, date);


--
-- Name: requestclaim request_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT request_id PRIMARY KEY (employeeid, clientid, datecreated);


--
-- Name: sell sell_transaction_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sell
    ADD CONSTRAINT sell_transaction_id PRIMARY KEY (clientid, policynumber, agentid);


--
-- Name: doctorspecialization specialization_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctorspecialization
    ADD CONSTRAINT specialization_id PRIMARY KEY (doctorid, specialization);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: unique_email_agent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_email_agent ON public.agent USING btree (lower((email)::text));


--
-- Name: unique_email_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_email_client ON public.client USING btree (lower((email)::text));


--
-- Name: unique_email_doctor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_email_doctor ON public.doctor USING btree (lower((email)::text));


--
-- Name: unique_email_employee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_email_employee ON public.employee USING btree (lower((email)::text));


--
-- Name: sell fk_agentid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_agentid FOREIGN KEY (agentid) REFERENCES public.agent(agentid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: clientphonenumber fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientphonenumber
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: clientaddress fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientaddress
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: medicalrecords fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicalrecords
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: requestclaim fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pays fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pays
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: clientdependent fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientdependent
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON DELETE CASCADE;


--
-- Name: provide fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: requestdoctor fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refer fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sell fk_clientid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doctorspecialization fk_doctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctorspecialization
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employdoctor fk_doctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: provide fk_doctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON DELETE SET NULL;


--
-- Name: requestdoctor fk_doctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: requestclaim fk_employeeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: pays fk_employeeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pays
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: employeedependent fk_employeeid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employeedependent
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doctor fk_healthcare_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT fk_healthcare_provider_id FOREIGN KEY (supervisorhealthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: employdoctor fk_healthcareproviderid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: covers fk_healthcareproviderid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.covers
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: requestdoctor fk_healthcareproviderid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: policy fk_insuranceplanname; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.policy
    ADD CONSTRAINT fk_insuranceplanname FOREIGN KEY (insuranceplanname) REFERENCES public.insuranceplan(insuranceplanname) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: covers fk_insuranceplanname; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.covers
    ADD CONSTRAINT fk_insuranceplanname FOREIGN KEY (insuranceplanname) REFERENCES public.insuranceplan(insuranceplanname) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sell fk_policynumber; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_policynumber FOREIGN KEY (policynumber) REFERENCES public.policy(policynumber) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refer fk_referreddoctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_referreddoctorid FOREIGN KEY (referreddoctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refer fk_referringdoctorid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_referringdoctorid FOREIGN KEY (referringdoctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: provide fk_serviceid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_serviceid FOREIGN KEY (serviceid) REFERENCES public.medicalservice(serviceid) ON DELETE SET NULL;


--
-- Name: agent; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.agent ENABLE ROW LEVEL SECURITY;

--
-- Name: agent agent_access_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY agent_access_policy ON public.agent USING (true);


--
-- Name: agent agent_row_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY agent_row_policy ON public.agent USING (((email)::text = CURRENT_USER));


--
-- Name: client; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.client ENABLE ROW LEVEL SECURITY;

--
-- Name: client client_row_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY client_row_policy ON public.client USING (((email)::text = CURRENT_USER));


--
-- Name: healthcareprovider healthcare_provider_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY healthcare_provider_policy ON public.healthcareprovider USING (((lower(replace((providername)::text, ' '::text, '.'::text)) || '@healthcare.com'::text) = CURRENT_USER));


--
-- Name: healthcareprovider; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.healthcareprovider ENABLE ROW LEVEL SECURITY;

--
-- Name: requestclaim request_claim_client_policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY request_claim_client_policy ON public.requestclaim USING ((((clientid)::text = (( SELECT client.clientid
   FROM public.client
  WHERE (lower((client.email)::text) = CURRENT_USER)))::text) OR (CURRENT_USER = ANY (ARRAY['fadi.salameh@procare.com'::name, 'layla.kassem@procare.com'::name]))));


--
-- Name: requestclaim; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.requestclaim ENABLE ROW LEVEL SECURITY;

--
-- Name: TABLE healthcareproviderclientcount; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.healthcareproviderclientcount TO hr_role;


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             