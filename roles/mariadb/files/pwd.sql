update mysql.user set Password=password('mypwdtest') where User='root';
commit;
