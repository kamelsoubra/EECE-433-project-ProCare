PGDMP      (            
    |            project    16.4    16.4 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                        0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    25942    project    DATABASE     �   CREATE DATABASE project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE project;
                admin    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                admin    false                       0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   admin    false    5            �            1259    26151    agent    TABLE     �  CREATE TABLE public.agent (
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
       public         heap    postgres    false    5                       0    0    TABLE agent    ACL     x   GRANT SELECT ON TABLE public.agent TO agent_role;
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
       public         heap    postgres    false    5                       0    0    TABLE policy    ACL     A   GRANT SELECT,INSERT,UPDATE ON TABLE public.policy TO agent_role;
          public          postgres    false    232            �            1259    26263    sell    TABLE     �   CREATE TABLE public.sell (
    clientid character varying(10) NOT NULL,
    policynumber character varying(10) NOT NULL,
    agentid character varying(10) NOT NULL
);
    DROP TABLE public.sell;
       public         heap    postgres    false    5                       0    0 
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
       public          postgres    false    231    238    238    238    232    232    232    231    231    5                       0    0    TABLE agentearningsannually    ACL     �   GRANT SELECT ON TABLE public.agentearningsannually TO agent_role;
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
       public          admin    false    241    241    241    241    241    231    231    5                       0    0 %   TABLE agentearningsannuallyrestricted    ACL     `   GRANT SELECT ON TABLE public.agentearningsannuallyrestricted TO "karim.boukhallil@procare.com";
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
       public         heap    postgres    false    5            	           0    0    TABLE client    ACL     �   GRANT INSERT,DELETE,UPDATE ON TABLE public.client TO employee_role;
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
       public         heap    postgres    false    5            
           0    0    TABLE healthcareprovider    ACL     M   GRANT SELECT ON TABLE public.healthcareprovider TO healthcare_provider_role;
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
       public         heap    postgres    false    5                       0    0    TABLE provide    ACL     C   GRANT SELECT,INSERT,UPDATE ON TABLE public.provide TO doctor_role;
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
       public          postgres    false    218    218    218    218    227    227    228    230    230    234    234    235    235    235    235    235    5                       0    0    TABLE clientservicepaymentsview    ACL     T   GRANT SELECT ON TABLE public.clientservicepaymentsview TO "sami.shams@procare.com";
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
       public         heap    postgres    false    5                       0    0    TABLE requestclaim    ACL     �   GRANT SELECT ON TABLE public.requestclaim TO client_role;
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
       public          postgres    false    223    223    223    218    218    218    218    223    5                       0    0    TABLE clientsummaryfiltered    ACL     R   GRANT SELECT ON TABLE public.clientsummaryfiltered TO "layla.kassem@procare.com";
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
       public         heap    postgres    false    5                       0    0    COLUMN employee.salary    COMMENT     F   COMMENT ON COLUMN public.employee.salary IS 'Employee salary in USD';
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
       public          admin    false    222    227    227    222    218    238    238    235    235    232    232    230    230    5                       0    0 #   TABLE healthcareproviderclientcount    ACL     G   GRANT SELECT ON TABLE public.healthcareproviderclientcount TO hr_role;
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
       public          admin    false    235    235    235    235    234    234    230    230    227    227    224    224    218    5                       0    0 '   TABLE healthcareproviderservicepayments    ACL     \   GRANT SELECT ON TABLE public.healthcareproviderservicepayments TO healthcare_provider_role;
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
       public          admin    false    224    235    235    235    235    234    234    230    230    224    218    5                       0    0 1   TABLE healthcareproviderservicepaymentsrestricted    ACL     f   GRANT SELECT ON TABLE public.healthcareproviderservicepaymentsrestricted TO "sami.shams@procare.com";
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
       public         heap    postgres    false    5                       0    0    TABLE medicalrecords    ACL     �   GRANT INSERT,DELETE,UPDATE ON TABLE public.medicalrecords TO employee_role;
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
       public          postgres    false    235    235    235    235    234    234    230    230    5                       0    0    TABLE top5monthlyservicesummary    ACL     T   GRANT SELECT ON TABLE public.top5monthlyservicesummary TO "sami.shams@procare.com";
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
       public         heap    postgres    false    5                       0    0    TABLE users    ACL     h   GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users TO "noor.ghazal@procare.com" WITH GRANT OPTION;
          public          postgres    false    216            �            1259    25961    users_userid_seq    SEQUENCE     �   CREATE SEQUENCE public.users_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.users_userid_seq;
       public          postgres    false    5    216                       0    0    users_userid_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.users_userid_seq OWNED BY public.users.userid;
          public          postgres    false    215            �           2604    25965    users userid    DEFAULT     l   ALTER TABLE ONLY public.users ALTER COLUMN userid SET DEFAULT nextval('public.users_userid_seq'::regclass);
 ;   ALTER TABLE public.users ALTER COLUMN userid DROP DEFAULT;
       public          postgres    false    215    216    216            �          0    26151    agent 
   TABLE DATA                 public          postgres    false    231   ��       �          0    25984    client 
   TABLE DATA                 public          postgres    false    218   f�       �          0    26003    clientaddress 
   TABLE DATA                 public          postgres    false    220   5�       �          0    26090    clientdependent 
   TABLE DATA                 public          postgres    false    226   b�       �          0    25993    clientphonenumber 
   TABLE DATA                 public          postgres    false    219   ��       �          0    26175    covers 
   TABLE DATA                 public          postgres    false    233   ��       �          0    26112    doctor 
   TABLE DATA                 public          postgres    false    228   ��       �          0    26126    doctorspecialization 
   TABLE DATA                 public          postgres    false    229   z�       �          0    26136    employdoctor 
   TABLE DATA                 public          postgres    false    230   {�       �          0    25972    employee 
   TABLE DATA                 public          postgres    false    217   +�       �          0    26077    employeedependent 
   TABLE DATA                 public          postgres    false    225   �       �          0    26103    healthcareprovider 
   TABLE DATA                 public          postgres    false    227   ��       �          0    26030    insuranceplan 
   TABLE DATA                 public          postgres    false    222   ��       �          0    26015    medicalrecords 
   TABLE DATA                 public          postgres    false    221   �       �          0    26190    medicalservice 
   TABLE DATA                 public          postgres    false    234   b�       �          0    26057    pays 
   TABLE DATA                 public          postgres    false    224   Q�       �          0    26163    policy 
   TABLE DATA                 public          postgres    false    232   ��       �          0    26197    provide 
   TABLE DATA                 public          postgres    false    235   O�       �          0    26240    refer 
   TABLE DATA                 public          postgres    false    237   ��       �          0    26039    requestclaim 
   TABLE DATA                 public          postgres    false    223   ��       �          0    26219    requestdoctor 
   TABLE DATA                 public          postgres    false    236   ��       �          0    26263    sell 
   TABLE DATA                 public          postgres    false    238   ��       �          0    25962    users 
   TABLE DATA                 public          postgres    false    216   M�                  0    0    users_userid_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.users_userid_seq', 51, true);
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
       public          postgres    false    223    218    218    223            �           0    26039    requestclaim    ROW SECURITY     :   ALTER TABLE public.requestclaim ENABLE ROW LEVEL SECURITY;          public          postgres    false    223            �   �  x���Mo�@໿bnjB6 _�^j[Sm�M�6��Aײ
�e�P}gфM�.0o��	���b5Y�a�X�©��e��e��&vTSn�6KS���d��<E�X@��T\�i�sNq&�E>����
z���ڦ��Z�]b*`q�b*}f�����ړї���������Mg���,�2�ϬT��.fI)�i��y؊٭$\$w�ޅ��E�k�G��=-x�.H`|L�/⃎6�^-�Vľ���9&���9��d� ;��-X��� ������s��A+�@�	��i��G�*f�vh��V�C-XcΏ��ʽ1���j����k�<҂)ұqOm4tL�6�#C�!vl-���F�uC�)e���ˊ�9��N��o+�      �   �  x�ŕ�N�0��}
�
Rl�)�&�PQ��vw�Im�[;Y%�з�;��lr�L�_ѧ?�'����y˖���s,�݉����`�Z��7۴x�0o�v&��Ou]$��T�4	3��d�櫟wv1�Y-%^j����Y*��Qs�=U�gS.S����-�(q�:�O�j?��>Z�7ޔ V�����8�\f<��݂�bq �P��x�P�45kh���W�GY0�F��p(����1 >��To�4q�r��yor�Z�I0��3�c	��(:�'\N�D�.c"�hq(�o��"dy^z�O��3������%���CQϾ�����K}l[���Ӭx��V�$��
<�Nq�m�1�sV���ι����� �8�P�y7�l�p�%�d޶p���s5��>�Z )�V2�8m+Cݫ��~��"�oA���	j�'�W���/:7$�      �     x���ˎ�@н_qwhB&
�#��È���
�*ӂ��Ŀ���]w:uR�7>�QV >)nC���q��uOJ��u����\��f��%�(���'��y�g`ϊZdϯ!K;���s� <x|�M3��E�ʭ�bM���/q������\TS[��4��]1��h�.R�70ԀDJ�]dB
�F���z*�!��Z�<��C��������q"}}e���뱷޻�����>J�tֈ��\Y�1�g"�f��+k�� � )���:RI�E`17�j�P�K��a��a�O&�)�L�      �   [  x�͔�O�0������l �񄀺�#ah��Vl;�m���<�W�|��Ҽ.��|_�4��7(I7+tlrζ7[Ψ�	=RIt��n��혪j	��H0B8u9��.)���A"E9Ԭ�U��=�>Y��3���$�_�(��d]00�3^�p0��KpcW�d�4���*�=t��r�@���V�A,l!��d%@��B�Zl��ve�f�Jy]⡡��_��a���-�����x� E���G�Tݵ�x���<b^�	�?�#l嗣��::���P��$���^&q����5�s_g/�\����2�wZ�P��KA�}�,���2��Z~��Q/@8g��=�q���~������+      �   �   x��ӱ
�0��=Oq[�$1j�S)�Pm@+T��������t�f���O�������;����4�y�{�?��G?� ��tK�k��P_�"y��ڎ�	�B��fy!����.W���v��]O�e/�uK�+v=�v�5��S;�]/�q��qԎ�e���&�~�]��<�      �     x���MO�0�{�oݤ	m|#N��p�k���*I#��d�ʸe���#�o�U[���^�_�6��7��	i7X�9��i�ΠC&}Ǚ�ޚ@-�)�/���&�sġ�Ao�3ȫ��ǳȧ�Y�R{��I�PĊ�s�s�=1	����_�yr�0��ءv�twq��.�sm;xD1p�_���\��S$����c������Ƣ�A�J�ѹ�x�\l� �2��mz5K��19c��3�����1?��,�
��      �   �  x����N1 �{�·���� .D@� J�$T*�٬���z�H���j��eg<�3���Xnn�[�XnWlߖZ�xew��Y���`��5�(X��J�k�5(]���F��.�+X��{W�uR�>�8�w�]U�Oz���o7�{����_�[��\�Pap/A�Sd[w����(����;[c�7�'��ƿ����/;�ltl��0�@��,�(5���Ju��E�A^�!����ҭj �گ������,u���y�F�a����_5�	1tX�a �n�Fy�����49A���`�?c��H6�h�hl�tX����S�$���_(OmDE�I^�i|ʶ���G��M#T�K�/ryHy�G�i^���<�/ܝ�]Nפ��5)�T��5ˋ'UB�S��@�
�4�l�.����a��dsM�%�R�G?̍ORTx����,��|D<�       �   �   x���Mj�0�O��%�oJW%I���K�v��C< Kb4^����@�-���Ӽ����yTU}lTO�U�{�j�?��;���b�R�_������ЪE�ov��lʕ*w�:�֟�r�TTBJ��i�ޡC����}̆fB����4Ľ)�(�O���6':E������H�.){�A�$s��'ӧ��*5�$�!�м��Hg˳Mԋ�Nҝ~���1F��l�yqBϽ��ߌ�����      �   �   x���v
Q���W((M��L�K�-�ɯL�O.�/R��HM�)�HN,J-(�/�LI-�L�Q��f�h*�9���+h�{8 ��������3��i��IKLib��F4���c��`�d�	Ml0E���&6�!�`N̑l���H6X��K�� �� gV2�      �   �  x�͖�N�0��y
��(J�CZ��(]hQSV+��И:vd;얧_*�Hnb{F���?��U��l��j�&u�c4���8"��vE���P�4�
RѢ`���ӺyS�P+�, P�
���W��T3� ���O�����y�A@�
�}�,�aaW���Vi�G�I:�a��پ�R� 1�EeMqB�r��\"��6��8��(2�L��?Ɲ\�2Q�\|;���ĆpGv�AE=P
]xi�)��Y����]�Y��a�JZF-�i����A�a�3C{�g��� ��	ҋ#�=��nލ[ȝ�`<!WX�t2ZnN��� ��=�j�)0�t�0����S�J4.�%�$e^��K�Ҹ����ŐNɚ�7�J8J�2H[
�r%�,(-�%������/��`�ӥ���e̋q�7v�"��p	�+,�x�I���`�s�S���	�0p���y.g��+k�BH�d	�����J�0k1<�6Q�=�Y1p����8�
q�e��GN-��3:��.�IJ�2/i� ,EéR��[%4J�
M�@�Fs$�{�b�+�����w�!��>Qp�Kb:#�FZ"~�IҪa����c{���3�NY	�:��2^���.�шdW����v�V7�&r[z[!S?H�B���.EC��D?5���n�5܉�`���V1��P�8D��st2C�"���7�4�����=+      �   �  x�͔�o�0�����	]ڂ���E�1珈[��k�f����׏:�i��K!__��pͷ;�vkt<�J~݉����\��B�II4y�!.J%�JԱ�K�g���S�"#2�y"��>}}�G��̗R>�q��H@	n�u
Ʈ��9TF(�d��о-�e����3K�����
 n�&f�[̞%�BZ�~ʺ�+��茔��Ôu۷$��}U�i\�� ߦ:	�ǘ�1�y��L�t{�h��$��
�j�*�4�PL&��,�v?F�4K�yvjl�&#L;�=�$3Puk.���aiy#�ۊ��2��!)��={�n̗z� ��pQ�Ǆat�䓶��s
�O	���tT��>����#Z��ږG	���"�#�W�^��>U      �   �  x�͕]o�0����V����کW@�`�#�I�;$g�Q'�4���]��.Q��#�����b���X,7_�nv��w�0E��jU�9'o�8��T�XR[3��ՊJ�l��0�i}	���,���|����#���������`əkmKq2���_ۗ�~'!�R�X
2L�Uc�����������+�h�W�f�����C����{X���X*��_�/�󷆳gX�J����'�惽]u��{;ǧ��]��Ѕw�%�����!���<N��x�lו���^���(CU�Ԯ'�)c�l�B'kdz\�;;M�y%;@��0+I=������l�(�\�n���o
?���ko�4�3h�����4:�̹����p&���t�n|�$�R'�����)*�'-��Q��L��\�&��;@�w�;���9/Vj�q�9���Q�ij�
D� Jb�#k�d�N���� ה���%��ؓ�1�z���B      �   Z  x�ŖMs�0���{#���f���BJf��ڞ���;�%�$��_ߕ-p{�I_���_���xy�,�(���5iWZ�%Jh�<[j����
�%褥�C��B+v��B�Vs*�`����V��zx�9_���Q8��@�|+v8�`�}��5�k������
!k����5)^�l:_��C�����׋��Ȟ~�-�	�-�jU�-�����!E� �Af�8һ�(�Ţ��׾��x)o{���E��\����[�?�'� �C��7Sc!7Lh�k>v�I�y`�mozg�;�ړP0;�ܼ	d�� [���-jL�;���S��IG����3�>Z�����>����.h��S{�O�>-Va|5{�GW6㫼�鶉�^8oM�q��?�|�?���I�+�G�wkSc0J�,&���2�c�#����λ�*A�n��\5����Lu�:d0�=�~L��1�
��;y�e��gֵ/NҮ�c"?����P����#l�ݧ������ɴwծQ����b_!T�n)����6fD�R����"����O[�t�P��ɒ�B4�ngm��s�HN��Ӳn��Y�M�I�jQ���y^N�_��d      �   @  x��U�r�0��+�F2�[�4LO��BK(���ey���#ɡ�}W2fz�9 Z���v�[/V/��,V�߰k2%Š�\
�
mr�BI���� E.t�}ȹCa��)*t�K'u]���F�|��L������/1}�^z�8����(��(I�jsؕZ���h�9�8���Fr�.P�{{7߯_�y@?Y<��$�X|�95�%�g}lQ�W���.��Ĥ=AL\�����C�%ɉ��Em�ʏ��A��%!��xZPo�B�3���:�1
%N�S/�4J�9k}����������ܖ�)�s���1���_,��Q|� ��:���]ɷH��P��Vbd�d���㹦�zL�4��1"�^���dؠ��r�ҕ���w�<����7�)�3���Z�=L�x�5�A3����J���i�N4��L� ��!�T�8J�z���6��A���ɖ��t��JKnpP *o`J��5�H���/4�X�
H��`ch���4�ik����=��)��zF���)��/CxM-�z�zb��Ƞ�) �E!E���󰈾3Bi���7b�su��sr�      �   �  x���Mo�0��������W7�Ե���8-v�%&&*K�(��~�D'�.��'J �|_r�X�6[X?n�A�k��%��P����8�[Z�%1���������Ӫ����]uY����_�SD���e��nrbO@��e�Z) ���^4�.5��ϳ�D�o���$���1�8 zt��(��2&�z�6�[�7eR��J�cq�`�������L
�3�B<I� )f�r�i��)��f�A������G�]�剄��e�vN
�^a�7�?�)�6�J�ؼ5X��t�[$L-��=䶋�uІ1c�����<�1G��m��ߧI�"��fYeb-�G�����1(�镆���� ޱ�yb��J��RD	����@=�	��}��y�{�6�'E�r鄚��l���I��ae��:��C��NF���TI)�8��.�b[��E��P*�̧IP0ya���ʪ+�,���f �e
      �   g  x����k�0�{���lAK�F[v�ҁ�v��g�V�i"F;���Y��U<$����=_x<�N/o(�>R/sZK4�,OE��)^�UBK0�D�KS}P�B��������au��}�׶^;�q-l[6V;��c��ŝŀ^��x���`6=��a�&j�?�6�,�(*DR2~Ӭ�T� ZժS�,�U�6�H��jJYQ�D5�����kM�MUR��*C�3u�4$Kݺ�ܶ�'&�Q �����ՠý����uU�eU<
�j���d�OG�;�l��>�{�|U��6�u��ǀp�*q��� D�>Y<~^����e�v�'��~�Q��5}#lT~3B=2��9Cg�_����      �   w  x����n�0�{��ܡ	��)fWιh�92�v]�D��b�B�ۯ���@�(�^4��=�m�z��f�{�S�笘�j�~ø��ڣtϴ�E��JS�K��슲�`B5��O�
A+�����c���ɶ��<��BLȔ���G|��W~����*V�)�G��y��a��40�YlA�4��=����9JB��=-j�iW-��$�B�vjd�-���O��J)�Q˺EIxgi�5����jj䅤���p�',�B_b0\d�Ilrb����Ҋ�o�d�Ѩk1�vf$���Y����LbŚ
��s�J���OhO��
���)MrL����6un�5�� G�j	���B�6 ��zYؿ�c���Dh������
      �   /  x��Աn�0�=O�- �9v��H����K�����텶��t�Og�ç;�/v������a�.�'g����ʲ�99{n]5cUmں��j��3�;|k��픽.��M�&�j[������	���k�Zp!����8_p>}��	�(�@xTPN@@@�a�D�iy28)�<~aF&	H��@��tOJ<9�hσ��<@��}�r��$̛֤C)%y*(# � ݻ��vy��I�Q�4�5h|9-��i���i��(���Ɛ��3XN랉��Q�	�!ݠ      �   T  x����n�0�=_�]@�*�Y]��H��]��y ���P�? xu���G֋����f���v�N�Q�"�$jF�kZ��H��� Z�������s�o��t�9�Q3JY\�n�F��:sr�I��;ݸ���bF�F���0�5<j�6�z�I�r���fn�>���3S��ڪ����ɍ�S��*JKD��~�������k���@@�����W�g�Ͳ��4~ f����*�<�mV`���>eF!��ck�9>R���PPB9��`L\:�T#w�<�q��)e@�H��,���G�͎�r5Qz �S��IU�?���5��A޿��)\��F�� �      �   �  x�՗Ok�0�����BS�h�e��� �����N�Ȱ�j��/����j*��y�����o���ě��۷Bd�3�ly#�"'0姺��9�d��ԣ<�<;suT��T��T�>W_i��T��*�hDU��x]%��L�����zs�=&�c=&�aح�����<7+0�f�x4tb���@�gY�Uu��|�=����e.�wuisLg��Gj�=�!�Sq:�����/�	���K�	�U��W#nf`T7�9�$�b��@�3�3�,M0|���
����
x��/XطAf�<����nb���E������Gw|i�f�Bۓ݅Ʒ�Q��fvڒ4�O���9��N;m��K=���֖�����p���o˛L~ ���      �   �   x����
�@��O1;4t�U�� i�M$�ƞ?K�;������<:(N�ӵk����{�x?"��Zv�mm�eyW�ʎ7U9�a�m�>k]r���.9G9��0���l�@�>�>�ǵ���i[���[%�;,`��0�8Ƒ�! C �"��0��q�`<�� �0�
0T�P9`|���/ L 0��	�`l�Yz�,���ߌQ�?ޟ(      �   �   x����
�@�Oqw� ��;�JBb�,RۧI�I墷o��� ׻:���Y\����{�Zu���*f���u��n��x�ۇ�뷶��dUZ��6�t�qf;�)SN��]f�IƸ3Ý���ᴌ��1>- �EL@˄���c"�x��h��1����#&&e~��g���^3��Ko(.      �   �  x����n�8�}�B� m���Hɒ�M�4h�if��mҦ.%����ϡ���P/j��&�3� ��'u����_��݇��Q7��.��u�s�KW���Kۀ���^���:p�kk+N]D�5x��zYA�"����߷����E����������2U�Ug��de[�����<���ԝ��]�[�l�g�x��K���'/��%�Q�]��r�������Wgw����}g��~Y�A����̣��5�]�Az�$�3
`[����Iɓ�ά��́�6T��%���3��>���'�ف�5[��N�1����P��L�� ��܄9�
�3M�Z�Q�a>�x1�������ͻ�9(`;���+Y�6�c�1Z6�/%q�x,D~	'�t���:<� ����%!J2� �e(�%%K:�P?�V�Q�D�ҫ������X�-۷n��qr���7;`��5k���)(���Nx��/f�T��4�ma�z�}�~s?�q=;`�_o��Q0��B�c081�\b��11Ƣo�6��-Ođ�c��[U�Ap��c�ǚ��28ƒ�y��##F����%8HN�����g�1�� G1���jU����1U�� �
��K��7��W5:v
K���u[����F�,���(g�0?��+�V����~��GGI���2����4)iR�5�A����,ɲ��㍂Fp��D0a���K�ͼn�9i�yw��')HR�gF���fI�e*�{�p��6<�/�oo�U��`z�����48cʫ��ﾜx;��'�>�J�ǘ_rq)R��,��HA�1��ufpL���=�0&d�B-+�e��u}j(�'�L	9F��?س	�J��Ҟ sI�1[|��4�9�j	�ml;t' �:YK�;�r�F�����9)�D��S�q�\'K�ͺޝ�� �U�ltk�Nl�A���邠c��p��Y9O�SY��x�N9�A;�6��<���_B��&     