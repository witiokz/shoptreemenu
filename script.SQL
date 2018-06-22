--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4
-- Dumped by pg_dump version 10.4

-- Started on 2018-06-03 21:02:33

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12924)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2825 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 199 (class 1259 OID 16407)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    active boolean NOT NULL,
    parent_id integer
);


ALTER TABLE public.category OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 16405)
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_id_seq OWNER TO postgres;

--
-- TOC entry 2826 (class 0 OID 0)
-- Dependencies: 198
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_id_seq OWNED BY public.category.id;


--
-- TOC entry 197 (class 1259 OID 16396)
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    active boolean NOT NULL,
    price numeric NOT NULL
);


ALTER TABLE public.product OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 16413)
-- Name: product_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category (
    product_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.product_category OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 16394)
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_id_seq OWNER TO postgres;

--
-- TOC entry 2827 (class 0 OID 0)
-- Dependencies: 196
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_id_seq OWNED BY public.product.id;


--
-- TOC entry 2682 (class 2604 OID 16410)
-- Name: category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN id SET DEFAULT nextval('public.category_id_seq'::regclass);


--
-- TOC entry 2681 (class 2604 OID 16399)
-- Name: product id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product ALTER COLUMN id SET DEFAULT nextval('public.product_id_seq'::regclass);


--
-- TOC entry 2816 (class 0 OID 16407)
-- Dependencies: 199
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id, name, active, parent_id) FROM stdin;
\.


--
-- TOC entry 2814 (class 0 OID 16396)
-- Dependencies: 197
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, name, active, price) FROM stdin;
\.


--
-- TOC entry 2817 (class 0 OID 16413)
-- Dependencies: 200
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category (product_id, category_id) FROM stdin;
\.


--
-- TOC entry 2828 (class 0 OID 0)
-- Dependencies: 198
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_id_seq', 5598, true);


--
-- TOC entry 2829 (class 0 OID 0)
-- Dependencies: 196
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_id_seq', 22732, true);


--
-- TOC entry 2686 (class 2606 OID 16412)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- TOC entry 2688 (class 2606 OID 16417)
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (product_id, category_id);


--
-- TOC entry 2684 (class 2606 OID 16404)
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- TOC entry 2689 (class 2606 OID 16428)
-- Name: category category_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.category(id);


--
-- TOC entry 2691 (class 2606 OID 16423)
-- Name: product_category product_category_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- TOC entry 2690 (class 2606 OID 16418)
-- Name: product_category product_category_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(id);


-- Completed on 2018-06-03 21:02:36

--
-- PostgreSQL database dump complete
--

