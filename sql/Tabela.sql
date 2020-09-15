CREATE TABLE logdownload (
    codigo     NUMERIC (22, 0) NOT NULL
                               PRIMARY KEY,
    url        VARCHAR (600)   NOT NULL,
    datainicio DATE            NOT NULL,
    datafim    DATE
);
