PGDMP  9                
    |            project    16.4    16.4 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                        0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    25942    project    DATABASE     �   CREATE DATABASE project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE project;
                admin    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                admin    false            �            1259    26151    agent    TABLE     �  CREATE TABLE public.agent (
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
       public         heap    postgres    false    5                       0    0    TABLE agent    ACL     x   GRANT SELECT ON TABLE public.agent TO agent_role;
GRANT SELECT ON TABLE public.agent TO "karim.boukhallil@procare.com";
          public          postgres    false    231            �            1259    26163    policy    TABLE     <  CREATE TABLE public.policy (
    policynumber character varying(10) NOT NULL,
    exactcost numeric(10,2) NOT NULL,
    startdate date DEFAULT CURRENT_DATE NOT NULL,
    enddate date NOT NULL,
    insuranceplanname character varying(100),
    CONSTRAINT policy_exactcost_check CHECK ((exactcost >= (0)::numeric))
);
    DROP TABLE public.policy;
       public         heap    postgres    false    5                       0    0    TABLE policy    ACL     A   GRANT SELECT,INSERT,UPDATE ON TABLE public.policy TO agent_role;
          public          postgres    false    232            �            1259    26263    sell    TABLE     �   CREATE TABLE public.sell (
    clientid character varying(10) NOT NULL,
    policynumber character varying(10) NOT NULL,
    agentid character varying(10) NOT NULL
);
    DROP TABLE public.sell;
       public         heap    postgres    false    5                       0    0 
   TABLE sell    ACL     1   GRANT SELECT ON TABLE public.sell TO agent_role;
          public          postgres    false    238            �            1259    26298    agentearningsannually    VIEW     G  CREATE VIEW public.agentearningsannually AS
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
       public          postgres    false    231    238    238    238    232    232    232    231    231    5                       0    0    TABLE agentearningsannually    ACL     �   GRANT SELECT ON TABLE public.agentearningsannually TO agent_role;
GRANT SELECT ON TABLE public.agentearningsannually TO "karim.boukhallil@procare.com";
GRANT SELECT ON TABLE public.agentearningsannually TO sales_executive_role;
          public          postgres    false    241            �            1259    26437    agentearningsannuallyrestricted    VIEW     U  CREATE VIEW public.agentearningsannuallyrestricted AS
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
       public          admin    false    241    241    241    241    241    231    231    5                       0    0 %   TABLE agentearningsannuallyrestricted    ACL     `   GRANT SELECT ON TABLE public.agentearningsannuallyrestricted TO "karim.boukhallil@procare.com";
          public          admin    false    245            �            1259    25984    client    TABLE     >  CREATE TABLE public.client (
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
       public         heap    postgres    false    5                       0    0    TABLE client    ACL     �   GRANT INSERT,DELETE,UPDATE ON TABLE public.client TO employee_role;
GRANT SELECT ON TABLE public.client TO client_role;
GRANT SELECT ON TABLE public.client TO "fadi.salameh@procare.com";
GRANT SELECT ON TABLE public.client TO "layla.kassem@procare.com";
          public          postgres    false    218            �            1259    26003    clientaddress    TABLE     n   CREATE TABLE public.clientaddress (
    clientid character varying(10) NOT NULL,
    address text NOT NULL
);
 !   DROP TABLE public.clientaddress;
       public         heap    postgres    false    5            �            1259    26090    clientdependent    TABLE       CREATE TABLE public.clientdependent (
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
       public         heap    postgres    false    5            �            1259    25993    clientphonenumber    TABLE     �   CREATE TABLE public.clientphonenumber (
    clientid character varying(10) NOT NULL,
    phonenumber character varying(15) NOT NULL
);
 %   DROP TABLE public.clientphonenumber;
       public         heap    postgres    false    5            �            1259    26112    doctor    TABLE     �  CREATE TABLE public.doctor (
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
       public         heap    postgres    false    5            �            1259    26136    employdoctor    TABLE     �   CREATE TABLE public.employdoctor (
    healthcareproviderid character varying(10) NOT NULL,
    doctorid character varying(10) NOT NULL
);
     DROP TABLE public.employdoctor;
       public         heap    postgres    false    5            �            1259    26103    healthcareprovider    TABLE       CREATE TABLE public.healthcareprovider (
    healthcareproviderid character varying(10) NOT NULL,
    providername character varying(50) NOT NULL,
    providertype character varying(50) NOT NULL,
    phonenumber character varying(15) NOT NULL,
    address text NOT NULL
);
 &   DROP TABLE public.healthcareprovider;
       public         heap    postgres    false    5            	           0    0    TABLE healthcareprovider    ACL     M   GRANT SELECT ON TABLE public.healthcareprovider TO healthcare_provider_role;
          public          postgres    false    227            �            1259    26190    medicalservice    TABLE     �   CREATE TABLE public.medicalservice (
    serviceid character varying(10) NOT NULL,
    servicename character varying(100) NOT NULL,
    description text
);
 "   DROP TABLE public.medicalservice;
       public         heap    postgres    false    5            �            1259    26197    provide    TABLE     M  CREATE TABLE public.provide (
    clientid character varying(10) NOT NULL,
    doctorid character varying(10) NOT NULL,
    serviceid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    servicecost numeric(10,2) NOT NULL,
    CONSTRAINT provide_servicecost_check CHECK ((servicecost >= (0)::numeric))
);
    DROP TABLE public.provide;
       public         heap    postgres    false    5            
           0    0    TABLE provide    ACL     C   GRANT SELECT,INSERT,UPDATE ON TABLE public.provide TO doctor_role;
          public          postgres    false    235            �            1259    26283    clientservicepaymentsview    VIEW     �  CREATE VIEW public.clientservicepaymentsview AS
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
       public          postgres    false    218    218    218    218    227    227    228    230    230    234    234    235    235    235    235    235    5                       0    0    TABLE clientservicepaymentsview    ACL     T   GRANT SELECT ON TABLE public.clientservicepaymentsview TO "sami.shams@procare.com";
          public          postgres    false    239            �            1259    26039    requestclaim    TABLE     �  CREATE TABLE public.requestclaim (
    employeeid character varying(10) NOT NULL,
    clientid character varying(10) NOT NULL,
    datecreated date DEFAULT CURRENT_DATE NOT NULL,
    amount numeric(10,2) NOT NULL,
    approvalstatus character varying(50) DEFAULT 'Pending'::character varying NOT NULL,
    decisiondate date,
    CONSTRAINT requestclaim_amount_check CHECK ((amount > (0)::numeric))
);
     DROP TABLE public.requestclaim;
       public         heap    postgres    false    5                       0    0    TABLE requestclaim    ACL     �   GRANT SELECT ON TABLE public.requestclaim TO client_role;
GRANT SELECT ON TABLE public.requestclaim TO "fadi.salameh@procare.com";
GRANT SELECT ON TABLE public.requestclaim TO "layla.kassem@procare.com";
          public          postgres    false    223            �            1259    26288    clientsummaryfiltered    VIEW     �  CREATE VIEW public.clientsummaryfiltered AS
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
       public          postgres    false    223    223    223    218    218    218    218    223    5                       0    0    TABLE clientsummaryfiltered    ACL     R   GRANT SELECT ON TABLE public.clientsummaryfiltered TO "layla.kassem@procare.com";
          public          postgres    false    240            �            1259    26175    covers    TABLE     �   CREATE TABLE public.covers (
    insuranceplanname character varying(100) NOT NULL,
    healthcareproviderid character varying(10) NOT NULL
);
    DROP TABLE public.covers;
       public         heap    postgres    false    5            �            1259    26126    doctorspecialization    TABLE     �   CREATE TABLE public.doctorspecialization (
    doctorid character varying(10) NOT NULL,
    specialization character varying(50) NOT NULL
);
 (   DROP TABLE public.doctorspecialization;
       public         heap    postgres    false    5            �            1259    25972    employee    TABLE     *  CREATE TABLE public.employee (
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
       public         heap    postgres    false    5                       0    0    COLUMN employee.salary    COMMENT     F   COMMENT ON COLUMN public.employee.salary IS 'Employee salary in USD';
          public          postgres    false    217            �            1259    26077    employeedependent    TABLE       CREATE TABLE public.employeedependent (
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
       public         heap    postgres    false    5            �            1259    26030    insuranceplan    TABLE     �  CREATE TABLE public.insuranceplan (
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
       public         heap    postgres    false    5            �            1259    26449    healthcareproviderclientcount    VIEW     ~  CREATE VIEW public.healthcareproviderclientcount AS
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
       public          admin    false    222    227    227    222    218    238    238    235    235    232    232    230    230    5                       0    0 #   TABLE healthcareproviderclientcount    ACL     G   GRANT SELECT ON TABLE public.healthcareproviderclientcount TO hr_role;
          public          admin    false    246            �            1259    26057    pays    TABLE     \  CREATE TABLE public.pays (
    employeeid character varying(10) NOT NULL,
    clientid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    amount numeric(10,2) NOT NULL,
    purpose text,
    CONSTRAINT pays_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT pays_date_check CHECK ((date <= CURRENT_DATE))
);
    DROP TABLE public.pays;
       public         heap    postgres    false    5            �            1259    26429 !   healthcareproviderservicepayments    VIEW       CREATE VIEW public.healthcareproviderservicepayments AS
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
       public          admin    false    235    235    235    235    234    234    230    230    227    227    224    224    218    5                       0    0 '   TABLE healthcareproviderservicepayments    ACL     \   GRANT SELECT ON TABLE public.healthcareproviderservicepayments TO healthcare_provider_role;
          public          admin    false    244            �            1259    26397 +   healthcareproviderservicepaymentsrestricted    VIEW     �  CREATE VIEW public.healthcareproviderservicepaymentsrestricted AS
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
       public          admin    false    224    235    235    235    235    234    234    230    230    224    218    5                       0    0 1   TABLE healthcareproviderservicepaymentsrestricted    ACL     f   GRANT SELECT ON TABLE public.healthcareproviderservicepaymentsrestricted TO "sami.shams@procare.com";
          public          admin    false    243            �            1259    26015    medicalrecords    TABLE     �  CREATE TABLE public.medicalrecords (
    clientid character varying(10) NOT NULL,
    icdcode character varying(50) NOT NULL,
    datecreated date DEFAULT CURRENT_DATE NOT NULL,
    conditionname character varying(100) NOT NULL,
    description text,
    CONSTRAINT medicalrecords_datecreated_check CHECK ((datecreated <= CURRENT_DATE)),
    CONSTRAINT medicalrecords_icdcode_check CHECK (((icdcode)::text ~ '^[A-Z0-9]{3,4}(\.[A-Z0-9]{1,4})?$'::text))
);
 "   DROP TABLE public.medicalrecords;
       public         heap    postgres    false    5                       0    0    TABLE medicalrecords    ACL     �   GRANT INSERT,DELETE,UPDATE ON TABLE public.medicalrecords TO employee_role;
GRANT SELECT,INSERT,UPDATE ON TABLE public.medicalrecords TO doctor_role;
          public          postgres    false    221            �            1259    26240    refer    TABLE     �   CREATE TABLE public.refer (
    clientid character varying(10) NOT NULL,
    referringdoctorid character varying(10) NOT NULL,
    referreddoctorid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL,
    reason text
);
    DROP TABLE public.refer;
       public         heap    postgres    false    5            �            1259    26219    requestdoctor    TABLE     �   CREATE TABLE public.requestdoctor (
    clientid character varying(10) NOT NULL,
    doctorid character varying(10) NOT NULL,
    healthcareproviderid character varying(10) NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL
);
 !   DROP TABLE public.requestdoctor;
       public         heap    postgres    false    5            �            1259    26303    top5monthlyservicesummary    VIEW     �  CREATE VIEW public.top5monthlyservicesummary AS
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
       public          postgres    false    235    235    235    235    234    234    230    230    5                       0    0    TABLE top5monthlyservicesummary    ACL     T   GRANT SELECT ON TABLE public.top5monthlyservicesummary TO "sami.shams@procare.com";
          public          postgres    false    242            �            1259    25962    users    TABLE       CREATE TABLE public.users (
    userid integer NOT NULL,
    externalid character varying(10) NOT NULL,
    username character varying(100) NOT NULL,
    passwordhash character varying(100) NOT NULL,
    role character varying(20) NOT NULL,
    createdat timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT role_check CHECK (((role)::text = ANY ((ARRAY['Employee'::character varying, 'Client'::character varying, 'Agent'::character varying, 'Doctor'::character varying, 'HealthcareProvider'::character varying])::text[]))),
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['Employee'::character varying, 'Client'::character varying, 'Agent'::character varying, 'Doctor'::character varying, 'HealthcareProvider'::character varying])::text[])))
);
    DROP TABLE public.users;
       public         heap    postgres    false    5                       0    0    TABLE users    ACL     h   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users TO "noor.ghazal@procare.com" WITH GRANT OPTION;
          public          postgres    false    216            �            1259    25961    users_userid_seq    SEQUENCE     �   CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.users_userid_seq;
       public          postgres    false    5    216                       0    0    users_userid_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;
          public          postgres    false    215            �           2604    25965    users userid    DEFAULT     l   ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);
 ;   ALTER TABLE public.users ALTER COLUMN userid DROP DEFAULT;
       public          postgres    false    215    216    216            �          0    26151    agent 
   TABLE DATA           f   COPY public.agent (agentid, agentname, commissionrate, email, licensenumber, phonenumber) FROM stdin;
    public          postgres    false    231   ��       �          0    25984    client 
   TABLE DATA           _   COPY public.client (clientid, firstname, middlename, lastname, dob, gender, email) FROM stdin;
    public          postgres    false    218   ��       �          0    26003    clientaddress 
   TABLE DATA           :   COPY public.clientaddress (clientid, address) FROM stdin;
    public          postgres    false    220   �       �          0    26090    clientdependent 
   TABLE DATA           o   COPY public.clientdependent (clientid, firstname, middlename, lastname, dob, gender, relationship) FROM stdin;
    public          postgres    false    226   �       �          0    25993    clientphonenumber 
   TABLE DATA           B   COPY public.clientphonenumber (clientid, phonenumber) FROM stdin;
    public          postgres    false    219   ��       �          0    26175    covers 
   TABLE DATA           I   COPY public.covers (insuranceplanname, healthcareproviderid) FROM stdin;
    public          postgres    false    233   j�       �          0    26112    doctor 
   TABLE DATA              COPY public.doctor (doctorid, firstname, middlename, lastname, email, phonenumber, supervisorhealthcareproviderid) FROM stdin;
    public          postgres    false    228   /�       �          0    26126    doctorspecialization 
   TABLE DATA           H   COPY public.doctorspecialization (doctorid, specialization) FROM stdin;
    public          postgres    false    229   ��       �          0    26136    employdoctor 
   TABLE DATA           F   COPY public.employdoctor (healthcareproviderid, doctorid) FROM stdin;
    public          postgres    false    230   <�       �          0    25972    employee 
   TABLE DATA           ~   COPY public.employee (employeeid, firstname, middlename, lastname, phonenumber, email, address, salary, jobtitle) FROM stdin;
    public          postgres    false    217   ��       �          0    26077    employeedependent 
   TABLE DATA           s   COPY public.employeedependent (employeeid, firstname, middlename, lastname, dob, gender, relationship) FROM stdin;
    public          postgres    false    225   ��       �          0    26103    healthcareprovider 
   TABLE DATA           t   COPY public.healthcareprovider (healthcareproviderid, providername, providertype, phonenumber, address) FROM stdin;
    public          postgres    false    227   ��       �          0    26030    insuranceplan 
   TABLE DATA           u   COPY public.insuranceplan (insuranceplanname, plantype, description, coveragelevel, premium, deductible) FROM stdin;
    public          postgres    false    222   ��       �          0    26015    medicalrecords 
   TABLE DATA           d   COPY public.medicalrecords (clientid, icdcode, datecreated, conditionname, description) FROM stdin;
    public          postgres    false    221   ��       �          0    26190    medicalservice 
   TABLE DATA           M   COPY public.medicalservice (serviceid, servicename, description) FROM stdin;
    public          postgres    false    234   ~�       �          0    26057    pays 
   TABLE DATA           K   COPY public.pays (employeeid, clientid, date, amount, purpose) FROM stdin;
    public          postgres    false    224   �       �          0    26163    policy 
   TABLE DATA           `   COPY public.policy (policynumber, exactcost, startdate, enddate, insuranceplanname) FROM stdin;
    public          postgres    false    232   A�       �          0    26197    provide 
   TABLE DATA           S   COPY public.provide (clientid, doctorid, serviceid, date, servicecost) FROM stdin;
    public          postgres    false    235   d�       �          0    26240    refer 
   TABLE DATA           \   COPY public.refer (clientid, referringdoctorid, referreddoctorid, date, reason) FROM stdin;
    public          postgres    false    237   .�       �          0    26039    requestclaim 
   TABLE DATA           o   COPY public.requestclaim (employeeid, clientid, datecreated, amount, approvalstatus, decisiondate) FROM stdin;
    public          postgres    false    223   A�       �          0    26219    requestdoctor 
   TABLE DATA           W   COPY public.requestdoctor (clientid, doctorid, healthcareproviderid, date) FROM stdin;
    public          postgres    false    236   W�       �          0    26263    sell 
   TABLE DATA           ?   COPY public.sell (clientid, policynumber, agentid) FROM stdin;
    public          postgres    false    238   ��       �          0    25962    users 
   TABLE DATA           \   COPY public.users (userid, externalid, username, passwordhash, role, createdat) FROM stdin;
    public          postgres    false    216   S�                  0    0    users_userid_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.users_userid_seq', 51, true);
          public          postgres    false    215                       2606    26159    agent agent_licensenumber_key 
   CONSTRAINT     a   ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_licensenumber_key UNIQUE (licensenumber);
 G   ALTER TABLE ONLY public.agent DROP CONSTRAINT agent_licensenumber_key;
       public            postgres    false    231                       2606    26161    agent agent_phonenumber_key 
   CONSTRAINT     ]   ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_phonenumber_key UNIQUE (phonenumber);
 E   ALTER TABLE ONLY public.agent DROP CONSTRAINT agent_phonenumber_key;
       public            postgres    false    231                       2606    26157    agent agent_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_pkey PRIMARY KEY (agentid);
 :   ALTER TABLE ONLY public.agent DROP CONSTRAINT agent_pkey;
       public            postgres    false    231            �           2606    26009    clientaddress client_address_id 
   CONSTRAINT     l   ALTER TABLE ONLY public.clientaddress
    ADD CONSTRAINT client_address_id PRIMARY KEY (clientid, address);
 I   ALTER TABLE ONLY public.clientaddress DROP CONSTRAINT client_address_id;
       public            postgres    false    220    220                       2606    26097 #   clientdependent client_dependent_id 
   CONSTRAINT     �   ALTER TABLE ONLY public.clientdependent
    ADD CONSTRAINT client_dependent_id PRIMARY KEY (clientid, firstname, middlename, lastname);
 M   ALTER TABLE ONLY public.clientdependent DROP CONSTRAINT client_dependent_id;
       public            postgres    false    226    226    226    226            �           2606    25997 !   clientphonenumber client_phone_id 
   CONSTRAINT     r   ALTER TABLE ONLY public.clientphonenumber
    ADD CONSTRAINT client_phone_id PRIMARY KEY (clientid, phonenumber);
 K   ALTER TABLE ONLY public.clientphonenumber DROP CONSTRAINT client_phone_id;
       public            postgres    false    219    219            �           2606    25991    client client_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (clientid);
 <   ALTER TABLE ONLY public.client DROP CONSTRAINT client_pkey;
       public            postgres    false    218                       2606    26179    covers coverage_id 
   CONSTRAINT     u   ALTER TABLE ONLY public.covers
    ADD CONSTRAINT coverage_id PRIMARY KEY (insuranceplanname, healthcareproviderid);
 <   ALTER TABLE ONLY public.covers DROP CONSTRAINT coverage_id;
       public            postgres    false    233    233                       2606    26119    doctor doctor_phonenumber_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_phonenumber_key UNIQUE (phonenumber);
 G   ALTER TABLE ONLY public.doctor DROP CONSTRAINT doctor_phonenumber_key;
       public            postgres    false    228                       2606    26117    doctor doctor_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT doctor_pkey PRIMARY KEY (doctorid);
 <   ALTER TABLE ONLY public.doctor DROP CONSTRAINT doctor_pkey;
       public            postgres    false    228            $           2606    26224    requestdoctor doctor_request_id 
   CONSTRAINT     �   ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT doctor_request_id PRIMARY KEY (clientid, doctorid, healthcareproviderid, date);
 I   ALTER TABLE ONLY public.requestdoctor DROP CONSTRAINT doctor_request_id;
       public            postgres    false    236    236    236    236                       2606    26140    employdoctor employ_doctor_id 
   CONSTRAINT     w   ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT employ_doctor_id PRIMARY KEY (healthcareproviderid, doctorid);
 G   ALTER TABLE ONLY public.employdoctor DROP CONSTRAINT employ_doctor_id;
       public            postgres    false    230    230                       2606    26084 '   employeedependent employee_dependent_id 
   CONSTRAINT     �   ALTER TABLE ONLY public.employeedependent
    ADD CONSTRAINT employee_dependent_id PRIMARY KEY (employeeid, firstname, middlename, lastname);
 Q   ALTER TABLE ONLY public.employeedependent DROP CONSTRAINT employee_dependent_id;
       public            postgres    false    225    225    225    225            �           2606    25982 !   employee employee_phonenumber_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_phonenumber_key UNIQUE (phonenumber);
 K   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_phonenumber_key;
       public            postgres    false    217            �           2606    25980    employee employee_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employeeid);
 @   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_pkey;
       public            postgres    false    217                       2606    26111 5   healthcareprovider healthcareprovider_phonenumber_key 
   CONSTRAINT     w   ALTER TABLE ONLY public.healthcareprovider
    ADD CONSTRAINT healthcareprovider_phonenumber_key UNIQUE (phonenumber);
 _   ALTER TABLE ONLY public.healthcareprovider DROP CONSTRAINT healthcareprovider_phonenumber_key;
       public            postgres    false    227            
           2606    26109 *   healthcareprovider healthcareprovider_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.healthcareprovider
    ADD CONSTRAINT healthcareprovider_pkey PRIMARY KEY (healthcareproviderid);
 T   ALTER TABLE ONLY public.healthcareprovider DROP CONSTRAINT healthcareprovider_pkey;
       public            postgres    false    227            �           2606    26038     insuranceplan insuranceplan_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.insuranceplan
    ADD CONSTRAINT insuranceplan_pkey PRIMARY KEY (insuranceplanname);
 J   ALTER TABLE ONLY public.insuranceplan DROP CONSTRAINT insuranceplan_pkey;
       public            postgres    false    222            �           2606    26024     medicalrecords medical_record_id 
   CONSTRAINT     m   ALTER TABLE ONLY public.medicalrecords
    ADD CONSTRAINT medical_record_id PRIMARY KEY (clientid, icdcode);
 J   ALTER TABLE ONLY public.medicalrecords DROP CONSTRAINT medical_record_id;
       public            postgres    false    221    221                        2606    26196 "   medicalservice medicalservice_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.medicalservice
    ADD CONSTRAINT medicalservice_pkey PRIMARY KEY (serviceid);
 L   ALTER TABLE ONLY public.medicalservice DROP CONSTRAINT medicalservice_pkey;
       public            postgres    false    234                       2606    26066    pays payment_id 
   CONSTRAINT     e   ALTER TABLE ONLY public.pays
    ADD CONSTRAINT payment_id PRIMARY KEY (employeeid, clientid, date);
 9   ALTER TABLE ONLY public.pays DROP CONSTRAINT payment_id;
       public            postgres    false    224    224    224                       2606    26169    policy policy_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.policy
    ADD CONSTRAINT policy_pkey PRIMARY KEY (policynumber);
 <   ALTER TABLE ONLY public.policy DROP CONSTRAINT policy_pkey;
       public            postgres    false    232            "           2606    26203    provide provided_service_id 
   CONSTRAINT     z   ALTER TABLE ONLY public.provide
    ADD CONSTRAINT provided_service_id PRIMARY KEY (clientid, doctorid, serviceid, date);
 E   ALTER TABLE ONLY public.provide DROP CONSTRAINT provided_service_id;
       public            postgres    false    235    235    235    235            &           2606    26247    refer referal_id 
   CONSTRAINT        ALTER TABLE ONLY public.refer
    ADD CONSTRAINT referal_id PRIMARY KEY (clientid, referringdoctorid, referreddoctorid, date);
 :   ALTER TABLE ONLY public.refer DROP CONSTRAINT referal_id;
       public            postgres    false    237    237    237    237                        2606    26046    requestclaim request_id 
   CONSTRAINT     t   ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT request_id PRIMARY KEY (employeeid, clientid, datecreated);
 A   ALTER TABLE ONLY public.requestclaim DROP CONSTRAINT request_id;
       public            postgres    false    223    223    223            (           2606    26267    sell sell_transaction_id 
   CONSTRAINT     s   ALTER TABLE ONLY public.sell
    ADD CONSTRAINT sell_transaction_id PRIMARY KEY (clientid, policynumber, agentid);
 B   ALTER TABLE ONLY public.sell DROP CONSTRAINT sell_transaction_id;
       public            postgres    false    238    238    238                       2606    26130 &   doctorspecialization specialization_id 
   CONSTRAINT     z   ALTER TABLE ONLY public.doctorspecialization
    ADD CONSTRAINT specialization_id PRIMARY KEY (doctorid, specialization);
 P   ALTER TABLE ONLY public.doctorspecialization DROP CONSTRAINT specialization_id;
       public            postgres    false    229    229            �           2606    25969    users users_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    216            �           2606    25971    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public            postgres    false    216                       1259    26162    unique_email_agent    INDEX     [   CREATE UNIQUE INDEX unique_email_agent ON public.agent USING btree (lower((email)::text));
 &   DROP INDEX public.unique_email_agent;
       public            postgres    false    231    231            �           1259    25992    unique_email_client    INDEX     ]   CREATE UNIQUE INDEX unique_email_client ON public.client USING btree (lower((email)::text));
 '   DROP INDEX public.unique_email_client;
       public            postgres    false    218    218                       1259    26125    unique_email_doctor    INDEX     ]   CREATE UNIQUE INDEX unique_email_doctor ON public.doctor USING btree (lower((email)::text));
 '   DROP INDEX public.unique_email_doctor;
       public            postgres    false    228    228            �           1259    25983    unique_email_employee    INDEX     a   CREATE UNIQUE INDEX unique_email_employee ON public.employee USING btree (lower((email)::text));
 )   DROP INDEX public.unique_email_employee;
       public            postgres    false    217    217            B           2606    26278    sell fk_agentid    FK CONSTRAINT     �   ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_agentid FOREIGN KEY (agentid) REFERENCES public.agent(agentid) ON UPDATE CASCADE ON DELETE CASCADE;
 9   ALTER TABLE ONLY public.sell DROP CONSTRAINT fk_agentid;
       public          postgres    false    238    231    4889            )           2606    25998    clientphonenumber fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.clientphonenumber
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.clientphonenumber DROP CONSTRAINT fk_clientid;
       public          postgres    false    219    218    4853            *           2606    26010    clientaddress fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.clientaddress
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.clientaddress DROP CONSTRAINT fk_clientid;
       public          postgres    false    218    220    4853            +           2606    26025    medicalrecords fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.medicalrecords
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.medicalrecords DROP CONSTRAINT fk_clientid;
       public          postgres    false    218    4853    221            ,           2606    26052    requestclaim fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.requestclaim DROP CONSTRAINT fk_clientid;
       public          postgres    false    4853    218    223            .           2606    26072    pays fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.pays
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 :   ALTER TABLE ONLY public.pays DROP CONSTRAINT fk_clientid;
       public          postgres    false    4853    218    224            1           2606    26098    clientdependent fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.clientdependent
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.clientdependent DROP CONSTRAINT fk_clientid;
       public          postgres    false    226    4853    218            9           2606    26204    provide fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.provide DROP CONSTRAINT fk_clientid;
       public          postgres    false    218    4853    235            <           2606    26225    requestdoctor fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.requestdoctor DROP CONSTRAINT fk_clientid;
       public          postgres    false    218    4853    236            ?           2606    26248    refer fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 ;   ALTER TABLE ONLY public.refer DROP CONSTRAINT fk_clientid;
       public          postgres    false    237    4853    218            C           2606    26268    sell fk_clientid    FK CONSTRAINT     �   ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_clientid FOREIGN KEY (clientid) REFERENCES public.client(clientid) ON UPDATE CASCADE ON DELETE CASCADE;
 :   ALTER TABLE ONLY public.sell DROP CONSTRAINT fk_clientid;
       public          postgres    false    238    218    4853            3           2606    26131     doctorspecialization fk_doctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.doctorspecialization
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.doctorspecialization DROP CONSTRAINT fk_doctorid;
       public          postgres    false    4878    228    229            4           2606    26146    employdoctor fk_doctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.employdoctor DROP CONSTRAINT fk_doctorid;
       public          postgres    false    228    230    4878            :           2606    26209    provide fk_doctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON DELETE SET NULL;
 =   ALTER TABLE ONLY public.provide DROP CONSTRAINT fk_doctorid;
       public          postgres    false    235    4878    228            =           2606    26230    requestdoctor fk_doctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_doctorid FOREIGN KEY (doctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.requestdoctor DROP CONSTRAINT fk_doctorid;
       public          postgres    false    228    236    4878            -           2606    26047    requestclaim fk_employeeid    FK CONSTRAINT     �   ALTER TABLE ONLY public.requestclaim
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.requestclaim DROP CONSTRAINT fk_employeeid;
       public          postgres    false    4850    223    217            /           2606    26067    pays fk_employeeid    FK CONSTRAINT     �   ALTER TABLE ONLY public.pays
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE SET NULL;
 <   ALTER TABLE ONLY public.pays DROP CONSTRAINT fk_employeeid;
       public          postgres    false    224    4850    217            0           2606    26085    employeedependent fk_employeeid    FK CONSTRAINT     �   ALTER TABLE ONLY public.employeedependent
    ADD CONSTRAINT fk_employeeid FOREIGN KEY (employeeid) REFERENCES public.employee(employeeid) ON UPDATE CASCADE ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.employeedependent DROP CONSTRAINT fk_employeeid;
       public          postgres    false    4850    217    225            2           2606    26120     doctor fk_healthcare_provider_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.doctor
    ADD CONSTRAINT fk_healthcare_provider_id FOREIGN KEY (supervisorhealthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE SET NULL;
 J   ALTER TABLE ONLY public.doctor DROP CONSTRAINT fk_healthcare_provider_id;
       public          postgres    false    227    4874    228            5           2606    26141 $   employdoctor fk_healthcareproviderid    FK CONSTRAINT     �   ALTER TABLE ONLY public.employdoctor
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.employdoctor DROP CONSTRAINT fk_healthcareproviderid;
       public          postgres    false    230    4874    227            7           2606    26185    covers fk_healthcareproviderid    FK CONSTRAINT     �   ALTER TABLE ONLY public.covers
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.covers DROP CONSTRAINT fk_healthcareproviderid;
       public          postgres    false    227    4874    233            >           2606    26235 %   requestdoctor fk_healthcareproviderid    FK CONSTRAINT     �   ALTER TABLE ONLY public.requestdoctor
    ADD CONSTRAINT fk_healthcareproviderid FOREIGN KEY (healthcareproviderid) REFERENCES public.healthcareprovider(healthcareproviderid) ON UPDATE CASCADE ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.requestdoctor DROP CONSTRAINT fk_healthcareproviderid;
       public          postgres    false    236    4874    227            6           2606    26170    policy fk_insuranceplanname    FK CONSTRAINT     �   ALTER TABLE ONLY public.policy
    ADD CONSTRAINT fk_insuranceplanname FOREIGN KEY (insuranceplanname) REFERENCES public.insuranceplan(insuranceplanname) ON UPDATE CASCADE ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.policy DROP CONSTRAINT fk_insuranceplanname;
       public          postgres    false    232    222    4862            8           2606    26180    covers fk_insuranceplanname    FK CONSTRAINT     �   ALTER TABLE ONLY public.covers
    ADD CONSTRAINT fk_insuranceplanname FOREIGN KEY (insuranceplanname) REFERENCES public.insuranceplan(insuranceplanname) ON UPDATE CASCADE ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.covers DROP CONSTRAINT fk_insuranceplanname;
       public          postgres    false    222    233    4862            D           2606    26273    sell fk_policynumber    FK CONSTRAINT     �   ALTER TABLE ONLY public.sell
    ADD CONSTRAINT fk_policynumber FOREIGN KEY (policynumber) REFERENCES public.policy(policynumber) ON UPDATE CASCADE ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.sell DROP CONSTRAINT fk_policynumber;
       public          postgres    false    232    4892    238            @           2606    26258    refer fk_referreddoctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_referreddoctorid FOREIGN KEY (referreddoctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.refer DROP CONSTRAINT fk_referreddoctorid;
       public          postgres    false    4878    237    228            A           2606    26253    refer fk_referringdoctorid    FK CONSTRAINT     �   ALTER TABLE ONLY public.refer
    ADD CONSTRAINT fk_referringdoctorid FOREIGN KEY (referringdoctorid) REFERENCES public.doctor(doctorid) ON UPDATE CASCADE ON DELETE SET NULL;
 D   ALTER TABLE ONLY public.refer DROP CONSTRAINT fk_referringdoctorid;
       public          postgres    false    4878    237    228            ;           2606    26214    provide fk_serviceid    FK CONSTRAINT     �   ALTER TABLE ONLY public.provide
    ADD CONSTRAINT fk_serviceid FOREIGN KEY (serviceid) REFERENCES public.medicalservice(serviceid) ON DELETE SET NULL;
 >   ALTER TABLE ONLY public.provide DROP CONSTRAINT fk_serviceid;
       public          postgres    false    235    234    4896            �           0    26151    agent    ROW SECURITY     3   ALTER TABLE public.agent ENABLE ROW LEVEL SECURITY;          public          postgres    false    231            �           3256    26441    agent agent_access_policy    POLICY     @   CREATE POLICY agent_access_policy ON public.agent USING (true);
 1   DROP POLICY agent_access_policy ON public.agent;
       public          postgres    false    231            �           3256    26395    agent agent_row_policy    POLICY     W   CREATE POLICY agent_row_policy ON public.agent USING (((email)::text = CURRENT_USER));
 .   DROP POLICY agent_row_policy ON public.agent;
       public          postgres    false    231    231            �           0    25984    client    ROW SECURITY     4   ALTER TABLE public.client ENABLE ROW LEVEL SECURITY;          public          postgres    false    218            �           3256    26394    client client_row_policy    POLICY     Y   CREATE POLICY client_row_policy ON public.client USING (((email)::text = CURRENT_USER));
 0   DROP POLICY client_row_policy ON public.client;
       public          postgres    false    218    218            �           3256    26407 -   healthcareprovider healthcare_provider_policy    POLICY     �   CREATE POLICY healthcare_provider_policy ON public.healthcareprovider USING (((lower(replace((providername)::text, ' '::text, '.'::text)) || '@healthcare.com'::text) = CURRENT_USER));
 E   DROP POLICY healthcare_provider_policy ON public.healthcareprovider;
       public          postgres    false    227    227            �           0    26103    healthcareprovider    ROW SECURITY     @   ALTER TABLE public.healthcareprovider ENABLE ROW LEVEL SECURITY;          public          postgres    false    227            �           3256    26446 (   requestclaim request_claim_client_policy    POLICY     2  CREATE POLICY request_claim_client_policy ON public.requestclaim USING ((((clientid)::text = (( SELECT client.clientid
   FROM public.client
  WHERE (lower((client.email)::text) = CURRENT_USER)))::text) OR (CURRENT_USER = ANY (ARRAY['fadi.salameh@procare.com'::name, 'layla.kassem@procare.com'::name]))));
 @   DROP POLICY request_claim_client_policy ON public.requestclaim;
       public          postgres    false    223    218    218    223            �           0    26039    requestclaim    ROW SECURITY     :   ALTER TABLE public.requestclaim ENABLE ROW LEVEL SECURITY;          public          postgres    false    223            �     x�U��N�0���+�V�Nw���T�vC�fҸ������z�$�pv��#g�˗cH_������d2a�@6�G�����΍�(N�,WA����<��q�V_ wr�D��2fY�L`�M����������e�r�2�W��N�mʹ�;J�]�:����L(��˒=��a�0b����sB��d�%����˜e�R�k3h��O�\:�G��Ǌq¸�#N��q���\ �/�)�l��}�M�E:˳�6��E!�����tY�N��=Is�̃o���f      �   D  x�e�MO�@�����.-n�����DM���TP�������w���r�'Ͼ����h�Y*;G;��і/�E�)�*��#q�t��}��u�k��z�R:��酽i�#{��Q&WiF�@u+��]Г�6Õ+:q%t��U@G u�rl.�4\GzF*=pS�Y��@.��J걚�־ᮮ�7�%u�L�����r���֝��Ƴ����7WkJ�� �۫�%m�r�>\C���mLkU�":׷��t����c�N�N�e��N��ۉ�~!�q�ހ+*C�)�ʮ��
�, ����*����0��������\�>a}�O��I��B�&      �   �   x�]��n�0��y�� ��Yƨ�F������!	�N�I�}(���~���x�n�?FΊ:�ʅdݍ���� �+]�\�w�j��4a��n��]TZ�v�H�	�_���?PR�=2ԈB�Ժ(5)<T�4�+b�f8=��A��{*;'2��AՊ6L���&�t�n���7�D��=����jn6܉(Ƒ���7�ix��$��ݹY�����'�q~ !�]�      �   �   x�m��N�0Dד	J�&�eHy�eS�ͭl�C�HN�(_�8J���7����-�O	O��������Q�>�IJp���U�}T�������G.�K��7+����s���֝�w��xk�9�֊��5�m��c�]���K1#�ݭ�9��x�<q��8h���������|�
���q�޷�3S�k2�s�W�g�,��
ސ���X&��Y�&d��yE��<t!      �   ]   x�]�A
�0D�u<L���d�U�G����A����E�u*�JXm�GȦ�͡PJ-��LJ�V¢8��t4	Fh*%�$��&�������?�!"��'G      �   �   x�}���0Eg����f�@�1R��Z4���$���I�
U���#�W5+QRh� if%Y�
§�2.����h��ĸ����l����Wq�[N�VP�{�N�tu���ZC!���L{���C�:�.Hd���B�&	�u�B��c�&J�� �����������ᄯs x��p�      �   D  x�U�OO�0�����vc�4Ɔ6\@\\VH��=�O��և���=��b;]W)=,���5�6|��� ��.,�Z�ƪ��A�eU��]=q8Y��<��"��3��4���S��&�0$�L(9�j����3���i�C�9�I>�|A�� l��0;��<uU�a�L0�`�i��-lP�^��Q_��L�Q
��5Z���صN�Q�,"#
aT¨�E���~`;\������)=�ÔR0�`�p[#��o�����~�8�+��%Nwm��R|�t�M��pPa1���#,����H���(<�YS8K��$�?���^      �   �   x�e���0��S����-	W/�lh�R�v9�����_f'�8��*�ڶ�lbO�HN��+����� E ��(?�#b�v�tˮ%�C
��W����ZE� Cj$��
?(=,�{Z�.��C
�eO5��+<dc착��k����I�Ӭ�m���>��s�\�      �   H   x�]ȹ�  ��:����IA���(n��z�Ms��3�;�?��C��$ IHB2����"�k�nIϷ%m      �   <  x�m��r�0�����t<��1�i��$�әN�7��`Yb$��<}��qZ.�>�gYm�9}����k�Z�p�e�%d"'�$��%3�z������
[����ay�-�rm"�<�r�����+y����+�ox�9֊�转!�5ݙѡ��q�V��YN�V ��ԨjO�bp�ã�[��-=�f"P8<��^P�	[�]��Ui�<P6��Qf��,j�VBC3��u��;�4E
(Yѯ^��)���$C��� ���ٲ���T�(�k,����i�eE�#�'�"�e��=^�@ܕb2�ۿq&45��!
�t��4�yQݩR<fk��2!�#V�"�����W{�)\Úr<�=�=#I��<J���$cw��T�Sֶ5�&!�4dj}ckI��
ɶ���т�S�R�3Җ�tx��h߫�t��)R�|_�8��EAo�|(��}��Y�����8xr"߉P���5^6l~��K�]SL���U#�Cr��9�`a[�]�
��q¡���m��ELR������C,.wL����Ȣm�����h4�uH%      �     x�]��N�0Eדd;�eP[%P6 67Jh,�DJ�E�zl�J�����չ�-�}��m��`�{4RB
1˘J��!�zXћ��4U@�8�"c%�\H�0�>��z�<�d%,'B�j�F�E���J��{�$�8e���iGL��\�a���L;o�ô��,r�D_�r6%�y<9�HX^�)m��z{L�Ѓ�v�9�d'����-�t�3���^����O#b�Xe����g���:���%��ed�UI+��	޺�`f�h���ϛ ~��u�      �   �  x�m��N�0��ӧ�T�݁�%���� !n�֬i:%����i7TQE֗ߟ�M�|����fl���fÅ�$G����+im�9�}箲��T�0!�ke�6PS�4�kY�V�Q��!I[ک��2x,cȰ��3TwT�Ú�O�Whk,�jH�s&K=~���b�.�˿yFj�5�-�&aJƓ=��r�T,tu�&�'˫Fs�zߥ*PÕm�+���`Լ��IxѽxacȹlL�;V�5�%�b��g����@���]�o��a��G���Ao��C�o� ��.L�F�O�ݸw�r2��^RNv�9	US�Q83��$ۆ� .J�1g�B;{]]��z/�+1��s
(�Ğ�&�7&��(�5�ͧ�yYS��@/��EQ�;���      �   �  x�eS�n�0=�_�X
']�^פib v�E�阈,�l���і� �I6%�G�G�JO
(u���҈�ϣ(���D�6������ϔ����i��<�s�Χ3�k���F�J��(��XU�<T�-i
_@Tm�'sI�jLi#�����R<F������(�O��g2\1�Ҕ��P���`e4��m�/8/����4�G���{4�������>�x��6	qF��`�����`��ބzu��E�~�B�Vt�a�e�¤ם�C!>쀎����&�Ԝ��rI��)�ζ5��olr�x��!�lr@5�q3>^�*�:�%����sw�UWL�_F 2<OGVĊ�7j͞���-�4���"#>~�d��>$o^}��6F�S�J��N�Ѭz�.~���G�[bY\$�F,	������'�({i�X��/I��(�O����ݸ.��07qq�I��L�/��N?V��m��>�Ά��7�J��Xq^T׮]�_?߭ߟ�,��~#E�      �   �  x�e��r�0���S�*F8�#��В�Io���+#ɡ�}�`{:S4I������~'蓰r*@	5�BrY����[�g��+�fd�6�ՎY_��6���NP�]��#̸�\��f�7��6���N�N��c�f�!�����-1�<IyǑ �i�!S���3&�4Tj3�W����M�?�f]g�i �a'�]�(�\�SJ�s���1�OĀ�=6�t!T�1�6�(����E��J�7�r�¹�G$�+֮�C�)�x���nF�K�h���3�����M�f4u��!T���l�+���#�+��i�3���Å���`m=tˠ��Ʈ��;�ӻ<��hlɥ��"{�[�)�bE�p��l��2�]�6�2���́������m�UAެ����"����gj��%�+�єҶP�y?h��Hdyg�muD���l][Ӻ|�	��j\H�B�NO����d2���      �   �  x�m��n�0���S�8H��4�4)� 5P�N�C/+rm-B�*�T�<}����P]Q;��o��ۜ�sa~R��n[�O�қu,��`�3� 9��ġN{h	}n����'����`K��/lb��Џ�Rh@_04Ө��qu���y\&�}�{{�d���
U���M$��@r*6�D�/f�����`n܀��>Z�bG��a�G�Y���n��*�m�-�Ѭ�ņ=�#�D�;
���OJ�8M��ϥ����i��~�9�����X�$�����~� jfS�9v���ғ�[�i�O��̃�	%����H����3
q"¸�µ�5�nu5�������~�1�w�}�5�JD��f��R�W�G���4�%1ۙc���e"�WC�%Rj��g���Z6��      �     x�u����0���yK�ڣH�-H���`�%]M��.}��Mj���|��?��7�}T��|`�)Oc�bFAP��>�pѭ"oJa��`{< 3������G��U�ڜf��6�$�$���N�WR#N����.�Sȼ+��d�U���4��+3�+u���񛔈n�٬"�d��
Y��ې�u�n����O�.b�!����y����"�̽�Aڋ�I��=�/�>�>��.� ���eԏ+m�{/�]�e>�A&�k�~>7Q��i��      �     x�mѽn� �����#���1u[eie)C�.4>�HW`[��׎S�� ��������.����@)p�EJ�r�'�i��Iy}!'Tf�Hc�M��q(d���ɵ��^��/��Vw0��Y�<�%�C���C����DE�J���hG������?��h,eh)Ҍ�I_;��to���CW�CyW�����#.E���1.�����^O=�@c,z��%d��04[�y��e�G�+���B�r�|F�G����,+�������V����9���C�$�Ǒ�      �   �   x���1�0�ٹ���i2�������T�˩
RK�?<9N�t�r;F�cZB���\������Ea����
<g�Jb=����{,�X'J=6�ѱ�n�H�
l�3��f�
[܎$���Ί��Bq��8:�d<��+�[����/�O�����~�g�W�''������*y!�7؜��      �     x�m��J�0�s�y�J��=.�ꂫ��'/!6�&K>v��4��hN��1������S����&����:+�,�Ng�+�<�vAy��tXt�(�
uI�`��=\�
7���j�9�%Wl�87�����Р�5�3�F��ǥ�ml�&�qC�qNDO����ٺE�B��%/�6����v�;2�Y�v�O)�6��5��У��e��s�jzl]B���ɻt�zl�@|'���k�$�A��Gz���+�����!��\      �     x����N�0�ϛwI���/GD{@�����P9������e��z)�(�(�/�3vVO�����C~ 0hl���;�p�w�����v"v�O�T��d��Ʊ�n���߅�p�4���+l��r+�)�U�z#�I,WE�c�b�L�^(�c��E4VŒk�B7�P�<��;��b��n�d���b�	�1�ƽ�.v8^���[�����ˉɯ\�B����ntM`�*���y9p�-�F̟
�K3ۥ����n]�} ���      �   y   x�Eʻ�0 �:��IQ�Z) �3@��#������[V�x^s�k~���*�h�[�P�P�Q9TF9�Q�QUP%TAUTE�P�P�B5TGuT�Q5P#Ը�ʭ�l���~gJ�-�K+      �   c   x�e�;
�0D�:o1��-%�*��F̭2��a���f[�\��`��������v���B
y(B
���4P�f(A*P�
�ҩ��;��g���8�      �   M  x���?o�0�g�St�B"��8AS�E3t�r�h�6%9��V��=[� E����6��yw��1{���+f]��PUP�\W�Ӽ�v#�7��ѿ�9X]��}�L�e����f"�6�o��gKY,#�e��(^�fa����n�	H���@�[��W�W���N�����	����p]�HI eZ��>�e����i��;�k�6�.�$��
,.�à�w� ���]����7��8�����\C��c���ed� ����N7`���+kt�$Ǌ�X�ɂ�8¦=M��&[[�������V��x��N���L��	��N	��ڬ�=<#xvnBǇ�v�	��	���,?� �@zA�b2���ztMp�m��|�P�"bv���8��~�����c.�\J���bl�!VV2���W��e�"�b;��!7!n°�Ѡ�`S¦�c���f�ͨ�^s�x��>� n�	����фŉ;�*6f�W�9X7���8WM�CW���H�1Wy�0k
�S��ш�	�������aЊ�jʀhnӮ������t�l𨽪���)��)�a0k�U��2<#x6]~N��i�3'z>�3t�6� r1f��N�����c9`��D�D�i5]5k��7����*My7~u9?����u���k�K!�2��2!J��`�������c��IS��d����є{~@�h��MHT�=ׁ�B�D�� 3�lJ�	���m��������u��\�	�L7��P��rlM?�jN�;�*!%�]4'���t�͙׭��T]�ݫ)�\�ID�������e����xFz5�t�X�YE��b�4��u     